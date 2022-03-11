using Lab12.Models;
using Microsoft.EntityFrameworkCore;

namespace Lab12.Data
{
    public class ShopDbContext : DbContext
    {
        public DbSet<Article> Articles { get; set; }
        public DbSet<Category> Categories { get; set; }

        public ShopDbContext(DbContextOptions<ShopDbContext> options) : base(options)
        {
            Database.EnsureCreated();
        }
    }
}
