using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace lab10.Controllers
{
    public class GameController : Controller
    {
        private static readonly Random rand = new Random();
        private static int limit = -1;
        private static int nextNumber = -1;

        private static void GenerateNumber()
        {
            nextNumber = rand.Next(limit);
        }

        public IActionResult Set(int n)
        {
            if (n > 0)
            {
                limit = n;
            }

            ViewBag.n = n;
            return View("Set");
        }

        public IActionResult Draw()
        {
            if (limit == -1)
            {
                ViewBag.errorMsg = "Najpierw ustaw limit";
            } else
            {
                ViewBag.n = limit;
                GenerateNumber();
            }

            return View("Draw");
        }

        public IActionResult Guess(int n)
        {
            if (limit == -1)
            {
                ViewBag.errorMsg = "Najpierw ustaw limit i wygeneruj liczbę";
            } else if (nextNumber == -1)
            {
                ViewBag.errorMsg = "Najpierw wygeneruj liczbę";
            } else
            {
                ViewBag.guessedX = n;
                ViewBag.X = nextNumber;

                if (n == nextNumber) nextNumber = -1;
            }

            return View("Guess");
        }
    }
}
