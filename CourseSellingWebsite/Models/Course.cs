using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class Course
{
    public string CourseId { get; set; } = null!;

    public int GradeId { get; set; }

    public string Title { get; set; } = null!;

    public string? ImageUrl { get; set; }

    public string Description { get; set; } = null!;

    public decimal Price { get; set; }

    public decimal DiscountPercent { get; set; }

    public int DurationDays { get; set; }

    public string TeacherId { get; set; } = null!;

    public DateTime UpdatedAt { get; set; }

    public virtual ICollection<CartDetail> CartDetails { get; set; } = new List<CartDetail>();

    public virtual ICollection<CourseGoal> CourseGoals { get; set; } = new List<CourseGoal>();

    public virtual ICollection<CourseRequirement> CourseRequirements { get; set; } = new List<CourseRequirement>();

    public virtual ICollection<CourseStudent> CourseStudents { get; set; } = new List<CourseStudent>();

    public virtual GradeLevel Grade { get; set; } = null!;

    public virtual ICollection<Lesson> Lessons { get; set; } = new List<Lesson>();

    public virtual Teacher Teacher { get; set; } = null!;
}
