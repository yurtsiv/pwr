using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Lab12.Models
{
    public class BasketItem
    {
        public BasketItem(int articleId)
        {
            ArticleId = articleId;
            Count = 1;
        }
        public int ArticleId { get; set; }
        public int Count { get; set; }
    }
    public class Basket
    {
        public Basket()
        {
            CartItems = new List<BasketItem>();
            ItemsCount = 0;
        }
        public List<BasketItem> CartItems { get; set; }

        public int ItemsCount { get; set; }

    }
}
