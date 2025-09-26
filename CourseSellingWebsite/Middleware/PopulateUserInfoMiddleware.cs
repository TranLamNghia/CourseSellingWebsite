using Microsoft.AspNetCore.Identity;
using CourseSellingWebsite.Models;
using CourseSellingWebsite.ViewModels;
using Microsoft.EntityFrameworkCore;

namespace CourseSellingWebsite.Middleware
{
    public class PopulateUserInfoMiddleware
    {
        private readonly RequestDelegate _next;

        public PopulateUserInfoMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task InvokeAsync(HttpContext context, UserManager<AppUser> userManager, AppDbContext db)
        {
            if (context.User?.Identity?.IsAuthenticated == true && !context.Items.ContainsKey("UserInfo"))
            {
                var user = await userManager.GetUserAsync(context.User);
                if (user != null)
                {
                    var roles = await userManager.GetRolesAsync(user);
                    var role = roles.FirstOrDefault() ?? "Student";

                    string avatar = "/images/default-avatar.png";
                    string email = user.Email ?? "";
                    string displayName = user.FullName ?? "";   // <- từ AppUser

                    if (role == "Student" && user.StudentId != null)
                    {
                        var s = await db.Students.FindAsync(user.StudentId);
                        if (s != null)
                        {
                            avatar = s.AvatarUrl ?? avatar;
                            email = string.IsNullOrWhiteSpace(s.Email) ? email : s.Email!;
                            displayName = string.IsNullOrWhiteSpace(s.FullName) ? displayName : s.FullName!;
                        }
                    }
                    else if (role == "Teacher" && user.TeacherId != null)
                    {
                        var t = await db.Teachers.FindAsync(user.TeacherId);
                        if (t != null)
                        {
                            avatar = t.AvatarUrl ?? avatar;
                            email = string.IsNullOrWhiteSpace(t.Email) ? email : t.Email!;
                            displayName = string.IsNullOrWhiteSpace(t.FullName) ? displayName : t.FullName!;
                        }
                    }

                    context.Items["UserInfo"] = new UserInfoVM
                    {
                        UserName = user.UserName ?? "",
                        Email = email,
                        Role = role,
                        AvatarUrl = avatar,
                        DisplayName = displayName
                    };
                }
            }
            await _next(context);
        }
    }
}
