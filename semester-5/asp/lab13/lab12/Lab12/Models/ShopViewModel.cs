using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Lab12.Models
{
    public class ShopViewModel
    {
        public List<Article> Articles { get; set; }
        public List<Category> Categories { get; set; }
        public int CartItemsCount { get; set; }
    }
}
