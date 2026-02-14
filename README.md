# python-gui-vnc-server

Fedora image for running one Python GUI app over VNC/noVNC.

## Included

- Xvfb
- x11vnc
- noVNC + websockify
- Python 3 + Tkinter

## Build

```sh
podman build -t python-gui-vnc-server .
```

## Run demo

```sh
podman run --rm --name python-gui-vnc-server \
  -p 5900:5900 \
  -p 6080:6080 \
  -e VNC_PASSWORD=containergui \
  python-gui-vnc-server
```

## Connect

- noVNC: `http://localhost:6080/vnc.html`
- VNC: `localhost:5900`
- Password: `containergui`

## Run your own app

Use your project as `/app` and set `APP_COMMAND`.

```sh
podman run --rm --name python-gui-vnc-server-app \
  -p 5900:5900 \
  -p 6080:6080 \
  -e VNC_PASSWORD=containergui \
  -e APP_WORKDIR=/app \
  -e APP_COMMAND="python3 your_app.py" \
  -v "$PWD:/app:Z" \
  python-gui-vnc-server
```

The container stops when `APP_COMMAND` exits.

## Dependencies

Update `requirements.txt`, then rebuild.

```sh
podman build -t python-gui-vnc-server .
```

For project-specific dependencies, use a child image:

```dockerfile
FROM python-gui-vnc-server
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt
COPY . /app
ENV APP_COMMAND="python3 your_app.py"
```

## Environment variables

- `VNC_PASSWORD` default: `containergui`
- `APP_WORKDIR` default: `/app`
- `APP_COMMAND` default: `python3 /app/demo_gui.py`
- `SCREEN_WIDTH` default: `1280`
- `SCREEN_HEIGHT` default: `800`
- `SCREEN_DEPTH` default: `24`
