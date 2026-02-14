FROM fedora:latest

ENV DISPLAY=:1 \
    VNC_PORT=5900 \
    NOVNC_PORT=6080 \
    VNC_PASSWORD=containergui \
    SCREEN_WIDTH=1280 \
    SCREEN_HEIGHT=800 \
    SCREEN_DEPTH=24 \
    APP_WORKDIR=/workspace \
    APP_COMMAND="python3 /opt/demo/demo_gui.py" \
    PYTHONUNBUFFERED=1

RUN dnf -y install --setopt=install_weak_deps=False \
      novnc \
      python3 \
      python3-pip \
      python3-tkinter \
      python3-websockify \
      x11vnc \
      xorg-x11-server-Xvfb && \
    dnf clean all && \
    rm -rf /var/cache/dnf

WORKDIR /opt/demo

COPY requirements.txt /opt/demo/requirements.txt
COPY demo_gui.py /opt/demo/demo_gui.py
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh && \
    mkdir -p /workspace && \
    if [ -s /opt/demo/requirements.txt ]; then \
      pip3 install --no-cache-dir -r /opt/demo/requirements.txt; \
    fi

EXPOSE 5900 6080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
