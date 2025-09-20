using CourseSellingWebsite.Middleware;
using CourseSellingWebsite.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace CourseSellingWebsite
{
    public class Program
    {
        public static async Task Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            builder.Services.AddIdentity<AppUser, IdentityRole>(opt =>
            {
                opt.Password.RequireNonAlphanumeric = false;
                opt.Password.RequireUppercase = false;
                opt.Password.RequiredLength = 6;
            })
            .AddEntityFrameworkStores<AppDbContext>()
            .AddDefaultTokenProviders();

            builder.Services.ConfigureApplicationCookie(opt =>
            {
                opt.LoginPath = "/signin";
                opt.AccessDeniedPath = "/access-denied";
                opt.SlidingExpiration = true;
            });

            // Add services to the container.
            builder.Services.AddControllersWithViews();
            builder.Services.AddDbContext<AppDbContext>(options =>
                options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Home/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();

            app.UseAuthentication();
            app.UseMiddleware<PopulateUserInfoMiddleware>();
            app.UseAuthorization();

            app.MapControllerRoute(
                name: "areas",
                pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");

            app.MapControllerRoute(
                name: "default",
                pattern: "{controller=Home}/{action=Index}/{id?}");

            await SeedIdentityAsync(app.Services);

            app.Run();
        }

        public static async Task SeedIdentityAsync(IServiceProvider sp)
        {
            using var scope = sp.CreateScope();
            var roleMgr = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole>>();
            var userMgr = scope.ServiceProvider.GetRequiredService<UserManager<AppUser>>();

            string[] roles = { "Admin", "Student", "Teacher" };
            foreach (var r in roles)
                if (!await roleMgr.RoleExistsAsync(r))
                    await roleMgr.CreateAsync(new IdentityRole(r));

            // Admin mặc định (nếu chưa tồn tại)
            var admin = await userMgr.FindByNameAsync("admin");
            if (admin == null)
            {
                admin = new AppUser { UserName = "admin", Email = "admin@site.com", EmailConfirmed = true };
                await userMgr.CreateAsync(admin, "Admin@123");   // nhớ đổi mật khẩu
                await userMgr.AddToRoleAsync(admin, "Admin");
            }

            var student = await userMgr.FindByNameAsync("student");
            if (student == null)
            {
                student = new AppUser { UserName = "student", Email = "student@site.com", EmailConfirmed = true };
                await userMgr.CreateAsync(student, "Student@123");   // nhớ đổi mật khẩu
                await userMgr.AddToRoleAsync(student, "Student");
            }
        }
    }
}
