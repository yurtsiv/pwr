from argparse import ArgumentError
import chunk

PACKET_SIZE = 4096

PACKETS = {
    "open_request": 1,
    "open_response": 2,
    "read_request": 3,
    "read_response": 4,
    "read_data": 5,
    "write_request": 6,
    "write_response": 7,
    "chmod_request": 8,
    "chmod_response": 9,
    "unlink_request": 10,
    "unlink_response": 11,
    "rename_request": 12,
    "rename_response": 13,
    "unauthorized_response": 14,
    "lseek_request": 15,
    "lseek_response": 16,
    "chmod_request": 17,
    "chmod_response": 18,
    "unlink_request": 19,
    "unlink_response": 20,
    "rename_request": 21,
    "rename_response": 22
}

PACKETS_INV = dict((v, k) for k, v in PACKETS.items())


def packet_type_prefix(type):
    return type.split('_')[0]


def encode_basic_response(error):
    if error:
        return f"Error: {error}".encode('utf-8')

    return "Success".encode('utf-8')


def decode_basic_response(str):
    if str.startswith("Error"):
        return IOError(str)

# HEADERS


def encode_request_header(secret, packet_type, packet_id):
    if packet_type is None:
        raise ArgumentError("Unknown packet type")

    return f"{str(secret)}.{str(packet_type)}.{str(packet_id)}.".encode('utf-8')


def decode_request_header(buffer):
    h = buffer.decode('utf-8').split('.')
    return int(h[0]), int(h[1]), h[2], '.'.join(h[3:])


def encode_response_header(packet_type, packet_id):
    if packet_type is None:
        raise ArgumentError("Unknown packet type")

    return f"{str(packet_type)}.{packet_id}.".encode('utf-8')


def decode_response_header(buffer):
    h = buffer.decode('utf-8').split('.')
    return int(h[0]), int(h[1]), '.'.join(h[2:])


# OPEN

def encode_open_request(file_path, flags):
    return f"{file_path}\\{flags}".encode('utf-8')


def decode_open_request(str):
    chunks = str.split("\\")
    return chunks[0], chunks[1]


def encode_open_response(error, file_id):
    if error:
        return f"Error: {error}".encode('utf-8')

    return file_id.encode('utf-8')


def decode_open_response(str):
    if str.startswith("Error"):
        return IOError("Failed to open the file. " + str)

    return str

# READ


def encode_read_request(file_id, size):
    return f"{file_id}\\{size}".encode('utf-8')


def decode_read_request(str):
    chunks = str.split('\\')
    return chunks[0], int(chunks[1])


def encode_read_response(error, file_data):
    if error:
        return f"Error: {error}".encode('utf-8')

    return file_data.encode('utf-8')


def decode_read_response(str):
    if str.startswith("Error"):
        return IOError("Failed to read the file. " + str)

    return str

# WRITE


def encode_write_request(file_id, data):
    return f"{file_id}\\{data}".encode('utf-8')


def decode_write_request(str):
    chunks = str.split('\\')
    return chunks[0], '\\'.join(chunks[1:])


def encode_write_response(error):
    if error:
        return f"Error: {error}".encode('utf-8')

    return "Success".encode('utf-8')


def decode_write_response(str):
    if str.startswith("Error"):
        return IOError("Failed to write to file. " + str)

# LSEEK


def encode_lseek_request(file_id, pos, how):
    return f"{file_id}\\{str(pos)}\\{str(how)}".encode('utf-8')


def decode_lseek_request(str):
    chunks = str.split('\\')
    return chunks[0], int(chunks[1]), int(chunks[2])


encode_lseek_response = encode_basic_response
decode_lseek_response = decode_basic_response

# CHMOD


def encode_chmod_request(file_path, mod):
    return f"{file_path}\\{str(mod)}".encode('utf-8')


def decode_chmod_request(str):
    chunks = str.split('\\')
    return chunks[0], int(chunks[1])


encode_chmod_response = encode_basic_response
decode_chmod_response = decode_basic_response

# UNLINK


def encode_unlink_request(file_path):
    return file_path.encode('utf-8')


def decode_unlink_request(str):
    return str


encode_unlink_response = encode_basic_response
decode_unlink_response = decode_basic_response

# RENAME


def encode_rename_request(old_path, new_path):
    return f"{old_path}\\{new_path}".encode('utf-8')


def decode_rename_request(str):
    chunks = str.split('\\')
    return chunks[0], chunks[1]


encode_rename_response = encode_basic_response
decode_rename_response = decode_basic_response
