using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class CourseStudent
{
    public string CourseId { get; set; } = null!;

    public string StudentId { get; set; } = null!;

    public DateTime EnrolledAt { get; set; }

    public virtual Course Course { get; set; } = null!;

    public virtual Student Student { get; set; } = null!;
}
