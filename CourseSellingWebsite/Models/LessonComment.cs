using System;
using System.Collections.Generic;

namespace CourseSellingWebsite.Models;

public partial class LessonComment
{
    public string CommentId { get; set; } = null!;

    public string LessonId { get; set; } = null!;

    public string PersonId { get; set; } = null!;

    public string PersonType { get; set; } = null!;

    public string? ParentId { get; set; }

    public string Content { get; set; } = null!;

    public DateTime CreatedAt { get; set; }

    public virtual ICollection<LessonComment> InverseParent { get; set; } = new List<LessonComment>();

    public virtual Lesson Lesson { get; set; } = null!;

    public virtual LessonComment? Parent { get; set; }
}
