using System;

// Stepan Yurtsiv, 246437

namespace task1
{
    class Program
    {
        static void Main(string[] args)
        {
            MixedNumber n1 = new MixedNumber(2, -11, 6);
            Console.WriteLine("MixedNumber n1 = new MixedNumber(2, -9, 6)");
            Console.WriteLine($"n1:             {n1}");
            Console.WriteLine($"n1 double:      {n1.doubleRepresentation}");
            Console.WriteLine($"Modified times: {n1.modifiedTimes}");

            MixedNumber n2 = new MixedNumber(9, 6);
            Console.WriteLine("\nMixedNumber n2 = new MixedNumber(9, 6)");
            Console.WriteLine($"n2:             {n2}");
            Console.WriteLine($"n2 double:      {n2.doubleRepresentation}");
            Console.WriteLine($"Modified times: {n1.modifiedTimes}");

            MixedNumber n3 = new MixedNumber(2);
            Console.WriteLine("\nMixedNumber n3 = new MixedNumber(2)");
            Console.WriteLine($"n3:             {n3}");
            Console.WriteLine($"n3 double:      {n3.doubleRepresentation}");
            Console.WriteLine($"Modified times: {n3.modifiedTimes}");

            MixedNumber sum = n1 + n2 + n3;
            Console.WriteLine("\nMixedNumber sum = n1 + n2 + n3");
            Console.WriteLine($"sum:             {sum}");
            Console.WriteLine($"sum double:      {sum.doubleRepresentation}");
        }
    }
}
