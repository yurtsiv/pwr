using System;
using System.Collections.Generic;

using static System.Console;

namespace lab8
{
    class Program
    {
        static void printPersonalInfo()
        {
            WriteLine("Stepan Yurtsiv, 246437");
            WriteLine($"Computer: {Environment.MachineName}\n\n");
        }

        static void Main(string[] args)
        {
            printPersonalInfo();

            Student s1 = new Student("First", "Student", "123456", "test@test.email");
            Student s2 = new Student("Second", "Student", "654321", "test2@test.email");
            Student s3 = new Student("Third", "Student", "443241", "test3@test.email");
            Student s4 = new Student("Fourth", "Student", "324793", "test4@test.email");
            Student s5 = new Student("Fifth", "Student", "313534", "test5@test.email");
            Student s6 = new Student("Sixth", "Student", "215343", "test6@test.email");
            Student s7 = new Student("Seventh", "Student", "123432", "test7@test.email");

            var test = new ListOfArrayList<Student>(4);
            test.Add(s1);
            test.Add(s2);
            test.Add(s3);
            test.Add(s4);
            test.Add(s5);
            test.Add(s6);
            test.Add(s7);

            WriteLine("\n-- Initial list --");
            WriteLine(test);

            test.Remove(s3);

            WriteLine("\n-- After removing 1 elem --");
            WriteLine(test);

            test.RemoveAt(1);
            test.RemoveAt(6);
            test.RemoveAt(3);

            WriteLine("\n-- After removing 3 more elems --");
            WriteLine(test);

            test.Trim();

            WriteLine("\n-- After trimming --");
            WriteLine(test);

            WriteLine($"\nContains s1: {test.Contains(s1)}");

            WriteLine("\n\n-- Concatenating lists together --\n\n");

            var l1 = new ListOfArrayList<object>(4);
            l1.Add("1");
            l1.Add(2);
            l1.Add("3");
            l1.Add(4);

            WriteLine("\n-- List of lists 1 (l1) --");
            WriteLine(l1);

            var l2 = new ListOfArrayList<object>(5);
            l2.Add(5);
            l2.Add(6);
            l2.Add(7);
            l2.Add("Test8");
            l2.Add(9);
            l2.Add("Test10");
            l2.Add(11);

            WriteLine("\n-- List of lists 2 (l2) --");
            WriteLine(l2);

            var l3 = new List<object> { 12, "13", 14, 15 };

            WriteLine("\n-- Regular list (l3) --\n");
            foreach (object e in l3)
            {
                Write($"{e}, ");
            }

            ListOfArrayList<object> l4 = l1 + l2 + l3;

            WriteLine("\n\n-- l1 + l2 + l3 --");
            WriteLine(l4);
        }
    }
}

