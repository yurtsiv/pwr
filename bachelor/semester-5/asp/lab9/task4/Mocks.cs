using System;
using System.Collections.Generic;

namespace task4
{
    public class Department
    {
        public int Id { get; set; }
        public String Name { get; set; }

        public Department(int id, string name)
        {
            this.Id = id;
            this.Name = name;
        }

        public override string ToString()
        {
            return $"{Id,2}), {Name,11}";
        }

    }

    public enum Gender
    {
        Female,
        Male
    }

    public class Topic
    {
        public string Name { get; }
        public int Id { get; }

        public Topic(int id, string name)
        {
            Name = name;
            Id = id;
        }

        public override string ToString()
        {
            return $"{Id}: {Name}";
        }
    }

    public class Student
    {
        public int Id { get; set; }
        public int Index { get; set; }
        public string Name { get; set; }
        public Gender Gender { get; set; }
        public bool Active { get; set; }
        public int DepartmentId { get; set; }

        public List<string> Topics { get; set; }
        public Student(int id, int index, string name, Gender gender, bool active,
            int departmentId, List<string> topics)
        {
            this.Id = id;
            this.Index = index;
            this.Name = name;
            this.Gender = gender;
            this.Active = active;
            this.DepartmentId = departmentId;
            this.Topics = topics;
        }

        public override string ToString()
        {
            var result = $"{Id,2}) {Index,5}, {Name,11}, {Gender,6},{(Active ? "active" : "no active"),9},{DepartmentId,2}, topics: ";
            foreach (var str in Topics)
                result += str + ", ";
            return result;
        }
    }
    public class StudentWithTopics
    {
        public int Id { get; set; }
        public int Index { get; set; }
        public string Name { get; set; }
        public Gender Gender { get; set; }
        public bool Active { get; set; }
        public int DepartmentId { get; set; }

        public List<int> Topics { get; set; }
        public StudentWithTopics(int id, int index, string name, Gender gender, bool active,
            int departmentId, List<int> topics)
        {
            this.Id = id;
            this.Index = index;
            this.Name = name;
            this.Gender = gender;
            this.Active = active;
            this.DepartmentId = departmentId;
            this.Topics = topics;
        }

        public override string ToString()
        {
            var result = $"{Id,2}) {Index,5}, {Name,11}, {Gender,6},{(Active ? "active" : "no active"),9},{DepartmentId,2}, topics: ";
            foreach (var str in Topics)
                result += str + ", ";
            return result;
        }
    }

    public static class Generator
    {
        public static int[] GenerateIntsEasy()
        {
            return new int[] { 5, 3, 9, 7, 1, 2, 6, 7, 8 };
        }

        public static int[] GenerateIntsMany()
        {
            var result = new int[10000];
            Random random = new Random();
            for (int i = 0; i < result.Length; i++)
                result[i] = random.Next(1000);
            return result;
        }

        public static List<string> GenerateStringsEasy()
        {
            return new List<string>() {
                "Nowak",
                "Kowalski",
                "Schmidt",
                "Newman",
                "Bandingo",
                "Miniwiliger"
            };
        }
        public static List<Student> GenerateStudentsEasy()
        {
            return new List<Student>() {
            new Student(1,12345,"Nowak", Gender.Female,true,1,
                    new List<string>{"C#","PHP","algorithms"}),
            new Student(2, 13235, "Kowalski", Gender.Male, true,1,
                    new List<string>{"C#","C++","fuzzy logic"}),
            new Student(3, 13444, "Schmidt", Gender.Male, false,2,
                    new List<string>{"Basic","Java"}),
            new Student(4, 14000, "Newman", Gender.Female, false,3,
                    new List<string>{"JavaScript","neural networks"}),
            new Student(5, 14001, "Bandingo", Gender.Male, true,3,
                    new List<string>{"Java","C#"}),
            new Student(6, 14100, "Miniwiliger", Gender.Male, true,2,
                    new List<string>{"algorithms","web programming"}),
            new Student(11,22345,"Nowak", Gender.Female,true,2,
                    new List<string>{"C#","PHP","algorithms"}),
            new Student(12, 23235, "Nowak", Gender.Male, true,1,
                    new List<string>{"C#","C++","fuzzy logic"}),
            new Student(13, 23444, "Schmidt", Gender.Male, false,1,
                    new List<string>{"Basic","Java"}),
            new Student(14, 24000, "Newman", Gender.Female, false,1,
                    new List<string>{"JavaScript","neural networks"}),
            new Student(15, 24001, "Bandingo", Gender.Male, true,3,
                    new List<string>{"Java","C#"}),
            new Student(16, 24100, "Bandingo", Gender.Male, true,2,
                    new List<string>{"algorithms","web programming"}),
            };
        }

        public static List<Department> GenerateDepartmentsEasy()
        {
            return new List<Department>() {
            new Department(1,"Computer Science"),
            new Department(2,"Electronics"),
            new Department(3,"Mathematics"),
            new Department(4,"Mechanics")
            };
        }

    }
}
