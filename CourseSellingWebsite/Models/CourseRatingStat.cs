using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class CourseRatingStat
{
    public string CourseId { get; set; } = null!;

    public int? RatingCount { get; set; }

    public decimal? RatingAvg { get; set; }
}
