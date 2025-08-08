using System.Diagnostics;
using CourseSellingWebsite.Models;
using CourseSellingWebsite.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CourseSellingWebsite.Controllers
{
    public class HomeController : Controller
    {
        private readonly AppDbContext _context;
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger, AppDbContext context)
        {
            _context = context;
            _logger = logger;
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

        [HttpGet]
        [Route("/signup")]
        public IActionResult SignUp()
        {
            return View(new SignUpVM());
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
