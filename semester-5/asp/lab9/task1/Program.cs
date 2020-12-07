using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Linq;
using static System.Console;

namespace task1
{
    class Program
    {
        static void printInfo()
        {
            WriteLine("Stepan Yurtsiv, 246437");
            WriteLine($"Computer: {Environment.MachineName}");
        }

        static IEnumerable<(string, int)> top10Words(StreamReader sr)
        {
            return new Regex("[A-Za-z]+")
                .Matches(sr.ReadToEnd())
                .Select(match => match.Value.ToLower())
                .GroupBy(word => word)
                .OrderByDescending(group => group.Count())
                .Select(group => (group.Key, group.Count()))
                .Take(10);
        }

        static void printResult(IEnumerable<(string, int)> wordsCount)
        {
            WriteLine();
            foreach (var (word, count) in wordsCount)
            {
                WriteLine($"{word}: {count}");
            }
        }

        static string getFilePath()
        {
            WriteLine("File path: ");
            string path = ReadLine();

            if (path == "")
            {
                throw new ArgumentException("File path can not be empty");
            }

            string workingDirectory = Environment.CurrentDirectory;
            string projectDirectory = Directory.GetParent(workingDirectory).Parent.Parent.FullName;
            string relativeFilePath = $"{projectDirectory}\\{path}";

            return relativeFilePath;
        }

        static void Main(string[] args)
        {
            printInfo();

            try
            {
                string filePath = getFilePath();
                using var sr = new StreamReader(filePath);
                printResult(top10Words(sr));
            }
            catch (Exception e)
            {
                WriteLine(e.Message);
            }
        }
    }
}
