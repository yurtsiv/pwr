using System;
using System.Linq;
using System.Collections.Generic;
using static System.Console;


namespace task4
{
    class Program
    {
        static void PrintInfo()
        {
            WriteLine("Stepan Yurtsiv, 246437");
            WriteLine($"Computer: {Environment.MachineName}");
        }

        static void Main(string[] args)
        {
            PrintInfo();

            var students = Generator.GenerateStudentsEasy();

            WriteLine("\n-- Students --\n");
            foreach (var stud in students)
                WriteLine(stud);

            var topics = students
                .SelectMany(stud => stud.Topics)
                .Distinct()
                .Select((topic, i) => new Topic(i, topic));

            WriteLine("\n-- Topics --\n");
            foreach (var topic in topics)
                WriteLine(topic);

            var studentsWithTopics = students
                .Select(stud =>
                    new StudentWithTopics(
                        stud.Id,
                        stud.Index,
                        stud.Name,
                        stud.Gender,
                        stud.Active,
                        stud.DepartmentId,
                        topics
                            .Where(t => stud.Topics.Contains(t.Name))
                            .Select(t => t.Id)
                            .ToList()
                    )
                );

            WriteLine("\n-- Students with topics --\n");
            foreach (var stud in studentsWithTopics)
                WriteLine(stud);

        }
    }
}
