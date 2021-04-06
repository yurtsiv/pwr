using System;
using System.Collections.Generic;
using System.Text;
using Grpc.Core;
using Mygrpcproto;

namespace gRPCclient
{
    class Program
    {
        static MyGrpcSrv.MyGrpcSrvClient client;

        static string TypeToStr(MethodParamDefinition.Types.Type type)
        {
            switch (type)
            {
                case MethodParamDefinition.Types.Type.Uint:
                    return "uint";
                case MethodParamDefinition.Types.Type.Int:
                    return "int";
                case MethodParamDefinition.Types.Type.String:
                    return "string";
                default:
                    return "uknown";
            }
        }

        static string MethodDefToStr(MethodDefinition method)
        {
            StringBuilder sb = new StringBuilder(method.Name + "(");

            foreach (var param in method.Params)
            {
                sb.Append($"{TypeToStr(param.Type)} {param.Name}, ");
            }

            sb.Remove(sb.Length - 2, 2);
            sb.Append(")");

            return sb.ToString();
        }

        static async void CallAsync(MethodDefinition method)
        {
            try
            {
                var reply = await client.callMethodAsync(method);

                Console.WriteLine($"Result from {method.Name}: {reply.Result}");
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
        }

        static void Menu()
        {
            List<string> options = new List<string>();

            var methods = client
                .show(new ShowRequest())
                .Methods;

            foreach (var method in methods)
            {
                options.Add(MethodDefToStr(method));
            }

            while (true)
            {
                int option = UserInteraction.SelectOption("\nSelect a method to call", options);

                var method = methods[option];

                foreach (var param in method.Params)
                {
                    param.Value = UserInteraction.GetStr(param.Name);
                }

                CallAsync(method);
            }
        }

        static void Main(string[] args)
        {
            Console.WriteLine("Server port: ");
            string port = Console.ReadLine();

            Console.WriteLine("Starting the client");
            Channel channel = new Channel($"127.0.0.1:{port}", ChannelCredentials.Insecure);

            client = new MyGrpcSrv.MyGrpcSrvClient(channel);

            Menu();
        }
    }
}
