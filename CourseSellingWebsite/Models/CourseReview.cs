using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class CourseReview
{
    public int ReviewId { get; set; }

    public string StudentId { get; set; } = null!;

    public string CourseId { get; set; } = null!;

    public int? Rating { get; set; }

    public DateTime? ReviewTime { get; set; }

    public virtual Course Course { get; set; } = null!;

    public virtual Student Student { get; set; } = null!;
}
