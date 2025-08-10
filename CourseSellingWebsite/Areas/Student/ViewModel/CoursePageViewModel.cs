using CourseSellingWebsite.Models;

namespace CourseSellingWebsite.Areas.Student.ViewModels
{
    public class CoursePageViewModel
    {
        public Course Course { get; set; }
        public List<Course> RelatedCourses { get; set; }
        public List<string> Includes { get; set; }
        public string InCourse { get; set; }
    }
}