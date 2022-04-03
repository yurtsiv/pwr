### Starting the server

```python3 server.py <port> <secret number>```

Example:

```python3 server.py 3000 1234```

### Running the demo

```python3 demo.py <server address> <server port> <secret number>```

Example:

```python3 demo.py 127.0.0.1 3000 1234```

### Custom usage

Before using any useful functions, `file.connect(server_address, server_port, secret_number)` must be called. See `demo.py` for examples.


### Notes

You can `write` and `read` only text data & maximum 8192 bytes at a time.