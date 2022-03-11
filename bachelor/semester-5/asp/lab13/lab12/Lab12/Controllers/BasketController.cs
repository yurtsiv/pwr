using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Lab12.Data;
using Lab12.Models;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;



// Nowy controller
namespace Lab12.Controllers
{
    public class BasketController : Controller
    {
        private readonly ShopDbContext _db;
        public BasketController(ShopDbContext context)
        {
            _db = context;
        }

        [Route("Shop/Basket")]
        public ActionResult Index()
        {
            string basket;
            if(!Request.Cookies.TryGetValue("basket", out basket))
            {
                ViewBag.CartIsEmpty = true;
                return View();
            }
            ViewBag.CartIsEmpty = false;

            Basket cart = JsonConvert.DeserializeObject<Basket>(basket);

            if(cart.CartItems.Count==0)
            {
                ViewBag.CartIsEmpty = true;
                return View();
            }


            List<BasketItemViewModel> cartItemViewModels = new List<BasketItemViewModel>();

            foreach (var item in cart.CartItems)
            {
                var article = _db.Articles.FirstOrDefault(x => x.ArticleId == item.ArticleId);

                if (article == null)
                    continue;

                cartItemViewModels.Add(new BasketItemViewModel
                {
                    Id = item.ArticleId,
                    Count = item.Count,
                    Price = article.ArticlePrice,
                    Name = article.ArticleName,
                    Image = article.ArticleImage
                });
            }

            int total = Convert.ToInt32(cartItemViewModels.Select(item => item.Price * item.Count).Sum());

            BasketViewModel cartViewModel = new BasketViewModel { BasketItems = cartItemViewModels, Total = total };

            return View(cartViewModel);
        }

        public ActionResult Add(int id)
        {
            Basket cart = GetCartFromCookie();
            cart.CartItems.First(x => x.ArticleId == id).Count++;
            cart.ItemsCount++;
            UpdateCartInCookie(cart);

            return RedirectToAction(nameof(Index));
        }

        public ActionResult Sub(int id)
        {
            Basket cart = GetCartFromCookie();
            BasketItem cartItem = cart.CartItems.First(x => x.ArticleId == id);
            if (cartItem.Count > 1)
            {
                cartItem.Count--;
                cart.ItemsCount--;
            }
            UpdateCartInCookie(cart);

            return RedirectToAction(nameof(Index));
        }

        public ActionResult Delete(int id)
        {
            Basket cart = GetCartFromCookie();
            BasketItem cartItem = cart.CartItems.First(x => x.ArticleId == id);
            cart.ItemsCount -= cartItem.Count;
            cart.CartItems.Remove(cartItem);

            UpdateCartInCookie(cart);
            return RedirectToAction(nameof(Index));
        }

        private Basket GetCartFromCookie()
        {
            string basket = Request.Cookies["basket"];
            Basket cart = JsonConvert.DeserializeObject<Basket>(basket);

            return cart;
        }

        private void UpdateCartInCookie(Basket cart)
        {
            SetCookie("basket", JsonConvert.SerializeObject(cart), 604800); // 1 Week
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
