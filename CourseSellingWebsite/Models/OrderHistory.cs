using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class OrderHistory
{
    public string OrderId { get; set; } = null!;

    public string CartId { get; set; } = null!;

    public string CourseId { get; set; } = null!;

    public DateTime? CreateAt { get; set; }

    public virtual CartDetail CartDetail { get; set; } = null!;
}
