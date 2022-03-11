using System;
using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;

namespace Lab10.Controllers
{
    public class GameController : Controller
    {
        private static readonly Random _random = new Random();

        public IActionResult Index()
        {
            return View();
        }

        // Używanie zmiennej sesyjnej
        public IActionResult Set(int n)
        {
            
            ViewBag.Message = "";
            ViewBag.Color = "green";
            if (n <= 0)
            {
                ViewBag.Message = $"Proszę podać liczbę większą od 0";
                ViewBag.Color = "red";
            }
            else
            {
                HttpContext.Session.SetInt32("limit", n);

                ViewBag.Message = $"Limit ustawiono na {HttpContext.Session.GetInt32("limit")}";
            }
            return View("Set");
        }

        // Używanie zmiennej sesyjnej
        public IActionResult Draw()
        {
            ViewBag.Message = $"Zgadnij liczbę od 0 do {HttpContext.Session.GetInt32("limit")}";

            byte[] test;
            if(HttpContext.Session.GetInt32("limit") <= 0 || !HttpContext.Session.TryGetValue("limit", out test))
            {
                ViewBag.Message = "Nie podałeś zakresu do losowania";
            }
            else
            {

                HttpContext.Session.SetInt32("generatedNumber", _random.Next((int)HttpContext.Session.GetInt32("limit")));
            }

            return View("Draw");
        }

        // Używanie zmiennej sesyjnej
        public IActionResult Guess(int number)
        {
            ViewBag.GoodLimit = true;
            byte[] test;
            if (HttpContext.Session.GetInt32("limit") <= 0 
                || !HttpContext.Session.TryGetValue("limit", out test) 
                || !HttpContext.Session.TryGetValue("generatedNumber", out test))
            {
                ViewBag.GoodLimit = false;
            }
            ViewBag.PlayerX = number;
            ViewBag.X = HttpContext.Session.GetInt32("generatedNumber");
            return View("Guess");
        }
    }
}
