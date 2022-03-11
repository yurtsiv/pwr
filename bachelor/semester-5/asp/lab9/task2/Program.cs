using System;
using System.Linq;
using System.Collections.Generic;
using static System.Console;

namespace task2
{
    class Program
    {
        static void PrintInfo()
        {
            WriteLine("Stepan Yurtsiv, 246437");
            WriteLine($"Computer: {Environment.MachineName}");
        }

        static IEnumerable<IGrouping<int, Student>> GroupStudents(int n)
        {
             return Generator.GenerateStudentsEasy()
                .OrderBy(stud => stud.Name)
                .ThenBy(stud => stud.Index)
                .Select((stud, index) => new { Stud = stud, GroupNo = index / n })
                .GroupBy(item => item.GroupNo, item => item.Stud);
        }
        static void Main(string[] args)
        {
            PrintInfo();

            int n = 4;
            foreach(var group in GroupStudents(n))
            {
                WriteLine($"\nGroup {group.Key}: ");

                foreach(var student in group)
                {
                    WriteLine("    " + student);
                }

                WriteLine();
            }
        }
    }
}
