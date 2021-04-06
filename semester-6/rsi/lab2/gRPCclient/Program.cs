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

        static void sub()
        {
            int num1 = UserInteraction.GetInt("num1:", int.MinValue, int.MaxValue);
            int num2 = UserInteraction.GetInt("num2:", int.MinValue, int.MaxValue);

            var reply = client.sub(new SubRequest
            {
                Num1 = num1,
                Num2 = num2
            });

            Console.WriteLine($"Result: {reply.Result}");
        }

        static void repeatStr()
        {
            string str = UserInteraction.GetStr("string:");
            int times = UserInteraction.GetInt("times:", 0, int.MaxValue);

            var reply = client.repeatStr(new RepeatStrRequest
            {
                String = str,
                Times = (uint)times
            });

            Console.WriteLine($"Result: {reply.Result}");
        }

        static async void asyncEcho()
        {
            string msg = UserInteraction.GetStr("message:");
            int delay = UserInteraction.GetInt("delay (secs):", 0, int.MaxValue);

            var reply = await client.asyncEchoAsync(new AsyncEchoRequest
            {
                Message = msg,
                Delay = (uint)delay
            });

            Console.WriteLine($"Result from asyncEcho: {reply.Message}");
        }

        static string typeToStr(MethodParamDefinition.Types.Type type)
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

        static void show()
        {
            var reply = client.show(new ShowRequest());

            Console.WriteLine("Methods:");

            foreach (var method in reply.Methods)
            {
                StringBuilder sb = new StringBuilder(method.Name + "(");

                foreach (var param in method.Params)
                {
                    sb.Append($"{typeToStr(param.Type)} {param.Name}, ");
                }

                sb.Remove(sb.Length - 2, 2);
                sb.Append(")");

                Console.WriteLine(sb.ToString());
            }
        }

        static void Menu()
        {
            List<string> options = new List<string> {
                "sub(num1, num2)",
                "repeatStr(string, times)",
                "asyncEcho(message, delay)",
                "show()"
            };

            while (true)
            {
                int option = UserInteraction.SelectOption("\nSelect a method to call", options);

                switch (option)
                {
                    case 0:
                        sub();
                        break;
                    case 1:
                        repeatStr();
                        break;
                    case 2:
                        asyncEcho();
                        break;
                    case 3:
                        show();
                        break;
                }

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
