# Lunar Web Docker hosting candidate — DockHosting

**DRAFT — REGISTRATION, DEPLOYMENT AND THE PUBLIC BACKEND ADDRESS ARE PENDING.**
Do not upload this draft as the final deployment or switch the live Pages launcher.
No backend URL has been invented.

This is a self-contained Docker build context. Its root Dockerfile restores
the sanitized application from checksummed eight-MiB payload parts, compiles
the Java 17 server, and includes the browser client and original Lunar UI.
Keep every payload part and both checksum files together and unchanged.

The candidate profile has a 512 MiB Java heap, 16 isolated browser session
slots, and a 192-socket HTTP/WebSocket limit for evaluation on a confirmed
1 GiB instance. These are configured limits, not a measurement of 16 concurrent
authenticated players or a promise of better performance or availability.
DockHosting's free offer advertises up to 1 GB RAM and no credit card; its CPU
allocation, Minecraft egress, WebSocket stability and actual account eligibility
still require live verification. Do not choose a paid plan or provide card/ID
verification for this migration.

Connect the intended source repository to DockHosting, select its root
Dockerfile, retain its entry point, and use /healthz as the health check where
the platform supports one. The application binds to 0.0.0.0 and reads PORT.
The image defaults PORT to 10000; the platform may override it. Match any
manually selected application port to PORT. Do not add a custom start command.
After a real HTTPS address is assigned, set LUNARWEB_PUBLIC_URL to that exact
origin in the platform environment settings. No account token or password
belongs in environment variables or this package.

The deployment-config.json file records only public configuration. This export
does not create an account, repository, deployment or GitHub Pages site. Keep
the existing working deployment until the candidate's full client, session
isolation, long-lived WebSockets, outbound TCP port 25565, authentication
services and signed-in gameplay have been verified from the new host.

Once the assigned origin is verified, regenerate this package with
--provider dockhosting --backend-url https://YOUR-CONFIRMED-BACKEND and upload
the resulting docs contents for Pages. For branch-based Pages publishing use
Settings > Pages > Deploy from a branch > main > /docs > Save. Leave activation
to the repository owner. Repository plan and visibility must support Pages.
The draft Pages configuration is blank and asks for a backend address.

Local account files, refresh tokens, game profiles, logs and installation/device
identifiers are excluded. Cloud account sessions stay only in server memory.

Provider references: https://www.dockhosting.dev/pricing and
https://docs.dockhosting.dev/docs/deploying/docker .
