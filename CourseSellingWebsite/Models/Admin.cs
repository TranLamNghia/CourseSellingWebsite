using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class Admin
{
    public string AdminId { get; set; } = null!;

    public string FullName { get; set; } = null!;

    public string PassHash { get; set; } = null!;

    public string? AvatarUrl { get; set; }

    public string Email { get; set; } = null!;

    public string? PhoneNumber { get; set; }
}
