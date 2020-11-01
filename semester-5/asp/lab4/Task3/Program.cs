#undef DEBUG

using System;

namespace Task3
{
    class Program
    {
        static (int evenInts, int positiveFloats, int strings, int other) CountMyTypes(params object[] list)
        {
            int evenInts = 0, positiveFloats = 0, strings = 0, other = 0;

            foreach(var item in list)
            {
                switch (item)
                {
                    case int n:
                        if (n % 2 == 0)
                        {
#if DEBUG
                            Console.WriteLine("Debug: even int detected");
#endif
                            evenInts++;
                        } else
                        {
                            other++;
                        }

                        break;
                    case double n:
                        if (n > 0) 
                        {
#if DEBUG
                            Console.WriteLine("Debug: positive double detected");
#endif
                            positiveFloats++;
                        } else {
                            other++;
                        };
                        break;
                    case string s:
                        if (s.Length >= 5)
                        {
#if DEBUG
                            Console.WriteLine($"Debug: string with length {s.Length} detected");
#endif
                            strings++;
                        } else {
                            other++;
                        };
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
                2, 3, 4, 6, 0, 0.0, -1, 0.5, -1.4, 1.1, "test", "Long string 0", true, false
            );

            Console.WriteLine($"Parzystych liczb całkowitych:      {evenInts}");
            Console.WriteLine($"Liczb rzeczywistych dodatnich:     {positiveFloats}");
            Console.WriteLine($"Napisów co najmniej 5-znakowych:   {strings}");
            Console.WriteLine($"Elementów innych typów:            {other}");
        }
    }
}
