using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class CourseProgress
{
    public string StudentId { get; set; } = null!;

    public string LessonId { get; set; } = null!;

    public byte Progress { get; set; }

    public DateTime CompleteddAt { get; set; }

    public virtual Lesson Lesson { get; set; } = null!;

    public virtual Student Student { get; set; } = null!;
}
