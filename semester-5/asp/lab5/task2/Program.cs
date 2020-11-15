using System;
using System.Text;

// Stepan Yurtsiv 246437

namespace task2
{
    class Program
    {
        static void Main(string[] args)
        {
            string example = "Stepan Yurtsiv, 246437 ąęś";

            Console.OutputEncoding = Encoding.Unicode;
            Console.WriteLine(example.SampleExstensionMethod());
        }
    }
}
