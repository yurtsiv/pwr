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