using Grpc.Core;
using Mygrpcproto;
using System;
using System.Threading.Tasks;
using System.Linq;
using System.Reflection;
using System.Collections.Generic;

namespace gRPCserver
{
    class MyGrpcSrvImpl : MyGrpcSrv.MyGrpcSrvBase
    {
        Task<CallMethodReply> sub(int num1, int num2)
        {
            return Task.FromResult(
                new CallMethodReply
                {
                    Result = (num1 - num2).ToString()
                }

            );
        }

        Task<CallMethodReply> repeatStr(string str, uint times)
        {
            return Task.FromResult(
                new CallMethodReply
                {
                    Result = string.Concat(
                        Enumerable.Repeat(str, unchecked((int)times))
                    )
                }
            );
        }

        Task<CallMethodReply> asyncEcho(string message, uint delay)
        {
            return Task.Run(async delegate
            {
                await Task.Delay(unchecked((int)delay) * 1000);

                return new CallMethodReply
                {
                    Result = message
                };
            });
        }


        public override Task<ShowReply> show(ShowRequest req, ServerCallContext ctx)
        {
            var reply = new ShowReply();

            // sub

            var subDef = new MethodDefinition
            {
                Name = "sub"
            };

            subDef.Params.Add(new MethodParamDefinition
            {
                Name = "Num1",
                Type = MethodParamDefinition.Types.Type.Int
            });

            subDef.Params.Add(new MethodParamDefinition
            {
                Name = "Num2",
                Type = MethodParamDefinition.Types.Type.Int
            });

            // repeatStr

            var repeatStrDef = new MethodDefinition
            {
                Name = "repeatStr"
            };

            repeatStrDef.Params.Add(new MethodParamDefinition
            {
                Name = "String",
                Type = MethodParamDefinition.Types.Type.String
            });

            repeatStrDef.Params.Add(new MethodParamDefinition
            {
                Name = "Times",
                Type = MethodParamDefinition.Types.Type.Uint
            });

            // asyncEcho

            var asyncEchoDef = new MethodDefinition
            {
                Name = "asyncEcho"
            };

            asyncEchoDef.Params.Add(new MethodParamDefinition
            {
                Name = "Message",
                Type = MethodParamDefinition.Types.Type.String
            });

            asyncEchoDef.Params.Add(new MethodParamDefinition
            {
                Name = "Delay",
                Type = MethodParamDefinition.Types.Type.Uint
            });


            reply.Methods.Add(subDef);
            reply.Methods.Add(repeatStrDef);
            reply.Methods.Add(asyncEchoDef);

            return Task.FromResult(reply);
        }

        public override Task<CallMethodReply> callMethod(MethodDefinition req, ServerCallContext ctx)
        {
            try
            {
                MethodInfo method = this.GetType().GetMethod(
                    req.Name,
                    BindingFlags.Instance | BindingFlags.NonPublic
                );

                List<object> args = new List<object>(); ;

                foreach (var param in req.Params)
                {
                    switch (param.Type)
                    {
                        case MethodParamDefinition.Types.Type.Uint:
                            args.Add(uint.Parse(param.Value));
                            break;
                        case MethodParamDefinition.Types.Type.Int:
                            args.Add(int.Parse(param.Value));
                            break;
                        case MethodParamDefinition.Types.Type.String:
                            args.Add(param.Value);
                            break;
                    }
                }

                return method.Invoke(this, args.ToArray()) as Task<CallMethodReply>;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return Task.FromResult(new CallMethodReply
                {
                    Result = "error"
                });
            }
        }
    }
}