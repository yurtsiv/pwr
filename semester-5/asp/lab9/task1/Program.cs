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
        static void PrintInfo()
        {
            WriteLine("Stepan Yurtsiv, 246437");
            WriteLine($"Computer: {Environment.MachineName}");
        }

        static IEnumerable<(string, int)> topWords(StreamReader sr, int count)
        {
            return new Regex("[A-Za-z]+")
                .Matches(sr.ReadToEnd())
                .Select(match => match.Value.ToLower())
                .GroupBy(word => word)
                .OrderByDescending(group => group.Count())
                .Select(group => (group.Key, group.Count()))
                .Take(count);
        }

        static void PrintResult(IEnumerable<(string, int)> wordsCount)
        {
            WriteLine();
            foreach (var (word, count) in wordsCount)
            {
                WriteLine($"{word}: {count}");
            }
        }

        static string GetFilePath()
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
            PrintInfo();

            try
            {
                string filePath = GetFilePath();
                using var sr = new StreamReader(filePath);
                PrintResult(topWords(sr, 10));
            }
            catch (Exception e)
            {
                WriteLine(e.Message);
            }
        }
    }
}
