import os


opened_files = {}


def open_file(file_path, flags):
    global open_files

    file = open(file_path, flags)
    opened_files[file.fileno()] = file
    return file.fileno()


def read_file(file_id, size):
    if opened_files.get(file_id):
        file = opened_files[file_id]
        return file.read(size)
    else:
        raise IOError("File not opened")


def write_file(file_id, data):
    if opened_files.get(file_id):
        file = opened_files[file_id]
        file.write(data)
    else:
        raise IOError("File not opened")


def lseek(file_id, pos, how):
    if opened_files.get(file_id):
        file = opened_files[file_id]
        file.seek(pos, how)
    else:
        raise IOError("File not opened")


def chmod(file_path, mod):
    os.chmod(file_path, mod)


def unlink(file_path):
    os.unlink(file_path)

def rename(old_path, new_path):
    os.rename(old_path, new_path)