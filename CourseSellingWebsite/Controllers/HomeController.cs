using System.Diagnostics;
using CourseSellingWebsite.Extensions;
using CourseSellingWebsite.Models;
using CourseSellingWebsite.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CourseSellingWebsite.Controllers
{
    public class HomeController : Controller
    {
        private readonly AppDbContext _context;
        private readonly SignInManager<AppUser> _signIn;
        private readonly ILogger<HomeController> _logger;
        private readonly UserManager<AppUser> _users;

        public HomeController(AppDbContext context, ILogger<HomeController> logger, SignInManager<AppUser> signIn, UserManager<AppUser> users)
        {
            _context = context;
            _signIn = signIn;
            _logger = logger;
            _users = users;
        }

        public IActionResult Index()
        {
            //select famous teacher
            var famousTeacher = _context.Teachers.Include(t => t.TeachingSubject).Take(3).ToList();

            // select famous course 
            var famousCourse = _context.Courses.Take(3).Select(c => new
            {
                c.CourseId,
                c.Title,
                c.ImageUrl,
                c.Price,
                c.Description,
                Rating = _context.CourseRatingStats.Where(crs => crs.CourseId == c.CourseId)
                    .Select(crs => new
                    {
                        crs.RatingCount,
                        crs.RatingAvg
                    })
                    .FirstOrDefault()
            }).ToList();

            var viewModel = new
            {
                famousTeacher,
                famousCourse
            };
            return View(viewModel);
        }

        [HttpGet]
        [Route("/signin")]
        public IActionResult SignIn()
        {
            return View(new SignInVM());
        }

        [HttpPost]
        [Route("/signin")]
        [ValidateAntiForgeryToken]
        [AllowAnonymous]
        public async Task<IActionResult> SignIn(SignInVM model, string? returnUrl = null)
        {
            if (!ModelState.IsValid)
            {
                TempData.SetToast(ToastType.Error, "Đăng nhập không thành công", "Đăng nhập");
                return View(model);
            }

            string selectedRole = model.UserType.Trim().ToLower() switch
            {
                "admin" => "Admin",
                "teacher" => "Teacher",
                "student" => "Student"
            };

            var user = await _users.FindByNameAsync(model.UserName);
            if (user == null)
            {
                ModelState.AddModelError(string.Empty, "Không tìm thấy người này");
                TempData.SetToast(ToastType.Error, "Không tìm thấy người này", "Đăng nhập");
                return View(model);
            }

            var userRole = await _users.IsInRoleAsync(user, selectedRole);
            if (!userRole) {
                ModelState.AddModelError("", "Không tìm thấy người này");
                TempData.SetToast(ToastType.Error, "Không tìm thấy người này", "Đăng nhập");
                return View(model);
            }

            var result = await _signIn.PasswordSignInAsync(user, model.Password, model.RememberMe, false);
            if (!result.Succeeded)
            {
                ModelState.AddModelError(string.Empty, "Sai tài khoản hoặc mật khẩu");
                TempData.SetToast(ToastType.Error, "Sai tài khoản hoặc mật khẩu", "Đăng nhập");
                return View(model);
            }

            return selectedRole switch
            {
                "Admin" => RedirectToAction("Index", "Dashboard", new { area = "Admin" }),
                "Teacher" => RedirectToAction("Index", "Home", new { area = "Teacher" }),
                _ => RedirectToAction("Index", "Home", new { area = "Student" }),
            };
        }

        [HttpGet]
        [Route("/signup")]
        public IActionResult SignUp()
        {
            return View(new SignUpVM());
        }

        [HttpPost]
        public async Task<IActionResult> Logout()
        {
            await _signIn.SignOutAsync();
            return RedirectToAction("Login");
        }


        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
