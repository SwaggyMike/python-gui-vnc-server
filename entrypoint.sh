#!/usr/bin/env bash
set -euo pipefail

: "${DISPLAY:=:1}"
: "${VNC_PORT:=5900}"
: "${NOVNC_PORT:=6080}"
: "${VNC_PASSWORD:=containergui}"
: "${SCREEN_WIDTH:=1280}"
: "${SCREEN_HEIGHT:=800}"
: "${SCREEN_DEPTH:=24}"
: "${APP_WORKDIR:=/workspace}"
: "${APP_COMMAND:=python3 /opt/demo/demo_gui.py}"

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

if [ ! -d "/usr/share/novnc" ]; then
  echo "Could not find noVNC assets at /usr/share/novnc" >&2
  exit 1
fi

websockify --web /usr/share/novnc "${NOVNC_PORT}" "localhost:${VNC_PORT}" >/tmp/novnc.log 2>&1 &

echo "Container GUI started"
echo "VNC endpoint:   localhost:${VNC_PORT}"
echo "noVNC endpoint: http://localhost:${NOVNC_PORT}/vnc.html"
echo "App command:    ${APP_COMMAND}"

sleep 0.3

exec bash -lc "cd \"${APP_WORKDIR}\" && DISPLAY=\"${DISPLAY}\" ${APP_COMMAND}"
