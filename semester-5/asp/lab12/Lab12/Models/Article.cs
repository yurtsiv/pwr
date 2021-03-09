using System.ComponentModel.DataAnnotations;

namespace Lab12.Models
{
    public class Article
    {
        public int ArticleId { get; set; }

        [Required]
        [Display(Name = "Name")]
        public string ArticleName { get; set; }

        [Required]
        [Display(Name = "Price")]
        public double ArticlePrice { get; set; }

        [Display(Name = "Image")]
        public string ArticleImage { get; set; }

        [Display(Name = "Category")]
        [Required]
        public int ArticleCategoryId { get; set; }
        public Category ArticleCategory { get; set; }
    }
}
