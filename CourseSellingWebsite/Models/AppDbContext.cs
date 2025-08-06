using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace CourseSellingWebsite.Models;

public partial class AppDbContext : DbContext
{
    public AppDbContext()
    {
    }

    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Admin> Admins { get; set; }

    public virtual DbSet<Cart> Carts { get; set; }

    public virtual DbSet<CartDetail> CartDetails { get; set; }

    public virtual DbSet<Course> Courses { get; set; }

    public virtual DbSet<CourseGoal> CourseGoals { get; set; }

    public virtual DbSet<CourseProgress> CourseProgresses { get; set; }

    public virtual DbSet<CourseRequirement> CourseRequirements { get; set; }

    public virtual DbSet<CourseStudent> CourseStudents { get; set; }

    public virtual DbSet<GradeLevel> GradeLevels { get; set; }

    public virtual DbSet<Lesson> Lessons { get; set; }

    public virtual DbSet<LessonComment> LessonComments { get; set; }

    public virtual DbSet<Notification> Notifications { get; set; }

    public virtual DbSet<OrderHistory> OrderHistories { get; set; }

    public virtual DbSet<Student> Students { get; set; }

    public virtual DbSet<Subject> Subjects { get; set; }

    public virtual DbSet<Teacher> Teachers { get; set; }

