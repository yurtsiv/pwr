using System;
using System.Linq;
using System.Collections.Generic;
using static System.Console;


namespace task3
{
    class Program
    {
        static void PrintInfo()
        {
            WriteLine("Stepan Yurtsiv, 246437");
            WriteLine($"Computer: {Environment.MachineName}");
        }

        static IEnumerable<(string, int)> SortTopics()
        {
            return Generator
                .GenerateStudentsEasy()
                .SelectMany(stud => stud.Topics)
                .GroupBy(topic => topic)
                .OrderByDescending(group => group.Count())
                .Select(group => (group.Key, group.Count()));
        }
        static IEnumerable<(string, int)> SortTopics(Gender gender)
        {
            return Generator
                .GenerateStudentsEasy()
                .Where(stud => stud.Gender == gender)
                .SelectMany(stud => stud.Topics)
                .GroupBy(topic => topic)
                .OrderByDescending(group => group.Count())
                .Select(group =>  (group.Key, group.Count()));
        }

        static void Main(string[] args)
        {
            PrintInfo();

            WriteLine("\n-- All students --\n");
            foreach (var t in SortTopics())
                WriteLine(t);

            WriteLine("\n-- Female students --\n");
            foreach (var t in SortTopics(Gender.Female))
                WriteLine(t);

            WriteLine("\n-- Male students --\n");
            foreach (var t in SortTopics(Gender.Male))
                WriteLine(t);
        }
    }
}
