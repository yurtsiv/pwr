using System;
using Grpc.Core;
using Mygrpcproto;

namespace gRPCserver
{
    class Program
    {
        const int port = 3000;
        static void Main(string[] args)
        {
            Console.WriteLine("Starting the server");


            Server myServer = new Server
            {
                Services = { MyGrpcSrv.BindService(new MyGrpcSrvImpl()) },
                Ports = { new ServerPort("localhost", port, ServerCredentials.Insecure) }
            };

            myServer.Start();


            Console.WriteLine($"Listening on port {port}.\nPress any key to stop");
            Console.ReadKey();

            myServer.ShutdownAsync().Wait();
        }
    }
}
