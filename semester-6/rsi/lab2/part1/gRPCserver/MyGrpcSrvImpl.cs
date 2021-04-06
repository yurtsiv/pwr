using Grpc.Core;
using Mygrpcproto;
using System.Threading.Tasks;
using System.Linq;

namespace gRPCserver
{
    class MyGrpcSrvImpl : MyGrpcSrv.MyGrpcSrvBase
    {
        public override Task<SubReply> sub(SubRequest req, ServerCallContext ctx)
        {
            return Task.FromResult(new SubReply
            {
                Result = req.Num1 - req.Num2,
            });
        }

        public override Task<RepeatStrReply> repeatStr(RepeatStrRequest req, ServerCallContext ctx)
        {
            return Task.FromResult(new RepeatStrReply
            {
                Result = string.Concat(
                    Enumerable.Repeat(req.String, unchecked((int)req.Times))
                )
            });
        }

        public override Task<AsyncEchoReply> asyncEcho(AsyncEchoRequest req, ServerCallContext ctx)
        {
            return Task.Run(async delegate
            {
                await Task.Delay(unchecked((int)req.Delay) * 1000);

                return new AsyncEchoReply
                {
                    Message = req.Message
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
    }
}