from multiprocessing import AuthenticationError
import random
import signal
import socket

from httpcore import request
from serialization import *

secret_num = None
server_addr = None
server_port = None
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

def connect(addr, port, secret):
    global server_addr
    global secret_num
    global server_port

    server_addr = addr
    server_port = port
    secret_num = secret


response_decode_handlers = {
    PACKETS["open_response"]: decode_open_response,
    PACKETS["read_response"]: decode_read_response,
    PACKETS["write_response"]: decode_write_response,
    PACKETS["lseek_response"]: decode_lseek_response,
    PACKETS["chmod_response"]: decode_chmod_response,
    PACKETS["unlink_response"]: decode_unlink_response,
    PACKETS["rename_response"]: decode_rename_response
}


def decode_response(packet_type, body):
    handler = response_decode_handlers.get(packet_type)
    if handler:
        return handler(body)
    else:
        raise Exception(f"No decode handler for {PACKETS_INV[packet_type]}")


def do_request(packet_type, request_body):
    def no_answer(x, y):
        print(x, y)
        print("Can't receive an answer from server")
        raise TimeoutError("Connection timed out")

    packet_id = random.randint(1, 1000)
    header = encode_request_header(secret_num, PACKETS[packet_type], packet_id)
    packet = header + request_body
    sock.sendto(packet, (server_addr, server_port))

    signal.signal(signal.SIGALRM, no_answer)
    signal.alarm(20)

    while True:
        buffer, _ = sock.recvfrom(server_port)
        response_packet_type, response_packet_id, body = decode_response_header(
            buffer)

        if response_packet_id == packet_id:
            if response_packet_type == PACKETS["unauthorized_response"]:
                raise AuthenticationError("Invalid auth token")

            return decode_response(response_packet_type, body)


def request(packet_type, request_body):
    for _ in range(2):
        try:
            return do_request(packet_type, request_body)
        except AuthenticationError as e:
            raise e
        except TimeoutError:
            pass


def open(file_path, flags):
    response = request(
        "open_request",
        encode_open_request(file_path, flags)
    )

    if isinstance(response, Exception):
        raise response

    return File(response)


def chmod(file_path, mod):
    response = request("chmod_request", encode_chmod_request(file_path, mod))

    if isinstance(response, Exception):
        raise response


def unlink(file_path):
    response = request("unlink_request", encode_unlink_request(file_path))

    if isinstance(response, Exception):
        raise response


def rename(old_path, new_path):
    response = request(
        "rename_request", encode_rename_request(old_path, new_path))

    if isinstance(response, Exception):
        raise response


class File:
    def __init__(self, file_id):
        self.file_id = file_id

    def read(self, size=-1):
        response = request("read_request",
                           encode_read_request(self.file_id, size)
                           )

        if isinstance(response, Exception):
            raise response

        return response

    def write(self, data):
        response = request(
            "write_request", encode_write_request(self.file_id, data))

        if isinstance(response, Exception):
            raise response

    def seek(self, pos, how=0):
        response = request(
            "lseek_request", encode_lseek_request(self.file_id, pos, how))

        if isinstance(response, Exception):
            raise response
