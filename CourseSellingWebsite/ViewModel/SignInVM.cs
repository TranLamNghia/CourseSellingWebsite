using System.ComponentModel.DataAnnotations;

namespace CourseSellingWebsite.ViewModels
{
    public class SignInVM
    {
        [Required]
        [Phone]
        public string DienThoai { get; set; }
        [Required]
        [DataType(DataType.Password)]
        public string Password { get; set; }
        public bool RememberMe { get; set; }
        public string UserType { get; set; }
    }
}