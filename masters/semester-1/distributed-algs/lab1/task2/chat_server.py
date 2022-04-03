import sys
sys.path.append("proto")

import proto.chat_pb2 as proto
import proto.chat_pb2_grpc as pb2_grpc
import grpc
from concurrent import futures

port = 0
try:
    port = int(sys.argv[1])
except Exception:
    print("Please, pass a port number")
    sys.exit()

class ChatServicer(pb2_grpc.ChatServerServicer):
    def __init__(self):
        self.messages = [
            proto.Note(name="(system)", message="Welcome!")
        ]

    def ChatStream(self, request, context):
        received_count = 0

        while True:
            while received_count < len(self.messages):
                m = self.messages[received_count]
                received_count += 1
                yield m

    def SendNote(self, request, context):
        print("Received", request)
        self.messages.append(request)
        return proto.Empty()


def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    pb2_grpc.add_ChatServerServicer_to_server(ChatServicer(), server)
    server.add_insecure_port(f'[::]:{port}')
    server.start()
    print(f"Server started on port {port}. Press Ctrl+C to stop")
    try:
        server.wait_for_termination()
    except KeyboardInterrupt:
        sys.exit()

serve()
