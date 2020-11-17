using System;

namespace task2
{
    class Program
    {
        static void showColors(object[] figures)
        {
            foreach (object figure in figures)
            {
                Console.WriteLine(
                    figure is IHasInterior ? ((IHasInterior)figure).color : "No color"
                );
            }
        }

        static void Main(string[] args)
        {
            object[] figures =
            {
                new Triangle("purple"),
                new Point(),
                new Square("red"),
                new Point(),
                new Triangle("blue"),
                new Point(),
                new Square("black")
            };

            showColors(figures);
        }
    }
}
