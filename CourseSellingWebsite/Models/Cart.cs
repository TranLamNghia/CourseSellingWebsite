using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class Cart
{
    public string CartId { get; set; } = null!;

    public string StudentId { get; set; } = null!;

    public DateTime CreatedAt { get; set; }

    public virtual ICollection<CartDetail> CartDetails { get; set; } = new List<CartDetail>();

    public virtual Student Student { get; set; } = null!;
}
