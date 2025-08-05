using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class Lesson
{
    public string LessonId { get; set; } = null!;

    public string CourseId { get; set; } = null!;

    public int LessonOrder { get; set; }

    public string? Title { get; set; }

    public string VideoUrl { get; set; } = null!;

    public DateTime CreatedAt { get; set; }

    public virtual Course Course { get; set; } = null!;

    public virtual ICollection<CourseProgress> CourseProgresses { get; set; } = new List<CourseProgress>();

    public virtual ICollection<LessonComment> LessonComments { get; set; } = new List<LessonComment>();
}
