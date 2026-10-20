# Payload parts allow this repository to be uploaded through GitHub's website.
FROM eclipse-temurin:17-jdk-jammy AS payload
WORKDIR /payload
COPY payload-*.part payload.parts.sha256 payload.sha256 ./
RUN sed -i 's/\r$//' payload.parts.sha256 payload.sha256 \
    && sha256sum -c payload.parts.sha256 \
    && cat payload-*.part > payload.zip \
    && sha256sum -c payload.sha256 \
    && mkdir /context \
    && cd /context \
    && jar --extract --file /payload/payload.zip

# Build from the sanitized directory produced by tools/export-render.ps1.
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /build
COPY --from=payload /context/server/src/ ./src/
RUN find src -name '*.java' -print > sources.txt \
    && javac --release 17 -encoding UTF-8 -d classes @sources.txt \
    && jar --create --file lunarweb-server.jar --main-class lunarweb.Main -C classes .

FROM eclipse-temurin:17-jre-jammy
# Java's headless font rasterizer still requires fontconfig and a fallback font.
RUN apt-get update \
    && apt-get install -y --no-install-recommends fontconfig fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --uid 10001 --create-home lunarweb
WORKDIR /app
COPY --from=build /build/lunarweb-server.jar ./server/lunarweb-server.jar
COPY --from=payload --chown=lunarweb:lunarweb /context/dist/ ./dist/
COPY --from=payload --chown=lunarweb:lunarweb /context/cloud/lunar-install/ ./cloud/lunar-install/
COPY --from=payload --chown=lunarweb:lunarweb /context/cloud/minecraft/ ./client/desktopRuntime/resources/assets/minecraft/
ENV LUNARWEB_CLOUD=true \
    LUNARWEB_LUNAR_DIR=/app/cloud/lunar-install \
    LUNARWEB_DATA_DIR=/tmp/lunar-web \
    JAVA_TOOL_OPTIONS="-Xms32m -Xmx320m -XX:+UseSerialGC -Djava.awt.headless=true -Dfile.encoding=UTF-8"
# Evaluation profile for a confirmed 1 GiB host; 16 slots is not a gameplay benchmark.
ENV PORT="10000" \
    LUNARWEB_CLOUD="true" \
    LUNARWEB_LUNAR_DIR="/app/cloud/lunar-install" \
    LUNARWEB_DATA_DIR="/tmp/lunar-web" \
    LUNARWEB_MAX_SESSIONS="16" \
    LUNARWEB_MAX_CONNECTIONS="192" \
    JAVA_TOOL_OPTIONS="-Xms32m -Xmx512m -XX:+UseSerialGC -Djava.awt.headless=true -Dfile.encoding=UTF-8"
USER lunarweb
EXPOSE 10000
ENTRYPOINT ["java", "-jar", "/app/server/lunarweb-server.jar", "--no-browser", "--dist", "/app/dist"]
