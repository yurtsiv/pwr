using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WcfServiceClient1.ServiceReference1;

namespace WcfServiceClient1
{
    class Program
    {
        static void TestClient(StringOpsClient client)
        {
            Console.WriteLine($"\nTesting {client.Endpoint.ListenUri}");

            var value1 = " Hello ";
            var value2 = " world ";

            var result1 = client.Concat(value1, value2);
            Console.WriteLine($"Concat: {result1}");

            var result2 = client.Contains(value1, value2);
            Console.WriteLine($"Contains: {result2}");

            var result3 = client.Trim(value1);
            Console.WriteLine($"Trim: {result3}");

            var result4 = client.AppendAccum(value1);
            Console.WriteLine($"AppendAccum: {result4}");

            var result5 = client.AppendAccum(value2);
            Console.WriteLine($"AppendAccum: {result5}");

            var result6 = client.AverageStrLen(new []{ "ala", "ma", "kota" });
            Console.WriteLine($"\nAverageStrLen: {result6}");

            client.Close();
        }

        static void Main(string[] args)
        {
            // CalculatorClient myClient = new CalculatorClient();

            StringOpsClient client1 = new StringOpsClient("WSHttpBinding_IStringOps");
            StringOpsClient client2 = new StringOpsClient("BasicHttpBinding_IStringOps");
            StringOpsClient client3 = new StringOpsClient("myEndpoint3");

            TestClient(client1);
            TestClient(client2);
            TestClient(client3);
        }
    }
}

