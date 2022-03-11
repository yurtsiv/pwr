#!/usr/bin/env python3

from gui.Application import run_gui

try:
    run_gui()
except (KeyboardInterrupt, EOFError):
    print("Exiting")
