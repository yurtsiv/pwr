import socket
from serialization import *
import server_handlers as handlers

port = 3000

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(('0.0.0.0', port))

SERVER_SECRET = 1000

while True:
    buffer, addr = sock.recvfrom(PACKET_SIZE)

    secret, packet_type, packet_id, body = decode_request_header(buffer)

    def respond(response_body):
        packet_type_str = PACKETS_INV[packet_type]
        response_header = encode_response_header(
            PACKETS[packet_type_prefix(packet_type_str) + "_response"],
            packet_id
        )

        sock.sendto(response_header + response_body, addr)

    if secret != SERVER_SECRET:
        sock.sendto(
            encode_response_header(
                PACKETS["unauthorized_response"], packet_id),
            addr
        )
    elif packet_type == PACKETS["open_request"]:
        file_path, flags = decode_open_request(body)

        try:
            file_id = handlers.open_file(file_path, flags)
            respond(encode_open_response(None, file_id))
        except Exception as e:
            print("OPEN", e)
            respond(
                encode_open_response(str(e), None)
            )
    elif packet_type == PACKETS["read_request"]:
        file_id = decode_read_request(body)

        try:
            data = handlers.read_file(file_id)
            print("READING", data)
            respond(encode_read_response(None, data))
        except Exception as e:
            print("READ", e)
            respond(encode_read_response(str(e), None))
    elif packet_type == PACKETS["write_request"]:
        file_id, data = decode_write_request(body)

        try:
            handlers.write_file(file_id, data)
            respond(encode_write_response(None))
        except Exception as e:
            print("WRITE", e)
            respond(encode_write_response(str(e)))
    elif packet_type == PACKETS["lseek_request"]:
        file_id, pos, how = decode_lseek_request(body)

        try:
            handlers.lseek(file_id, pos, how)
            respond(encode_lseek_response(None))
        except Exception as e:
            print("LSEEK", e)
            respond(encode_lseek_response(str(e)))
    elif packet_type == PACKETS["chmod_request"]:
        file_path, mod = decode_chmod_request(body)

        try:
            handlers.chmod(file_path, mod)
            respond(encode_chmod_response(None))
        except Exception as e:
            print("CHMOD", e)
            respond(encode_chmod_response(str(e)))
    elif packet_type == PACKETS["unlink_request"]:
        file_path = decode_unlink_request(body)

        try:
            handlers.unlink(file_path)
            respond(encode_unlink_response(None))
        except Exception as e:
            print("UNLINK", e)
            respond(encode_unlink_response(str(e)))
