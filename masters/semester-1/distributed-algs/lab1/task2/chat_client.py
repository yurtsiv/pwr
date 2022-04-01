from email import message
import sys
from tkinter import CURRENT
from typing import Text

from matplotlib.pyplot import text
sys.path.append("proto")

import threading
import curses
from curses.textpad import Textbox, rectangle
from curses import wrapper
import grpc
import proto.chat_pb2_grpc as pb2_grpc
import proto.chat_pb2 as proto


def connect():
    channel = grpc.insecure_channel('localhost:50051')
    stub = pb2_grpc.ChatServerStub(channel)
    return stub

def main(stdscr):
    stdscr.clear()
    curses.init_pair(1, curses.COLOR_BLUE, curses.COLOR_BLACK)
    USERNAME_COLOR = curses.color_pair(1)
    stdscr.nodelay(True)

    stdscr.addstr("Connecting to the server...")
    stub = connect()
    stdscr.clear()
    stdscr.refresh()

    chat_pad = curses.newwin(curses.LINES - 2, curses.COLS, 0, 0)
    msg_input_win = curses.newwin(1, curses.COLS, curses.LINES - 1, 0)
    textbox = Textbox(msg_input_win)

    def redraw(messages):
        chat_pad.clear()
        chat_pad.refresh()

        for m in messages:
            chat_pad.addstr("\n" + m.name, USERNAME_COLOR)
            chat_pad.addstr(": " + m.message)

        # chat_pad.refresh(0, 0, 0, 0, curses.LINES - 2, curses.COLS)
        chat_pad.refresh()

    def receive_messages():
        messages = []
        for message in stub.ChatStream(proto.Empty()):
            messages.append(message)
            redraw(messages)

    def listen_textbox():
        while True:
            textbox.edit()
            text = textbox.gather()
            stub.SendNote(
                proto.Note(
                    name="Test",
                    message=text
                )
            )
            msg_input_win.clear()
            msg_input_win.refresh()

    redraw([])
    r = threading.Thread(target=receive_messages)
    l = threading.Thread(target=listen_textbox)
    r.start()
    l.start()
    l.join()
    r.join()

wrapper(main)