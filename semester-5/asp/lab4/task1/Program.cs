using System;

// Stepan Yurtsiv 246437

namespace Task1
{
    class Program
    {
        static (int, int) getFromConsoleXY(string comment1, string comment2)
        {

            int num1;
            Console.WriteLine(comment1);
            while (!int.TryParse(Console.ReadLine(), out num1))
            {
                Console.WriteLine(comment1);
            }

            int num2;
            Console.WriteLine(comment2);
            while (!int.TryParse(Console.ReadLine(), out num2))
            {
                Console.WriteLine(comment2);
            }

            return (num1, num2);
        }

        static void getFromConsoleXY(string comment1, string comment2, out int num1, out int num2)
        {
            Console.WriteLine(comment1);
            while (!int.TryParse(Console.ReadLine(), out num1))
            {
                Console.WriteLine(comment1);
            }

            Console.WriteLine(comment2);
            while (!int.TryParse(Console.ReadLine(), out num2))
            {
                Console.WriteLine(comment2);
            }
        }

        static void Main(string[] args)
        {
            Console.WriteLine("-- Pierwsza realizacja --");
            var res = getFromConsoleXY("Liczba 1", "Liczba 2");
            Console.WriteLine($"Wynik: {res}\n");

            Console.WriteLine("-- Druga realizacja  --");
            int num1;
            int num2;
            getFromConsoleXY("Liczba 1", "Liczba 2", out num1, out num2);
            Console.WriteLine($"liczba1={num1}, liczba2={num2}");
        }
    }
}
