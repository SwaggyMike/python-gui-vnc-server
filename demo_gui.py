#!/usr/bin/env python3
"""Minimal GUI demo for VNC/noVNC containers."""

from datetime import datetime
import os
import tkinter as tk

from dateutil import tz
import humanize


def _int_env(name: str, default: int) -> int:
    raw = os.environ.get(name)
    if raw is None:
        return default
    try:
        return int(raw)
    except ValueError:
        return default


class MinimalDemo:
    def __init__(self, root: tk.Tk) -> None:
        self.root = root
        self.root.title("Minimal Python GUI Demo")

        # Match the app window to container display dimensions when available.
        screen_width = _int_env("SCREEN_WIDTH", root.winfo_screenwidth())
        screen_height = _int_env("SCREEN_HEIGHT", root.winfo_screenheight())
        self.root.geometry(f"{screen_width}x{screen_height}+0+0")

        self.root.configure(bg="#0f172a")

        frame = tk.Frame(root, bg="#0f172a", padx=20, pady=20)
        frame.pack(fill=tk.BOTH, expand=True)

        title = tk.Label(
            frame,
            text="Container GUI Demo",
            font=("DejaVu Sans", 16, "bold"),
            bg="#0f172a",
            fg="#f8fafc",
        )
        title.pack(anchor="w", pady=(0, 14))

        self.time_label = tk.Label(
            frame,
            text="",
            font=("DejaVu Sans Mono", 12),
            bg="#0f172a",
            fg="#93c5fd",
        )
        self.time_label.pack(anchor="w")

        self.uptime_label = tk.Label(
            frame,
            text="",
            font=("DejaVu Sans", 12),
            bg="#0f172a",
            fg="#cbd5e1",
        )
        self.uptime_label.pack(anchor="w", pady=(8, 0))

        self.count = 0
        self.count_label = tk.Label(
            frame,
            text="Clicks: 0",
            font=("DejaVu Sans", 12),
            bg="#0f172a",
            fg="#86efac",
        )
        self.count_label.pack(anchor="w", pady=(8, 16))

        button_row = tk.Frame(frame, bg="#0f172a")
        button_row.pack(anchor="w")

        increment_button = tk.Button(
            button_row,
            text="Increment",
            command=self.increment,
            padx=10,
            pady=6,
            relief=tk.FLAT,
            bg="#2563eb",
            fg="white",
            activebackground="#1d4ed8",
            activeforeground="white",
        )
        increment_button.pack(side=tk.LEFT)

        quit_button = tk.Button(
            button_row,
            text="Quit",
            command=root.destroy,
            padx=10,
            pady=6,
            relief=tk.FLAT,
            bg="#ef4444",
            fg="white",
            activebackground="#dc2626",
            activeforeground="white",
        )
        quit_button.pack(side=tk.LEFT, padx=(10, 0))

        self.started = datetime.now(tz.UTC)
        self.tick()

    def increment(self) -> None:
        self.count += 1
        self.count_label.configure(text=f"Clicks: {self.count}")

    def tick(self) -> None:
        now_local = datetime.now(tz.tzlocal())
        elapsed = datetime.now(tz.UTC) - self.started

        self.time_label.configure(text=f"Local time: {now_local.strftime('%Y-%m-%d %H:%M:%S %Z')}")
        self.uptime_label.configure(
            text=f"Uptime: {humanize.precisedelta(elapsed, minimum_unit='seconds')}"
        )

        self.root.after(1000, self.tick)


def main() -> None:
    root = tk.Tk()
    MinimalDemo(root)
    root.mainloop()


if __name__ == "__main__":
    main()
