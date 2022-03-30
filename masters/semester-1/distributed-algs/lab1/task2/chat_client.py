from email import message
from unicodedata import name
import grpc
import proto.chat_pb2_grpc as pb2_grpc
import proto.chat_pb2 as proto


channel = grpc.insecure_channel('localhost:50051')
stub = pb2_grpc.ChatServerStub(channel)

stub.SendNote(
    proto.Note(
        name="Stepan",
        message="Hello"
    )
)