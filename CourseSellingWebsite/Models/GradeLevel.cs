using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class GradeLevel
{
    public int GradeId { get; set; }

    public string Name { get; set; } = null!;

    public virtual ICollection<Course> Courses { get; set; } = new List<Course>();

    public virtual ICollection<Student> Students { get; set; } = new List<Student>();
}
