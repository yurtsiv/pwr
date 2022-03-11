using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Lab11.ViewModels
{
    public enum Category
    {
        ComputerScience, Chemistry, Physics
    }
    public class StudentViewModel
    {
        [Required]
        [MinLength(2, ErrorMessage="To short name")]
        [Display(Name="Name")]
        [MaxLength(30, ErrorMessage ="Name should be at most 30 characters long")]
        public string Name { get; set; }

        [Required]
        [RegularExpression(@"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$", ErrorMessage = "Enter correct email")]
        public string Email { get; set; }

        [Display(Name = "Postal Code")]
        public string ZipCode { get; set; }

        public Category Category { get; set; }

        public StudentViewModel()
        {

        }

        public StudentViewModel(string name, string email, string zipCode, Category category)
        {
            Name = name;
            Email = email;
            ZipCode = zipCode;
            Category = category;
        }
    }
}
