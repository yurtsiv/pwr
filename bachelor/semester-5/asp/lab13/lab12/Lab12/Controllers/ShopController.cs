using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Lab12.Data;
using Lab12.Models;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;



namespace Lab12.Controllers
{
    public class ShopController : Controller
    {
        private readonly ShopDbContext _db;
        public ShopController(ShopDbContext context)
        {
            _db = context;
        }

        [Route("Shop/{id}")]
        [Route("Shop")]
        public async Task<IActionResult> SelectedCategory(int? id)
        {
            if (id == null || await _db.Categories
                .FirstOrDefaultAsync(m => m.CategoryId == id)==null)
            {
                ViewData["Title"] = "Shop";
                return View("Catalog", new ShopViewModel { 
                    Categories = await _db.Categories.ToListAsync(), 
                    Articles = await _db.Articles.ToListAsync(),
                    CartItemsCount = GetCartItemsCount()
                });
            }

            HttpContext.Session.SetInt32("selectedCategoryID", (int)id);

            var category = await _db.Categories
                .FirstAsync(m => m.CategoryId == id);

            ViewData["Title"] = category.CategoryName;

            var articles = await _db.Articles.Where(m=>m.ArticleCategoryId==id).ToListAsync();
            return View("Catalog", new ShopViewModel { 
                Categories = await _db.Categories.ToListAsync(), 
                Articles = articles,
                CartItemsCount = GetCartItemsCount()});
        }

        // Nowy route. Używanie cookies
        public async Task<IActionResult> Add(int? id)
        {
            if(id==null || await _db.Articles
                .FirstOrDefaultAsync(m => m.ArticleId == id) == null)
            {
                return RedirectToAction(nameof(SelectedCategory), new { id = HttpContext.Session.GetInt32("selectedCategoryID") });
            }

            string basket;
            Basket cart;

            if (Request.Cookies.TryGetValue("basket", out basket))
            {
                cart = JsonConvert.DeserializeObject<Basket>(basket);
                BasketItem cartItem = cart.CartItems.FirstOrDefault(x => x.ArticleId == id);

                if (cartItem!=null)
                {
                    cartItem.Count++;
                }
                else
                {
                    cart.CartItems.Add(new BasketItem((int)id));
                }
            }
            else
            {
                cart = new Basket();
                cart.CartItems.Add(new BasketItem((int)id));
            }

            cart.ItemsCount++;

            SetCookie("basket", JsonConvert.SerializeObject(cart), 604800); // 1 Week
            
            return RedirectToAction(
                nameof(SelectedCategory), 
                new { id = HttpContext.Session.GetInt32("selectedCategoryID") 
                });
        }

        private int GetCartItemsCount()
        {
            string basket;
            if (Request.Cookies.TryGetValue("basket", out basket))
            {
                return JsonConvert.DeserializeObject<Basket>(basket).ItemsCount;
            }
            return 0;
        }

        public void SetCookie(string key, string value, int? numberOfSeconds = null)
        {
            CookieOptions option = new CookieOptions();
            if (numberOfSeconds.HasValue)
                option.Expires = DateTime.Now.AddSeconds(numberOfSeconds.Value);
            Response.Cookies.Append(key, value, option);
        }
    }
}
