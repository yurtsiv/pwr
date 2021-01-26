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
        [RegularExpression(@"[A-Z][a-z]{3,}", ErrorMessage = "Invalid name format")]
        public string Name { get; set; }

        [Required]
        [RegularExpression(@"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$", ErrorMessage = "Enter correct email")]
        public string Email { get; set; }

        [Display(Name = "Postal Code")]
        [RegularExpression(@"[0-9]{2}-[0-9]{3}", ErrorMessage = "Invalid postal code")]
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
