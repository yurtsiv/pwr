using System;

namespace task2
{
    class Program
    {
        static void showColors(object[] figures)
        {
            foreach (object figure in figures)
            {
                IHasInterior interiorFigure = figure as IHasInterior;
                Console.WriteLine(interiorFigure == null ? "No color" : interiorFigure.color);
            }
        }

        static void Main(string[] args)
        {
            object[] figures =
            {
                new Point(),
                new Square("red"),
                new Point(),
                new Point(),
                new Square("black")
            };

            showColors(figures);
        }
    }
}
