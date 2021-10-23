using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace WcfServiceContract1
{

    [ServiceBehavior(InstanceContextMode = InstanceContextMode.Single)]
    public class MyCalculator : ICalculator
    {
        double sum = 0;

        public double Add(double n1, double n2)
        {
            Console.WriteLine($"Adding {n1} and {n2}");
            var res = n1 + n2;
            Console.WriteLine($"Result is {res}");
            return res;
        }
        public double Sub(double n1, double n2)
        {
            Console.WriteLine($"Subtracting {n2} from {n1}");
            var res = n1 - n2;
            Console.WriteLine($"Result is {res}");
            return res;
        }
        public double Multiply(double n1, double n2)
        {
            Console.WriteLine($"Multiplying {n1} by {n2}");
            var res = n1 + n2;
            Console.WriteLine($"Result is {res}");
            return res;
        }

        public double Summarize(double n1)
        {
            sum += n1;
            return sum;
        }
    }
}
