using Microsoft.AspNetCore.Mvc;

namespace CourseSellingWebsite.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class TeacherController : Controller
    {
        public IActionResult Index()
        {
            ViewData["Title"] = "Quản Lý Giáo Viên";
            return View();
        }
    }
}
