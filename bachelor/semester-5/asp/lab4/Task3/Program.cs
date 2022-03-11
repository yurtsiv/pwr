using System;

// Stepan Yurtsiv 246437

namespace Task3
{
    class Program
    {
        static (int evenInts, int positiveFloats, int strings, int other) CountMyTypes(params dynamic[] list)
        {
            int evenInts = 0, positiveFloats = 0, strings = 0, other = 0;

            foreach(var item in list)
            {
                switch (item)
                {
                    case int n when n % 2 == 0:
                        evenInts++;
                        break;
                    case double n when n > 0:
                        positiveFloats++;
                        break;
                    case string s when s.Length >= 5:
                        strings++;
                        break;
                    default:
                        other++;
                        break;
                }
            }

            return (evenInts, positiveFloats, strings, other);
        }
        static void Main(string[] args)
        {
            var (evenInts, positiveFloats, strings, other) = CountMyTypes(
                2, 3, 4, 6, 0, 0.0, -1, 0.5, -1.4, 1.1, "test", "Long string 0", true, false, 4, 2
            );

            Console.WriteLine($"Parzystych liczb całkowitych:      {evenInts}");
            Console.WriteLine($"Liczb rzeczywistych dodatnich:     {positiveFloats}");
            Console.WriteLine($"Napisów co najmniej 5-znakowych:   {strings}");
            Console.WriteLine($"Elementów innych typów:            {other}");
        }
    }
}
