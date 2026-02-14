# python-gui-vnc-server

Fedora-based container for running a single Python GUI application over VNC and noVNC.

## Components

- Xvfb (virtual display)
- x11vnc (VNC server)
- noVNC + websockify (browser client)
- Python 3 + Tkinter

## Files

- `Dockerfile`
- `entrypoint.sh`
- `demo_gui.py`
- `requirements.txt`

## Build

```sh
podman build -t python-gui-vnc-server .
```

## Run Demo

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
- Default VNC password: `containergui`

## Run Your Own App

Mount your project and set `APP_COMMAND`.

```sh
podman run --rm --name python-gui-vnc-server-app \
  -p 5900:5900 \
  -p 6080:6080 \
  -e VNC_PASSWORD=containergui \
  -e APP_WORKDIR=/workspace \
  -e APP_COMMAND="python3 main.py -g" \
  -v "$PWD:/workspace:Z" \
  python-gui-vnc-server
```

The container exits when `APP_COMMAND` exits.

## Dependencies

Edit `requirements.txt` and rebuild:

```sh
podman build -t python-gui-vnc-server .
```

For project-specific dependencies, create a child image:

```dockerfile
FROM python-gui-vnc-server
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt
COPY . /workspace
ENV APP_COMMAND="python3 main.py -g"
```

## Environment Variables

- `VNC_PASSWORD` (default: `containergui`)
- `APP_WORKDIR` (default: `/workspace`)
- `APP_COMMAND` (default: `python3 /opt/demo/demo_gui.py`)
- `SCREEN_WIDTH` (default: `1280`)
- `SCREEN_HEIGHT` (default: `800`)
- `SCREEN_DEPTH` (default: `24`)
