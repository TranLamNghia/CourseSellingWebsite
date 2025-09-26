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
            var famousTeacher = _context.Teachers.Include(t => t.TeachingSubject).Take(3).ToList();

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
        [Route("/signup")]
        public async Task<IActionResult> SignUp(SignUpVM model)
        {
            if (!ModelState.IsValid)
            {
                TempData.SetToast(ToastType.Error, "Thông tin đăng ký không hợp lệ", "Đăng ký");
                return View(model);
            }

            var existUser = await _users.FindByEmailAsync(model.Email);
            if (existUser != null)
            {
                ModelState.AddModelError("", "Email đã tồn tại");
                TempData.SetToast(ToastType.Error, "Email đã được sử dụng", "Đăng ký");
                return View(model);
            }

            var newUser = new AppUser
            {
                UserName = model.Email,
                FullName = model.LastName + " " + model.FirstName,
                Email = model.Email,
                PhoneNumber = model.DienThoai
            };

            var result = await _users.CreateAsync(newUser, model.Password);

            if (!result.Succeeded)
            {
                foreach (var err in result.Errors)
                {
                    ModelState.AddModelError("", err.Description);
                }
                TempData.SetToast(ToastType.Error, "Đăng ký thất bại", "Đăng ký");
                return View(model);
            }

            if (model.UserType.ToLower().Equals("student"))
            {
                var student = new Student
                {
                    StudentId = newUser.Id,
                    FullName = model.LastName + " " + model.FirstName,
                    Email = model.Email,
                    PhoneNumber = model.DienThoai,
                    AvatarUrl = "/images/default-avatar.png"
                };
                _context.Students.Add(student);
                await _context.SaveChangesAsync();

                newUser.StudentId = student.StudentId;
                await _users.UpdateAsync(newUser);
            }

            string role = model.UserType.ToLower() switch
            {
                "admin" => "Admin",
                "student" => "Student",
                _ => "Student"
            };
            await _users.AddToRoleAsync(newUser, role);

            await _signIn.SignInAsync(newUser, isPersistent: false);

            TempData.SetToast(ToastType.Success, "Đăng ký thành công!", "Đăng ký");

            return RedirectToAction("SignIn", "Home");
            //return role switch
            //{
            //    "Admin" => RedirectToAction("Index", "Dashboard", new { area = "Admin" }),
            //    "Teacher" => RedirectToAction("Index", "Home", new { area = "Teacher" }),
            //    _ => RedirectToAction("Index", "Home", new { area = "Student" }),
            //};
        }

        [HttpPost]
        [Route("/signout")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SignOut()
        {
            await _signIn.SignOutAsync();
            HttpContext.Items.Remove("UserInfo");

            TempData.SetToast(ToastType.Success, "Đăng xuất thành công", "Hệ thống");
            return RedirectToAction("Index", "Home");
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
