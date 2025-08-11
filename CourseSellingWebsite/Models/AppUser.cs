using Microsoft.AspNetCore.Identity;

namespace CourseSellingWebsite.Models
{
    public class AppUser : IdentityUser
    {
        public string? StudentId { get; set; }
        public string? TeacherId { get; set; }
        public string? PersonType { get; set; }
    }

}
