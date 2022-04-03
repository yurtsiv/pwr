import sys
sys.path.append("proto")

import proto.chat_pb2 as proto
import proto.chat_pb2_grpc as pb2_grpc
import grpc
from curses import wrapper
from curses.textpad import Textbox
import curses
import threading
import os

port = 0
try:
    port = int(sys.argv[1])
except Exception:
    print("Please, pass a port number")
    sys.exit()


def main(stdscr, stub, username):
    curses.noecho()
    curses.init_pair(1, curses.COLOR_BLUE, curses.COLOR_BLACK)
    stdscr.nodelay(True)
    stdscr.clear()
    USERNAME_COLOR = curses.color_pair(1)

    chat_pad = curses.newpad(10000, curses.COLS)
    msg_input_win = curses.newwin(1, curses.COLS - 2, curses.LINES - 1, 2)
    textbox = Textbox(msg_input_win, insert_mode=True)

    stdscr.addstr(curses.LINES - 1, 0, ">")
    stdscr.refresh()

    lock = threading.Lock()

    def redraw_messages(messages):
        chat_pad.clear()

        for m in messages:
            chat_pad.addstr("\n" + m.name, USERNAME_COLOR)
            chat_pad.addstr(": " + m.message)

        p_lines, _ = chat_pad.getyx()
        chat_pad.refresh(p_lines - curses.LINES + 2, 0, 0, 0, curses.LINES - 2, curses.COLS)

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
except Exception as e:
    print("Failed to connect")
    sys.exit()
else:
    print("Username: ", end="")
    username = input()
    wrapper(main, stub, "username")
