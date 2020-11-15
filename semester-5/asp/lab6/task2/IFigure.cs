using System;
using System.Collections.Generic;
using System.Text;

namespace task2
{
    interface IFigure
    {
        void moveTo(double x, double y) =>
            Console.WriteLine("moveTo is not implemented");
    }
}