    public virtual DbSet<ViewPerson> ViewPeople { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=TranLamNghia;Initial Catalog=CourseSellingWebsite;User ID=sa;Password=123456;Encrypt=False;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Admin>(entity =>
        {
            entity.HasKey(e => e.AdminId).HasName("PK__Admin__719FE4E8A4B55422");

            entity.ToTable("Admin");

            entity.HasIndex(e => e.Email, "UQ__Admin__A9D10534FD9D696E").IsUnique();

            entity.Property(e => e.AdminId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("AdminID");
            entity.Property(e => e.AvatarUrl).HasMaxLength(1000);
            entity.Property(e => e.Email).HasMaxLength(200);
            entity.Property(e => e.FullName).HasMaxLength(200);
            entity.Property(e => e.PassHash).IsUnicode(false);
            entity.Property(e => e.PhoneNumber).HasMaxLength(50);
        });

        modelBuilder.Entity<Cart>(entity =>
        {
            entity.HasKey(e => e.CartId).HasName("PK__Cart__51BCD797BD419871");

            entity.ToTable("Cart", tb => tb.HasTrigger("trg_Cart_InsteadOfInsert"));

            entity.Property(e => e.CartId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("CartID");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.StudentId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("StudentID");

            entity.HasOne(d => d.Student).WithMany(p => p.Carts)
                .HasForeignKey(d => d.StudentId)
                .HasConstraintName("FK__Cart__StudentID__628FA481");
        });

        modelBuilder.Entity<CartDetail>(entity =>
        {
            entity.HasKey(e => new { e.CartId, e.CourseId }).HasName("PK__CartDeta__3D2E008FC3BD229C");

            entity.ToTable("CartDetail");

            entity.Property(e => e.CartId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("CartID");
            entity.Property(e => e.CourseId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("CourseID");

            entity.HasOne(d => d.Cart).WithMany(p => p.CartDetails)
                .HasForeignKey(d => d.CartId)
                .HasConstraintName("FK__CartDetai__CartI__656C112C");

            entity.HasOne(d => d.Course).WithMany(p => p.CartDetails)
                .HasForeignKey(d => d.CourseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CartDetai__Cours__66603565");
        });

        modelBuilder.Entity<Course>(entity =>
        {
            entity.HasKey(e => e.CourseId).HasName("PK__Course__C92D7187EC3A061E");

            entity.ToTable("Course", tb => tb.HasTrigger("trg_Course_InsteadOfInsert"));

            entity.Property(e => e.CourseId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("CourseID");
            entity.Property(e => e.DiscountPercent).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.DurationDays).HasDefaultValue(150);
            entity.Property(e => e.GradeId).HasColumnName("GradeID");
            entity.Property(e => e.ImageUrl).HasMaxLength(1000);
            entity.Property(e => e.Price).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.TeacherId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("TeacherID");
            entity.Property(e => e.Title).HasMaxLength(300);
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Grade).WithMany(p => p.Courses)
                .HasForeignKey(d => d.GradeId)
                .HasConstraintName("FK__Course__GradeID__45F365D3");

            entity.HasOne(d => d.Teacher).WithMany(p => p.Courses)
                .HasForeignKey(d => d.TeacherId)
                .HasConstraintName("FK__Course__TeacherI__44FF419A");
        });

        modelBuilder.Entity<CourseGoal>(entity =>
        {
            entity.HasKey(e => new { e.CourseId, e.GoalOrder }).HasName("PK__CourseGo__8031A6B63DE8AAC3");

            entity.ToTable("CourseGoal");

            entity.Property(e => e.CourseId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("CourseID");
            entity.Property(e => e.GoalOrder).ValueGeneratedOnAdd();
            entity.Property(e => e.Content).HasMaxLength(1000);

            entity.HasOne(d => d.Course).WithMany(p => p.CourseGoals)
                .HasForeignKey(d => d.CourseId)
                .HasConstraintName("FK__CourseGoa__Cours__48CFD27E");
        });

        modelBuilder.Entity<CourseProgress>(entity =>
        {
            entity.HasKey(e => new { e.StudentId, e.LessonId }).HasName("PK__CoursePr__29CD60B2175D51B8");

            entity.ToTable("CourseProgress");

            entity.Property(e => e.StudentId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("StudentID");
            entity.Property(e => e.LessonId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("LessonID");
            entity.Property(e => e.CompleteddAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Lesson).WithMany(p => p.CourseProgresses)
                .HasForeignKey(d => d.LessonId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CoursePro__Lesso__5EBF139D");

            entity.HasOne(d => d.Student).WithMany(p => p.CourseProgresses)
                .HasForeignKey(d => d.StudentId)
                .HasConstraintName("FK__CoursePro__Stude__5DCAEF64");
        });

        modelBuilder.Entity<CourseRequirement>(entity =>
        {
            entity.HasKey(e => new { e.CourseId, e.RequirementOrder }).HasName("PK__CourseRe__7D70E0DC42A0F086");

            entity.ToTable("CourseRequirement");

            entity.Property(e => e.CourseId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("CourseID");
            entity.Property(e => e.RequirementOrder).ValueGeneratedOnAdd();
            entity.Property(e => e.Content).HasMaxLength(1000);

            entity.HasOne(d => d.Course).WithMany(p => p.CourseRequirements)
                .HasForeignKey(d => d.CourseId)
                .HasConstraintName("FK__CourseReq__Cours__4BAC3F29");
        });

        modelBuilder.Entity<CourseStudent>(entity =>
        {
            entity.HasKey(e => new { e.CourseId, e.StudentId }).HasName("PK__CourseSt__4A012320B291A929");

            entity.ToTable("CourseStudent");

            entity.Property(e => e.CourseId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("CourseID");
            entity.Property(e => e.StudentId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("StudentID");
            entity.Property(e => e.EnrolledAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Course).WithMany(p => p.CourseStudents)
                .HasForeignKey(d => d.CourseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CourseStu__Cours__6E01572D");

            entity.HasOne(d => d.Student).WithMany(p => p.CourseStudents)
                .HasForeignKey(d => d.StudentId)
                .HasConstraintName("FK__CourseStu__Stude__6EF57B66");
        });

        modelBuilder.Entity<GradeLevel>(entity =>
        {
            entity.HasKey(e => e.GradeId).HasName("PK__GradeLev__54F87A37A5AC2834");

            entity.ToTable("GradeLevel");

            entity.HasIndex(e => e.Name, "UQ__GradeLev__737584F6745C879D").IsUnique();

            entity.Property(e => e.GradeId).HasColumnName("GradeID");
            entity.Property(e => e.Name).HasMaxLength(100);
        });

        modelBuilder.Entity<Lesson>(entity =>
        {
            entity.HasKey(e => e.LessonId).HasName("PK__Lesson__B084ACB0DD14302A");

            entity.ToTable("Lesson", tb =>
                {
                    tb.HasTrigger("TR_DeleteLesson_CascadeCourseProgress");
                    tb.HasTrigger("trg_Lesson_InsteadOfInsert");
                });

            entity.Property(e => e.LessonId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("LessonID");
            entity.Property(e => e.CourseId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("CourseID");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Title).HasMaxLength(200);
            entity.Property(e => e.VideoUrl).HasMaxLength(1000);

            entity.HasOne(d => d.Course).WithMany(p => p.Lessons)
                .HasForeignKey(d => d.CourseId)
                .HasConstraintName("FK__Lesson__CourseID__4F7CD00D");
        });

        modelBuilder.Entity<LessonComment>(entity =>
        {
            entity.HasKey(e => e.CommentId).HasName("PK__LessonCo__C3B4DFAA3BFD82B8");

            entity.ToTable("LessonComment", tb => tb.HasTrigger("trg_LessonComment_InsteadOfInsert"));

            entity.Property(e => e.CommentId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("CommentID");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.LessonId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("LessonID");
            entity.Property(e => e.ParentId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("ParentID");
            entity.Property(e => e.PersonId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("PersonID");
            entity.Property(e => e.PersonType)
                .HasMaxLength(10)
                .IsUnicode(false);

            entity.HasOne(d => d.Lesson).WithMany(p => p.LessonComments)
                .HasForeignKey(d => d.LessonId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LessonCom__Lesso__74AE54BC");

            entity.HasOne(d => d.Parent).WithMany(p => p.InverseParent)
                .HasForeignKey(d => d.ParentId)
                .HasConstraintName("FK__LessonCom__Paren__75A278F5");
        });

        modelBuilder.Entity<Notification>(entity =>
        {
            entity.HasKey(e => new { e.StudentId, e.NotificationId }).HasName("PK__Notifica__00C9D89A51EC74B9");

            entity.ToTable("Notification");

            entity.Property(e => e.StudentId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("StudentID");
            entity.Property(e => e.NotificationId)
                .ValueGeneratedOnAdd()
                .HasColumnName("NotificationID");
            entity.Property(e => e.Body).HasMaxLength(200);
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Title).HasMaxLength(200);

            entity.HasOne(d => d.Student).WithMany(p => p.Notifications)
                .HasForeignKey(d => d.StudentId)
                .HasConstraintName("FK__Notificat__Stude__59063A47");
        });

        modelBuilder.Entity<OrderHistory>(entity =>
        {
            entity.HasKey(e => e.OrderId).HasName("PK__OrderHis__C3905BAF2E2D7792");

            entity.ToTable("OrderHistory", tb => tb.HasTrigger("trg_OrderHistory_InsteadOfInsert"));

            entity.Property(e => e.OrderId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("OrderID");
            entity.Property(e => e.CartId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("CartID");
            entity.Property(e => e.CourseId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("CourseID");
            entity.Property(e => e.CreateAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.CartDetail).WithMany(p => p.OrderHistories)
                .HasForeignKey(d => new { d.CartId, d.CourseId })
                .HasConstraintName("FK__OrderHistory__6A30C649");
        });

        modelBuilder.Entity<Student>(entity =>
        {
            entity.HasKey(e => e.StudentId).HasName("PK__Student__32C52A79D966B53B");

            entity.ToTable("Student", tb => tb.HasTrigger("trg_Student_InsteadOfInsert"));

            entity.HasIndex(e => e.Email, "UQ__Student__A9D1053443E37B6E").IsUnique();

            entity.Property(e => e.StudentId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("StudentID");
            entity.Property(e => e.Address).HasMaxLength(500);
            entity.Property(e => e.AvatarUrl).HasMaxLength(1000);
            entity.Property(e => e.Email).HasMaxLength(200);
            entity.Property(e => e.FullName).HasMaxLength(200);
            entity.Property(e => e.Gender).HasMaxLength(10);
            entity.Property(e => e.GradeId).HasColumnName("GradeID");
            entity.Property(e => e.PassHash).IsUnicode(false);
            entity.Property(e => e.PhoneNumber).HasMaxLength(50);
            entity.Property(e => e.RegisteredAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Grade).WithMany(p => p.Students)
                .HasForeignKey(d => d.GradeId)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("FK__Student__GradeID__5441852A");
        });

        modelBuilder.Entity<Subject>(entity =>
        {
            entity.HasKey(e => e.SubjectId).HasName("PK__Subject__AC1BA3880261DB1F");

            entity.ToTable("Subject");

            entity.HasIndex(e => e.Name, "UQ__Subject__737584F607D394ED").IsUnique();

            entity.Property(e => e.SubjectId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("SubjectID");
            entity.Property(e => e.Name)
                .HasMaxLength(30)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Teacher>(entity =>
        {
            entity.HasKey(e => e.TeacherId).HasName("PK__Teacher__EDF25944D749B30E");

            entity.ToTable("Teacher", tb => tb.HasTrigger("trg_Teacher_InsteadOfInsert"));

            entity.HasIndex(e => e.Email, "UQ__Teacher__A9D105346DCE1017").IsUnique();

            entity.Property(e => e.TeacherId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("TeacherID");
            entity.Property(e => e.AvatarUrl).HasMaxLength(1000);
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(200);
            entity.Property(e => e.FullName).HasMaxLength(200);
            entity.Property(e => e.Gender).HasMaxLength(10);
            entity.Property(e => e.PassHash).IsUnicode(false);
            entity.Property(e => e.PhoneNumber).HasMaxLength(50);
            entity.Property(e => e.TeachingSubjectId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("TeachingSubjectID");

            entity.HasOne(d => d.TeachingSubject).WithMany(p => p.Teachers)
                .HasForeignKey(d => d.TeachingSubjectId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("FK_Teacher_Subject");
        });

        modelBuilder.Entity<ViewPerson>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("View_Person");

            entity.Property(e => e.AvatarUrl).HasMaxLength(1000);
            entity.Property(e => e.Email).HasMaxLength(200);
            entity.Property(e => e.FullName).HasMaxLength(200);
            entity.Property(e => e.PersonId)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("PersonID");
            entity.Property(e => e.PersonType)
                .HasMaxLength(7)
                .IsUnicode(false);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
