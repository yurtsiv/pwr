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
        static void TestClient(CalculatorClient client)
        {
            Console.WriteLine($"\nTesting {client.Endpoint.ListenUri}");

            double value1 = 10;
            double value2 = 20;

            double result1 = client.Add(value1, value2);
            Console.WriteLine($"Add: {result1}");

            double result2 = client.Sub(value1, value2);
            Console.WriteLine($"Sub: {result2}");

            double result3 = client.Multiply(value1, value2);
            Console.WriteLine($"Mul: {result3}");

            double result4 = client.Summarize(value1);
            Console.WriteLine($"Summarize {value1}: {result4}");

            double result5 = client.Summarize(value2);
            Console.WriteLine($"Summarize {value2}: {result5}");

            client.Close();
        }

        static void Main(string[] args)
        {
            // CalculatorClient myClient = new CalculatorClient();

            CalculatorClient client1 = new CalculatorClient("WSHttpBinding_ICalculator");
            CalculatorClient client2 = new CalculatorClient("BasicHttpBinding_ICalculator");
            CalculatorClient client3 = new CalculatorClient("myEndpoint3");

            TestClient(client1);
            TestClient(client2);
            TestClient(client3);
        }
    }
}

