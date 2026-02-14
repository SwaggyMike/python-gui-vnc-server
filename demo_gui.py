#!/usr/bin/env python3

from datetime import datetime
import os
import tkinter as tk

from dateutil import tz
import humanize


def int_env(name: str, default: int) -> int:
    try:
        return int(os.environ.get(name, default))
    except (TypeError, ValueError):
        return default


class DemoApp:
    def __init__(self, root: tk.Tk) -> None:
        width = int_env("SCREEN_WIDTH", root.winfo_screenwidth())
        height = int_env("SCREEN_HEIGHT", root.winfo_screenheight())

        self.root = root
        self.root.title("python-gui-vnc-server demo")
        self.root.geometry(f"{width}x{height}+0+0")

        frame = tk.Frame(root, padx=16, pady=16)
        frame.pack(fill=tk.BOTH, expand=True)

        tk.Label(frame, text="python-gui-vnc-server", font=("TkDefaultFont", 14, "bold")).pack(anchor="w")

        self.time_label = tk.Label(frame, text="")
        self.time_label.pack(anchor="w", pady=(8, 0))

        self.uptime_label = tk.Label(frame, text="")
        self.uptime_label.pack(anchor="w")

        self.clicks = 0
        self.clicks_label = tk.Label(frame, text="Clicks: 0")
        self.clicks_label.pack(anchor="w", pady=(8, 12))

        buttons = tk.Frame(frame)
        buttons.pack(anchor="w")

        tk.Button(buttons, text="Increment", command=self.increment).pack(side=tk.LEFT)
        tk.Button(buttons, text="Quit", command=self.root.destroy).pack(side=tk.LEFT, padx=(8, 0))

        self.started = datetime.now(tz.UTC)
        self.update_view()

    def increment(self) -> None:
        self.clicks += 1
        self.clicks_label.config(text=f"Clicks: {self.clicks}")

    def update_view(self) -> None:
        now_local = datetime.now(tz.tzlocal())
        elapsed = datetime.now(tz.UTC) - self.started

        self.time_label.config(text=f"Local time: {now_local.strftime('%Y-%m-%d %H:%M:%S %Z')}")
        self.uptime_label.config(
            text=f"Uptime: {humanize.precisedelta(elapsed, minimum_unit='seconds')}"
        )

        self.root.after(1000, self.update_view)


def main() -> None:
    root = tk.Tk()
    DemoApp(root)
    root.mainloop()


if __name__ == "__main__":
    main()
