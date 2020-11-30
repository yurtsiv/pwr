using System;
using System.Collections.Generic;

using static System.Console;

namespace lab8
{
    class Program
    {
        static void Main(string[] args)
        {
            var test = new ListOfArrayList<int>(4);
            test.Add(1);
            test.Add(2);
            test.Add(3);
            test.Add(4);

            test.Add(5);
            test.Add(6);
            test.Add(7);
            test.Add(8);

            test.Add(9);
            test.Add(10);
            test.Add(11);
            test.Add(12);

            WriteLine("\nInitial list");
            WriteLine(test);

            test.Remove(3);
            test.Remove(100);

            WriteLine("\nAfter removing 1 elem");
            WriteLine(test);

            test.RemoveAt(6);
            test.RemoveAt(3);

            WriteLine("\nAfter removing 2 more elems");
            WriteLine(test);

            test.RemoveAt(1);
            WriteLine("\nAfter removing 1 more elem");
            WriteLine(test);

            test.Trim();
            WriteLine("\nAfter trimming");
            WriteLine(test);

            WriteLine("\n\n-- Concatenating lists together --\n\n");

            var l1 = new ListOfArrayList<object>(4);
            l1.Add("1");
            l1.Add(2);
            l1.Add("3");
            l1.Add(4);

            var l2 = new ListOfArrayList<object>(5);
            l2.Add(1);
            l2.Add(2);
            l2.Add(3);
            l2.Add("Test1");
            l2.Add(4);
            l2.Add("Test2");
            l2.Add(6);

            WriteLine("\nList of lists 1 (l1)");
            WriteLine(l1);
            WriteLine("\nList of lists 2 (l2)");
            WriteLine(l2);


            var l3 = new List<object> { 10, "11", 12, 13 };

            WriteLine("\nRegular list (l3)\n");
            foreach (object e in l3)
            {
                Write($"{e}, ");
            }

            l1.Concat(l2);
            l1.Concat(l3);

            WriteLine("\n\nl1 + l2 + l3");
            WriteLine(l1);
        }
    }
}

