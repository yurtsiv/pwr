using System;
using System.Collections.Generic;

namespace gRPCclient
{
    class UserInteraction
    {
        public static int SelectOption(string label, List<string> options)
        {
            Console.WriteLine(label + "\n");

            for (int i = 0; i < options.Count; i++)
            {
                Console.WriteLine($"{i + 1}. {options[i]}");
            }

            return GetInt("", 1, options.Count) - 1;
        }


        public static int GetInt(string question, int lowerBound, int upperBound)
        {
            int result;

            Console.WriteLine(question);
            while (!int.TryParse(Console.ReadLine(), out result) || result < lowerBound || result > upperBound)
            {
                Console.WriteLine(question);
            }

            return result;
        }

        public static string GetStr(string question)
        {
            Console.WriteLine(question);
            return Console.ReadLine();
        }
    }
}