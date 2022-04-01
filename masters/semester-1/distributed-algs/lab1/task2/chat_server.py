from email import message
import sys
sys.path.append("proto")

from concurrent import futures
import grpc
import proto.chat_pb2_grpc as pb2_grpc
import proto.chat_pb2 as proto

class ChatServicer(pb2_grpc.ChatServerServicer):
    def __init__(self):
        self.messages = [
            proto.Note(name="server", message="server")
        ]
    
    def ChatStream(self, request, context):
        received_count = 0
        while True:
            while received_count < len(self.messages):
                yield self.messages[received_count - 1]
                received_count += 1

    def SendNote(self, request, context):
        print("Received", request)
        self.messages.append(request)
        return proto.Empty()

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    pb2_grpc.add_ChatServerServicer_to_server(ChatServicer(), server)
    server.add_insecure_port('[::]:50051')
    server.start()
    print("Server started. Press Ctrl+C to stop")
    server.wait_for_termination()

serve()