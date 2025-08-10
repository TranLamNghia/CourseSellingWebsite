using CourseSellingWebsite.Areas.Student.ViewModels;
using CourseSellingWebsite.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CourseSellingWebsite.Areas.Student.Controllers
{
    [Area("Student")]
    public class HomeController : Controller
    {
        private readonly AppDbContext _context;

        public HomeController(AppDbContext context)
        {
            _context = context;
        }


        [Route("Student/index")]
        public IActionResult Index()
        {
            var courses = _context.Courses.Take(6).Select(c => new
            {
                c.CourseId,
                c.Title,
                c.ImageUrl,
                c.Description,
                c.DurationDays,
                c.Price,
                SubjectName = c.Teacher.TeachingSubject.Name,
                Rating = _context.CourseRatingStats.Where(r => r.CourseId == c.CourseId)
                    .FirstOrDefault()
            }).ToList();

            var subjectCounts = from s in _context.Subjects
                join t in _context.Teachers
                     on s.SubjectId equals t.TeachingSubjectId into st
                from t in st.DefaultIfEmpty()                 // left join Teachers
                join c in _context.Courses
                     on t.TeacherId equals c.TeacherId into tc
                from c in tc.DefaultIfEmpty()                 // left join Courses
                group c by new { s.SubjectId, s.Name } into g
                select new 
                {
                    ID = g.Key.SubjectId,
                    Name = g.Key.Name,
                    Count = g.Count()
                };

            var subjects = subjectCounts
                .OrderByDescending(x => x.Count)
                .ToList();


            var viewModel = new
            {
                courses,
                subjects
            };


            return View(viewModel);
        }
    }
}
