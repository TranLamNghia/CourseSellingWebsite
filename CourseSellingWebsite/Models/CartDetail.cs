using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class CartDetail
{
    public string CartId { get; set; } = null!;

    public string CourseId { get; set; } = null!;

    public virtual Cart Cart { get; set; } = null!;

    public virtual Course Course { get; set; } = null!;

    public virtual ICollection<OrderHistory> OrderHistories { get; set; } = new List<OrderHistory>();
}
