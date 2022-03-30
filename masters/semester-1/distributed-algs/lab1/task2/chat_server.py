from concurrent import futures
import grpc
import proto.chat_pb2_grpc as pb2_grpc

class ChatServicer(pb2_grpc.ChatServerServicer):
    def __init__(self):
        self.messages = []
    
    def ChatStream(self, request, context):
        received_count = len(self.messages) - 1
        while True:
            while received_count < len(self.messages):
                yield self.messages[received_count]
                received_count += 1

    def SendNote(self, request, context):
        print(request)


def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    pb2_grpc.add_ChatServerServicer_to_server(ChatServicer(), server)
    server.add_insecure_port('[::]:50051')
    server.start()
    server.wait_for_termination()

serve()