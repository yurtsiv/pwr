import os


opened_files = {}


def open_file(file_path, flags):
    global open_files

    if opened_files.get(file_path):
        raise IOError("File already opened")
    else:
        file = open(file_path, flags)
        opened_files[file_path] = file
        return file_path


def read_file(file_id):
    if opened_files.get(file_id):
        file = opened_files[file_id]
        return file.read()
    else:
        raise IOError("File not opened")


def write_file(file_id, data):
    if opened_files.get(file_id):
        file = opened_files[file_id]
        file.write(data)
    else:
        raise IOError("File not opened")


def lseek_file(file_id, pos, how):
    if opened_files.get(file_id):
        file = opened_files[file_id]
        os.lseek(file.fileno(), pos, how)
    else:
        raise IOError("File not opened")


def chmod(file_path, mod):
    os.chmod(file_path, mod)
