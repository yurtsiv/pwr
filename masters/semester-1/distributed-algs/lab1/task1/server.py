import socket
from serialization import *
import server_handlers as handlers

port = 3000

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(('0.0.0.0', port))

SERVER_SECRET = 1000

while True:
    buffer, addr = sock.recvfrom(PACKET_SIZE)

    def respond(data):
        sock.sendto(data, addr)

    secret, packet_type, packet_id, rest = decode_request_header(buffer)

    if secret != SERVER_SECRET:
        respond(
            encode_response_header(
                PACKETS["unauthorized_response"], packet_id),
        )
    elif packet_type == PACKETS["open_request"]:
        file_path, flags = decode_open_request(rest)

        response_header = encode_response_header(
            PACKETS["open_response"], packet_id)

        try:
            file_id = handlers.open_file(file_path, flags)
            respond(
                response_header + encode_open_response(None, file_id))
        except Exception as e:
            respond(
                response_header + encode_open_response(str(e), None)
            )
    elif packet_type == PACKETS["read_request"]:
        file_id = decode_read_request(rest)

        response_header = encode_response_header(
            PACKETS["read_response"], packet_id)

        try:
            data = handlers.read_file(file_id)
            respond(response_header + encode_read_response(None, data))
        except Exception as e:
            respond(response_header + encode_read_response(str(e), None))
