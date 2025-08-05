using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class Teacher
{
    public string TeacherId { get; set; } = null!;

    public string FullName { get; set; } = null!;

    public string PassHash { get; set; } = null!;

    public string? AvatarUrl { get; set; }

    public string? TeachingSubjectId { get; set; }

    public string Gender { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string? PhoneNumber { get; set; }

    public string? Description { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual ICollection<Course> Courses { get; set; } = new List<Course>();

    public virtual Subject? TeachingSubject { get; set; }
}
