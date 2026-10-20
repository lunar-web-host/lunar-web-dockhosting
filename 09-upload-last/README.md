# Lunar Web hosting package


Upload **the contents of this folder**, including `docs`, to the root of your
`lunar-web` repository using GitHub's **Add file > Upload files** screen. Keep all
`payload-*.part` files at the repository root. Upload and commit one part at a
time, then upload the remaining files and `docs` together as the final commit.
The build filter waits for that final metadata commit. These parts are
application resources split to fit GitHub's browser upload limit; do not unpack
or rename them. No Git command, Java installation, or local host is needed on a
player's MacBook.

Render builds the root `Dockerfile`, verifies both the individual parts and the
complete application payload, and runs Java on Render. The server listens on
Render's assigned port and provides authentication and server connections.
The configured service is https://lunar-web-5ql8.onrender.com/.

In GitHub **Settings > Pages**, choose **Deploy from a branch**, your uploaded
branch (normally `main`), and **/docs**, then save. GitHub Pages opens the full Render app automatically.
Private repository Pages availability depends on your
GitHub plan; the resulting Pages site is public unless your plan supports and
enables private publishing.

The package contains public client resources and server sources. Local account
files, refresh tokens, game profiles, logs, and device identifiers are excluded.
Browser login sessions stay in server memory and end when the service restarts.
Render's Free service can sleep when idle; allow time for it to wake up.

`render.yaml` describes the free Docker service for a Render Blueprint. For an
existing Render service, select this repository, the uploaded branch, the root
Dockerfile, `/healthz` as the health check, and automatic deployment on commits.
Do not set a custom Docker command; use the Dockerfile's entry point.
