using System;
using System.Collections.Generic;
using System.Text;

namespace lab8
{
    class Student
    {
        private string name;
        private string surname;
        private string index;
        private string email;

        public Student(string name, string surname, string index, string email)
        {
            this.name = name;
            this.surname = surname;
            this.index = index;
            this.email = email;
        }

        public override string ToString()
        {
            return $"{{ {name} {surname} {index} {email} }}";
        }
    }
}
