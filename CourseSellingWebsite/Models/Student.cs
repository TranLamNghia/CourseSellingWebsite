using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class Student
{
    public string StudentId { get; set; } = null!;

    public string FullName { get; set; } = null!;

    public string PassHash { get; set; } = null!;

    public int? GradeId { get; set; }

    public string? AvatarUrl { get; set; }

    public string Email { get; set; } = null!;

    public string? PhoneNumber { get; set; }

    public DateOnly? BirthDate { get; set; }

    public string? Gender { get; set; }

    public string? Address { get; set; }

    public DateTime RegisteredAt { get; set; }

    public virtual ICollection<Cart> Carts { get; set; } = new List<Cart>();

    public virtual ICollection<CourseProgress> CourseProgresses { get; set; } = new List<CourseProgress>();

    public virtual ICollection<CourseStudent> CourseStudents { get; set; } = new List<CourseStudent>();

    public virtual GradeLevel? Grade { get; set; }

    public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();
}
