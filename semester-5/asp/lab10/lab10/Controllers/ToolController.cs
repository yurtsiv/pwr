using Microsoft.AspNetCore.Mvc;
using System;
using System.Text;

namespace lab10.Controllers
{
    public class ToolController : Controller
    {
        [Route("Tool/Solve/{a}/{b}/{c}")]
        public IActionResult Solve(int a, int b, int c)
        {
            ViewBag.a = a;
            ViewBag.b = b;
            ViewBag.c = c;

            ViewBag.rootsCount = -1;

            StringBuilder equationStr = new StringBuilder();

            equationStr.Append($"{a}x^2");
            equationStr.Append(b < 0 ? $"{b}x" : $"+{b}x");
            equationStr.Append(c < 0 ? $"{c}" : $"+{c}");
            equationStr.Append(" = 0");

            ViewBag.equationStr = equationStr.ToString();

            if (a == 0)
            {
                return View();
            }

            float d = b * b - 4 * a * c;
            ViewBag.d = d;

            if (d < 0)
            {
                ViewBag.rootsCount = 0;
            }
            else
            {
                float x1 = (-1 * b + (float)Math.Sqrt(d)) / (2 * a);
                float x2 = (-1 * b - (float)Math.Sqrt(d)) / (2 * a);

                if (x1 == x2)
                {
                    ViewBag.rootsCount = 1;
                    ViewBag.x1 = $"{x1:F2}";
                }
                else
                {
                    ViewBag.rootsCount = 2;
                    ViewBag.x1 = $"{x1:F2}";
                    ViewBag.x2 = $"{x2:F2}";
                }
            }

            return View();
        }
    }
}
