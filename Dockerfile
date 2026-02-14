FROM fedora:latest

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

WORKDIR /app

COPY requirements.txt /app/requirements.txt
COPY demo_gui.py /app/demo_gui.py
COPY entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh && \
    if [ -s /app/requirements.txt ]; then \
      pip3 install --no-cache-dir -r /app/requirements.txt; \
    fi

ENV DISPLAY=:1 \
    VNC_PORT=5900 \
    NOVNC_PORT=6080 \
    VNC_PASSWORD=containergui \
    SCREEN_WIDTH=1280 \
    SCREEN_HEIGHT=800 \
    SCREEN_DEPTH=24

EXPOSE 5900 6080

ENTRYPOINT ["/app/entrypoint.sh"]
