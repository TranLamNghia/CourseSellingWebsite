using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class CourseRequirement
{
    public string CourseId { get; set; } = null!;

    public int RequirementOrder { get; set; }

    public string Content { get; set; } = null!;

    public virtual Course Course { get; set; } = null!;
}
