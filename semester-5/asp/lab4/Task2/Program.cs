using System;
using System.Linq;

// Stepan Yurtsiv 246437

namespace Task2
{
    class Program
    {
        static void DrawCard(string line1, string line2 = "----", char borderChar = 'X', int borderWidth = 2, int minWidth = 20)
        {
            int longestLineWidth = Math.Max(line1.Length, line2.Length);
            int cardWidth = Math.Max(minWidth, borderWidth * 2 + longestLineWidth);
            int cardInnerWidth = cardWidth - borderWidth * 2;

            string borderLine = new string(borderChar, cardWidth);
            string topBottomBorder = string
                .Concat(Enumerable.Repeat($"{borderLine}\n", borderWidth))
                .TrimEnd('\n');
            string sideBorder = new string(borderChar, borderWidth);

            int line1LPad = line1.Length + ((cardInnerWidth - line1.Length) / 2);
            int line2LPad = line2.Length + ((cardInnerWidth - line2.Length) / 2);

            Console.Write(topBottomBorder);
            
            Console.WriteLine();
            Console.Write(sideBorder);
            Console.Write(line1.PadLeft(line1LPad, ' ').PadRight(cardInnerWidth, ' '));
            Console.Write(sideBorder);

            Console.WriteLine();
            Console.Write(sideBorder);
            Console.Write(line2.PadLeft(line2LPad, ' ').PadRight(cardInnerWidth, ' '));
            Console.Write(sideBorder);
            
            Console.WriteLine();
            Console.Write(topBottomBorder);
            Console.WriteLine("\n");
        }

        static void Main(string[] args)
        {
            DrawCard("Stepan");
            DrawCard("Stepan", "Yurtsiv");
            DrawCard("Stepan", "Yurtsiv", minWidth: 30);
            DrawCard(line1: "Stepan", line2: "Yurtsiv", borderWidth: 4);
            DrawCard("Stepan", "Yurtsiv", minWidth: 32, borderChar: '@');
        }
    }
}
