using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class ViewPerson
{
    public string PersonId { get; set; } = null!;

    public string PersonType { get; set; } = null!;

    public string FullName { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string? AvatarUrl { get; set; }
}
