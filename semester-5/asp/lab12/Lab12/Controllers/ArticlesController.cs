using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Lab12.Data;
using Lab12.Models;
using Microsoft.AspNetCore.Hosting;
using System.IO;

namespace Lab12.Controllers
{
    public class ArticlesController : Controller
    {
        private readonly ShopDbContext _context;
        private readonly IHostingEnvironment _hostingEnvironment;

        public ArticlesController(ShopDbContext context, IHostingEnvironment hostingEnvironment)
        {
            _context = context;
            _hostingEnvironment = hostingEnvironment;
        }

        // GET: Articles
        public async Task<IActionResult> Index()
        {
            return View(await _context.Articles.ToListAsync());
        }

        // GET: Articles/Details/:id
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var article = await _context.Articles
                .FirstOrDefaultAsync(m => m.ArticleId == id);
            if (article == null)
            {
                return NotFound();
            }

            return View(article);
        }

        // GET: Articles/Create
        public IActionResult Create()
        {
            ViewData["ArticleCategoryId"] = new SelectList(_context.Categories, "CategoryId", "CategoryName");

            return View();
        }

        // POST: Articles/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(ArticleViewModel pvm)
        {
            if (ModelState.IsValid)
            {
                Article article = new Article { ArticleName = pvm.ArticleName, ArticleCategory=pvm.ArticleCategory, ArticleCategoryId=pvm.ArticleCategoryId, ArticlePrice=pvm.ArticlePrice };
                if (pvm.ArticleImage != null)
                {
                    string imageName = Guid.NewGuid().ToString() + "_" + pvm.ArticleImage.FileName;
                    article.ArticleImage = "/upload/" + imageName;
                    using (var fileStream = new FileStream(Path.Combine(_hostingEnvironment.WebRootPath, "upload")+ '/'+ imageName, FileMode.Create)) 
                    {
                        await pvm.ArticleImage.CopyToAsync(fileStream);
                    }
                }
                else
                {
                    article.ArticleImage = "/image/default.png";
                }
                _context.Add(article);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["ArticleCategoryId"] = new SelectList(_context.Categories, "CategoryId", "CategoryName");
            return View(pvm);

        }

        // GET: Articles/Edit/:id
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var article = await _context.Articles.FindAsync(id);
            if (article == null)
            {
                return NotFound();
            }
            ViewData["ArticleCategoryId"] = new SelectList(_context.Categories, "CategoryId", "CategoryName");
            return View(article);
        }

        // POST: Articles/Edit/:id
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Article article)
        {
            if (id != article.ArticleId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(article);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ArticleExists(article.ArticleId))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(article);
        }

        // GET: Articles/Delete/:id
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var article = await _context.Articles
                .FirstOrDefaultAsync(m => m.ArticleId == id);
            if (article == null)
            {
                return NotFound();
            }

            return View(article);
        }
        
        // POST: Articles/Delete/:id
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var article = await _context.Articles.FindAsync(id);
            RemoveArticleImage(article.ArticleImage);
            _context.Articles.Remove(article);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ArticleExists(int id)
        {
            return _context.Articles.Any(e => e.ArticleId == id);
        }

        private void RemoveArticleImage(string articleImage)
        {
            if (articleImage != "/image/default.png")
            {
                System.IO.File.Delete(_hostingEnvironment.WebRootPath + articleImage);
            }
        }
    }
}
