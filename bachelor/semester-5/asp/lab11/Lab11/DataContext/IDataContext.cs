using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Lab11.ViewModels;

namespace Lab11.DataContext
{
    public interface IDataContext
    {
        Dictionary<int, StudentViewModel> ListStudents();
        KeyValuePair<int,StudentViewModel> GetStudent(int id);
        void AddStudent(StudentViewModel person);
        void RemoveStudent(int id);
        void UpdateStudent(int key, StudentViewModel value);

    }
}
