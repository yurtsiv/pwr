using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;

namespace Lab12.Models
{
    public class ArticleViewModel
    {

        public int ArticleId { get; set; }

        [Required]
        [Display(Name = "Name")]
        public string ArticleName { get; set; }

        [Required]
        [Display(Name = "Cena")]
        public double ArticlePrice { get; set; }

        [Display(Name = "Image")]
        public IFormFile ArticleImage { get; set; }

        [Required]
        [Display(Name = "Category")]
        public int ArticleCategoryId { get; set; }
        public Category ArticleCategory { get; set; }
    }
}
