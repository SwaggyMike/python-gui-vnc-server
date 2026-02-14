#!/usr/bin/env bash
set -euo pipefail

DISPLAY="${DISPLAY:-:1}"
VNC_PORT="${VNC_PORT:-5900}"
NOVNC_PORT="${NOVNC_PORT:-6080}"
VNC_PASSWORD="${VNC_PASSWORD:-containergui}"
SCREEN_WIDTH="${SCREEN_WIDTH:-1280}"
SCREEN_HEIGHT="${SCREEN_HEIGHT:-800}"
SCREEN_DEPTH="${SCREEN_DEPTH:-24}"
APP_WORKDIR="${APP_WORKDIR:-/app}"
APP_COMMAND="${APP_COMMAND:-python3 /app/demo_gui.py}"

mkdir -p /tmp/.X11-unix /root/.vnc "${APP_WORKDIR}"
chmod 1777 /tmp/.X11-unix

x11vnc -storepasswd "${VNC_PASSWORD}" /root/.vnc/passwd >/dev/null

Xvfb "${DISPLAY}" \
  -screen 0 "${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_DEPTH}" \
  -ac +extension GLX +render -noreset \
  >/tmp/xvfb.log 2>&1 &

x11vnc \
  -display "${DISPLAY}" \
  -rfbport "${VNC_PORT}" \
  -rfbauth /root/.vnc/passwd \
  -forever \
  -shared \
  -noxdamage \
  -repeat \
  -xkb \
  >/tmp/x11vnc.log 2>&1 &

websockify --web /usr/share/novnc "${NOVNC_PORT}" "localhost:${VNC_PORT}" >/tmp/novnc.log 2>&1 &

echo "VNC: localhost:${VNC_PORT}"
echo "noVNC: http://localhost:${NOVNC_PORT}/vnc.html"
echo "App: ${APP_COMMAND}"

exec sh -lc "cd \"${APP_WORKDIR}\" && DISPLAY=\"${DISPLAY}\" ${APP_COMMAND}"
