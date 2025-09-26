using Microsoft.AspNetCore.Identity;

namespace CourseSellingWebsite.Models
{
    public class AppUser : IdentityUser
    {
        public string? StudentId { get; set; }
        public Student? Student { get; set; }
        public string? TeacherId { get; set; }
        public Teacher? Teacher { get; set; }
        public string FullName { get; internal set; }
    }

}
