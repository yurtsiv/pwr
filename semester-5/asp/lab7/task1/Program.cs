﻿using System;
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
        static Dictionary<string, int> countWords(StreamReader sr)
        {
            Regex wordRegex = new Regex("[A-Za-z]+");
            Dictionary<string, int> wordsCount = new Dictionary<string, int>();

            while (true)
            {
                string line = sr.ReadLine();
                if (line == null)
                {
                    break;
                }

                foreach (Match match in wordRegex.Matches(line))
                {
                    string word = match.Value.ToLower();
                    if (wordsCount.ContainsKey(word))
                    {
                        wordsCount[word]++;
                    }
                    else
                    {
                        wordsCount.Add(word, 1);
                    }
                }
            }

            return wordsCount;
        }

        static void printResult(Dictionary<string, int> wordsCount)
        {
            var wordsCountList = wordsCount.ToList();
            wordsCountList.Sort((a, b) => b.Value - a.Value);
            var firstTen = wordsCountList.Take(10);

            foreach (var keyValue in firstTen)
            {
                WriteLine($"{keyValue.Key}: {keyValue.Value}");
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
                var wordsCount = countWords(sr);
                printResult(wordsCount);
            } catch (Exception e)
            {
                WriteLine(e.Message);
            }
        }
    }
}
