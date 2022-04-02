import sys
sys.path.append("proto")

import os
import threading
import curses
from curses.textpad import Textbox
from curses import wrapper
import grpc
import proto.chat_pb2_grpc as pb2_grpc
import proto.chat_pb2 as proto

def main(stdscr, stub, username):
    curses.noecho()
    curses.init_pair(1, curses.COLOR_BLUE, curses.COLOR_BLACK)
    stdscr.nodelay(True)
    stdscr.clear()
    USERNAME_COLOR = curses.color_pair(1)

    chat_win = curses.newwin(curses.LINES - 2, curses.COLS, 0, 0)
    msg_input_win = curses.newwin(1, curses.COLS - 2, curses.LINES - 1, 2)
    textbox = Textbox(msg_input_win, insert_mode=True)

    stdscr.addstr(curses.LINES - 1, 0, ">")
    stdscr.refresh()

    lock = threading.Lock()

    def redraw_messages(messages):
        chat_win.clear()

        for m in messages:
            chat_win.addstr("\n" + m.name, USERNAME_COLOR)
            chat_win.addstr(": " + m.message)

        chat_win.refresh()

    def receive_messages():
        messages = []
        for message in stub.ChatStream(proto.Empty()):
            messages.append(message)
            with lock:
                redraw_messages(messages)

    threading.Thread(target=receive_messages).start()

    while True:
        textbox.edit()
        message = str(textbox.gather()).strip()
        if message == "!quit":
            os._exit(0)

        if message != "":
            with lock:
                msg_input_win.clear()
                msg_input_win.refresh()

            stub.SendNote(
                proto.Note(
                    name=username,
                    message=message
                )
            )

def connect():
    channel = grpc.insecure_channel('localhost:6000')
    grpc.channel_ready_future(channel).result(timeout=10)
    stub = pb2_grpc.ChatServerStub(channel)
    return stub

try:
    print("Connecting to the server...")
    stub = connect()
    print("Username: ", end="")
    username = input()
    wrapper(main, stub, username)
except Exception as e:
    print("Failed to connect")
