using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Lab12.Models
{
    public class BasketItemViewModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public double Price { get; set; }
        public int Count { get; set; }
        public string Image { get; set; }
    }
    public class BasketViewModel
    {
        public IEnumerable<BasketItemViewModel> BasketItems { get; set; }

        public int Total { get; set; }
        
    }
}
