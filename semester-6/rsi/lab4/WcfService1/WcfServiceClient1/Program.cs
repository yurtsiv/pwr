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
        static void Main(string[] args)
        {
            CalculatorClient myClient = new CalculatorClient();

            double value1 = 10;
            double value2 = 20;

            double result1 = myClient.Add(value1, value2);
            Console.WriteLine($"Add: {result1}");

            double result2 = myClient.Sub(value1, value2);
            Console.WriteLine($"Sub: {result2}");

            double result3 = myClient.Multiply(value1, value2);
            Console.WriteLine($"Mul: {result3}");

            myClient.Close();
        }
    }
}
