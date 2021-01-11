using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Lab11.ViewModels;

namespace Lab11.DataContext
{
    public class MockDataContext : IDataContext
    {
        Dictionary<int, StudentViewModel> testData = new Dictionary<int, StudentViewModel>()
        {
            { 0, new StudentViewModel("Mayble", "email0@test.com", "21-212", Category.ComputerScience) },
            { 1, new StudentViewModel("Rick", "email1@test.com", "22-322", Category.Chemistry)},
            { 2, new StudentViewModel("Morty", "email2@test.com", "14-858", Category.Physics)},
            { 3, new StudentViewModel("Lila", "email3@test.com", "19-345", Category.ComputerScience)},
        };
       

        public void AddStudent(StudentViewModel student)
        {
            int nextNumber = testData.Values.Count();
            testData.Add(nextNumber, student);
        }

        public KeyValuePair<int,StudentViewModel> GetStudent(int id)
        {
            return testData.FirstOrDefault(s => s.Key == id);
        }

        public Dictionary<int, StudentViewModel> ListStudents()
        {
            return testData;
        }

        public void RemoveStudent(int id)
        {
            testData.Remove(id);
        }

        public void UpdateStudent(int key,StudentViewModel value)
        {
            StudentViewModel stud;
            if (testData.TryGetValue(key, out stud))
            {
                testData[key] = value;
            }
        }
    }
}
