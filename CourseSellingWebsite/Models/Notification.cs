using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class Notification
{
    public int NotificationId { get; set; }

    public string StudentId { get; set; } = null!;

    public string Title { get; set; } = null!;

    public string Body { get; set; } = null!;

    public bool IsRead { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual Student Student { get; set; } = null!;
}
