from multiprocessing import AuthenticationError
import random
import signal
import socket
import sys

from httpcore import request
from serialization import *

TOKEN = 1000
sock = None
port = int(sys.argv[1])
server = '0.0.0.0'


def packet_type_prefix(type):
    return type.split('_')[0]


def connect():
    global sock
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)


def decode_response(packet_type, body):
    if packet_type == PACKETS["open_response"]:
        return decode_open_response(body)
    elif packet_type == PACKETS["read_response"]:
        return decode_read_response(body)
    else:
        raise ArgumentError("Invalid packet received")


def do_request(packet_type, request_body):
    def no_answer(x, y):
        print(x, y)
        print("Can't receive an answer from server")
        raise TimeoutError("Connection timed out")

    packet_id = random.randint(1, 1000)
    header = encode_request_header(TOKEN, PACKETS[packet_type], packet_id)
    packet = header + request_body
    sock.sendto(packet, (server, port))

    signal.signal(signal.SIGALRM, no_answer)
    signal.alarm(5)

    while True:
        buffer, _ = sock.recvfrom(port)
        response_packet_type, response_packet_id, rest = decode_response_header(
            buffer)

        if response_packet_id == packet_id:
            if response_packet_type == PACKETS["unauthorized_response"]:
                raise AuthenticationError("Invalid authorization token")

            return decode_response(response_packet_type, rest)


def request(packet_type, request_body):
    for _ in range(2):
        try:
            return do_request(packet_type, request_body)
        except AuthenticationError as e:
            raise e
        except TimeoutError:
            pass


def open(file_path, flags):
    if sock is None:
        connect()

    response = request(
        "open_request",
        encode_open_request(file_path, flags)
    )

    if response is IOError:
        raise response

    return File(response)


class File:
    def __init__(self, file_id):
        self.file_id = file_id

    def read(self):
        response = request("read_request",
                           encode_read_request(self.file_id)
                           )

        if response is IOError:
            raise response

        return response
