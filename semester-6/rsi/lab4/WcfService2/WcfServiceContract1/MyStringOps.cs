using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace WcfServiceContract1
{

    [ServiceBehavior(InstanceContextMode = InstanceContextMode.Single)]
    public class MyStringOps : IStringOps
    {
        string accum = "";

        public string Concat(string s1, string s2)
        {
            Console.WriteLine($"Concatenating {s1} and {s2}");
            var res = $"{s1}{s2}";
            Console.WriteLine($"Result is {res}");
            return res;
        }

        public bool Contains(string s1, string s2)
        {
            Console.WriteLine($"{s1} contains {s2}");
            var res = s1.Contains(s2);
            Console.WriteLine($"Result is {res}");
            return res;
        }

        public string Trim(string s)
        {
            Console.WriteLine($"Trimming {s}");
            var res = s.Trim();
            Console.WriteLine($"Result is {res}");
            return res;
        }

        public string AppendAccum(string s)
        {
            accum += s;
            return accum;
        }
    }
}
