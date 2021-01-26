using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;

namespace Lab12.Models
{
    public class Category
    {
        public int CategoryId { get; set; }

        [Required]
        [Display(Name = "Name")]
        public string CategoryName { get; set; }

        public ICollection<Article> Articles { get; set; }
    }
}
