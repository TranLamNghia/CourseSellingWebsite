using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class Subject
{
    public string SubjectId { get; set; } = null!;

    public string Name { get; set; } = null!;

    public virtual ICollection<Teacher> Teachers { get; set; } = new List<Teacher>();
}
