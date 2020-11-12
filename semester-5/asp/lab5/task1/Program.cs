using System;

namespace task1
{
    class Program
    {
        static void Main(string[] args)
        {
            MixedNumber m = new MixedNumber(2, -9, 6);

            Console.WriteLine("new MixedNumer(2, -9, 6)\n");

            Console.WriteLine($"Number is:      {m}");
            Console.WriteLine($"Modified times: {m.modifiedTimes}");
        }
    }
}
