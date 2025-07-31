CREATE DATABASE CourseSellingWebsite;
GO

USE CourseSellingWebsite;
GO

-- Teacher table
CREATE TABLE dbo.Teacher (
    TeacherID           VARCHAR(20)		NOT NULL PRIMARY KEY,
    FullName            NVARCHAR(200)   NOT NULL,
	PassHash            VARCHAR(MAX)    NOT NULL,
    AvatarUrl           NVARCHAR(1000)  NULL,
	Gender              NVARCHAR(10)    NOT NULL,
    Email               NVARCHAR(200)   NOT NULL UNIQUE,
    PhoneNumber         NVARCHAR(50)    NULL,
    Description         NVARCHAR(MAX)   NULL,
    CreatedAt           DATETIME        NOT NULL DEFAULT GETDATE()
);
GO

-- Course Subject
CREATE TABLE dbo.Subject (
    SubjectID			VARCHAR(30)		NOT NULL PRIMARY KEY,
    Name				INT				NOT NULL UNIQUE
);
GO

-- GradeLevel table
CREATE TABLE dbo.GradeLevel (
    GradeID				INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name				NVARCHAR(100)     NOT NULL UNIQUE
);
GO

-- Course table
CREATE TABLE dbo.Course (
    CourseID            VARCHAR(20)		NOT NULL PRIMARY KEY,
    SubjectID           VARCHAR(30)		NOT NULL,
	GradeID				INT				NOT NULL,
    Title               NVARCHAR(300)   NOT NULL,
    ImageUrl            NVARCHAR(1000)  NULL,
    Description         NVARCHAR(MAX)   NOT NULL,
    Price               DECIMAL(10,2)   NOT NULL,
	DiscountPercent		DECIMAL(5,2)	NOT NULL DEFAULT (0),
    DurationDays        INT             NOT NULL DEFAULT 150,
    TeacherID           VARCHAR(20)		NOT NULL,
    UpdatedAt           DATETIME        NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY(TeacherID) REFERENCES dbo.Teacher(TeacherID)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(SubjectID) REFERENCES dbo.Subject(SubjectID)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(GradeID) REFERENCES dbo.GradeLevel(GradeID)
		ON UPDATE CASCADE ON DELETE CASCADE
);
GO

-- CourseGoal table
CREATE TABLE dbo.CourseGoal (
    CourseID            VARCHAR(20)		NOT NULL,
    GoalOrder           INT IDENTITY(1,1) NOT NULL,
    Content             NVARCHAR(1000)  NOT NULL,
    PRIMARY KEY (CourseID, GoalOrder),
    FOREIGN KEY (CourseID) REFERENCES dbo.Course(CourseID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- CourseRequirement table
CREATE TABLE dbo.CourseRequirement (
    CourseID            VARCHAR(20)    NOT NULL,
    RequirementOrder    INT IDENTITY(1,1) NOT NULL,
    Content             NVARCHAR(1000)  NOT NULL,
    PRIMARY KEY (CourseID, RequirementOrder),
    FOREIGN KEY (CourseID) REFERENCES dbo.Course(CourseID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- Lesson table
CREATE TABLE dbo.Lesson (
    LessonID            VARCHAR(30)    NOT NULL PRIMARY KEY,
    CourseID            VARCHAR(20)    NOT NULL,
    LessonOrder         INT             NOT NULL,
    Title               NVARCHAR(200)   NULL,
    VideoUrl            NVARCHAR(1000)  NOT NULL,
    CreatedAt           DATETIME        NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY(CourseID) REFERENCES dbo.Course(CourseID)
      ON UPDATE CASCADE ON DELETE CASCADE
);
GO

-- Student table
CREATE TABLE dbo.Student (
    StudentID           VARCHAR(20)    NOT NULL PRIMARY KEY,
    FullName            NVARCHAR(200)   NOT NULL,
    PassHash            VARCHAR(MAX)    NOT NULL,
	GradeID				INT				NULL,
    AvatarUrl           NVARCHAR(1000)  NULL,
    Email               NVARCHAR(200)   NOT NULL UNIQUE,
    PhoneNumber         NVARCHAR(50)    NULL,
    BirthDate           DATE            NULL,
    Gender              NVARCHAR(10)    NULL,
    Address             NVARCHAR(500)   NULL,
    RegisteredAt        DATETIME        NOT NULL DEFAULT GETDATE(),
	FOREIGN KEY(GradeID) REFERENCES dbo.GradeLevel(GradeID)
		ON UPDATE CASCADE ON DELETE CASCADE
);
GO

-- Notification table
CREATE TABLE dbo.Notification (
    NotificationID      INT IDENTITY(1,1) NOT NULL,
    StudentID           VARCHAR(20)		NOT NULL,
    Title               NVARCHAR(200)   NOT NULL,
    Body				NVARCHAR(200)	NOT NULL,
	IsRead				BIT				NOT NULL DEFAULT 0,
    CreatedAt           DATETIME        NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY (StudentID, NotificationID),
    FOREIGN KEY(StudentID) REFERENCES dbo.Student(StudentID)
      ON UPDATE CASCADE ON DELETE CASCADE
);
GO

-- CourseProgress table
CREATE TABLE dbo.CourseProgress (
    StudentID           VARCHAR(20)		NOT NULL,
    LessonID            VARCHAR(30)		NOT NULL,
    Progress            TINYINT			NOT NULL DEFAULT(0),
    CompleteddAt        DATETIME        NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY (StudentID, LessonID),
	FOREIGN KEY(StudentID) REFERENCES dbo.Student(StudentID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(LessonID) REFERENCES dbo.Lesson(LessonID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO

-- Cart table
CREATE TABLE dbo.Cart (
    CartID              VARCHAR(30)    NOT NULL PRIMARY KEY,
    StudentID           VARCHAR(20)    NOT NULL,
    CreatedAt           DATETIME        NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY(StudentID) REFERENCES dbo.Student(StudentID)
        ON UPDATE CASCADE ON DELETE CASCADE
);
GO

-- CartDetail table
CREATE TABLE dbo.CartDetail (
    CartID              VARCHAR(30)    NOT NULL,
    CourseID            VARCHAR(20)    NOT NULL,
    PRIMARY KEY (CartID, CourseID),
    FOREIGN KEY(CartID) REFERENCES dbo.Cart(CartID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY(CourseID) REFERENCES dbo.Course(CourseID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

--  Order table
CREATE TABLE dbo.OrderHistory (
	OrderID             VARCHAR(30)    NOT NULL PRIMARY KEY,
    CartID              VARCHAR(30)    NOT NULL,
    CourseID            VARCHAR(20)    NOT NULL,
	CreateAt			DATETIME		DEFAULT(GETDATE()),	
	FOREIGN KEY(CartID, CourseID) REFERENCES dbo.CartDetail(CartID, CourseID)
        ON DELETE NO ACTION ON UPDATE CASCADE,
)
GO

-- CourseStudent join table
CREATE TABLE dbo.CourseStudent (
    CourseID            VARCHAR(20)    NOT NULL,
    StudentID           VARCHAR(20)    NOT NULL,
    EnrolledAt          DATETIME        NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (CourseID, StudentID),
     FOREIGN KEY(CourseID) REFERENCES dbo.Course(CourseID)
        ON UPDATE NO ACTION ON DELETE CASCADE,
     FOREIGN KEY(StudentID) REFERENCES dbo.Student(StudentID)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO

-- Person view	
CREATE VIEW dbo.View_Person AS
SELECT 
    StudentID AS PersonID,
    'STUDENT' AS PersonType,
    FullName,
    Email,
    AvatarUrl
FROM dbo.Student
UNION
SELECT 
    TeacherID,
    'TEACHER',
    FullName,
    Email,
    AvatarUrl
FROM dbo.Teacher;
GO

-- LessonComment table
CREATE TABLE dbo.LessonComment (
    CommentID       VARCHAR(30)     NOT NULL PRIMARY KEY,
    LessonID        VARCHAR(30)     NOT NULL,
    PersonID        VARCHAR(20)     NOT NULL,
    PersonType      VARCHAR(10)     NOT NULL CHECK (PersonType IN ('STUDENT', 'TEACHER')),
    ParentID        VARCHAR(30)     NULL,
    Content         NVARCHAR(MAX)   NOT NULL,
    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (LessonID) REFERENCES dbo.Lesson(LessonID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ParentID) REFERENCES dbo.LessonComment(CommentID)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO


-- Admin table
CREATE TABLE dbo.Admin (
    AdminID             VARCHAR(20)    NOT NULL PRIMARY KEY,
    FullName            NVARCHAR(200)   NOT NULL,
    PassHash            VARCHAR(MAX)    NOT NULL,
    AvatarUrl           NVARCHAR(1000)  NULL,
    Email               NVARCHAR(200)   NOT NULL UNIQUE,
    PhoneNumber         NVARCHAR(50)    NULL
);
GO


-- Trigger for Teacher auto-ID (formerly trg_GiaoVien_InsteadOfInsert)
CREATE TRIGGER trg_Teacher_InsteadOfInsert
ON dbo.Teacher
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Used TABLE (ID INT);
    INSERT INTO @Used (ID)
    SELECT CAST(SUBSTRING(TeacherID, 8, LEN(TeacherID) - 7) AS INT)
    FROM dbo.Teacher
    WHERE ISNUMERIC(SUBSTRING(TeacherID, 8, LEN(TeacherID) - 7)) = 1;

    DECLARE @MinUnused INT = 1;
    WHILE EXISTS (SELECT 1 FROM @Used WHERE ID = @MinUnused)
        SET @MinUnused += 1;

    INSERT INTO dbo.Teacher
        (TeacherID, FullName, AvatarUrl, Email, PhoneNumber, Description, CreatedAt)
    SELECT
        COALESCE(i.TeacherID, 'Teacher' + CAST(@MinUnused AS VARCHAR)),
        i.FullName, i.AvatarUrl, i.Email, i.PhoneNumber, i.Description, GETDATE()
    FROM inserted AS i;
END;
GO

-- Trigger for Student auto-ID & Cart creation (formerly trg_HocSinh_InsteadOfInsert)
CREATE TRIGGER trg_Student_InsteadOfInsert
ON dbo.Student
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaxID INT;
    SELECT @MaxID = MAX(CAST(SUBSTRING(StudentID, 8, LEN(StudentID) - 7) AS INT))
    FROM dbo.Student
    WHERE ISNUMERIC(SUBSTRING(StudentID, 8, LEN(StudentID) - 7)) = 1;
    SET @MaxID = ISNULL(@MaxID, 0);

    DECLARE @NewStudents TABLE (
        StudentID NVARCHAR(20), FullName NVARCHAR(200), PassHash VARCHAR(MAX),
        AvatarUrl NVARCHAR(1000), Email NVARCHAR(200), PhoneNumber NVARCHAR(50),
        BirthDate DATE, Gender NVARCHAR(10), Address NVARCHAR(500)
    );

    INSERT INTO @NewStudents (StudentID, FullName, PassHash, AvatarUrl, Email, PhoneNumber, BirthDate, Gender, Address)
    SELECT
        'Student' + CAST(@MaxID + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR),
        HoTen = i.FullName, i.PassHash, i.AvatarUrl, i.Email, i.PhoneNumber, i.BirthDate, i.Gender, i.Address
    FROM inserted AS i;

    INSERT INTO dbo.Student (StudentID, FullName, PassHash, AvatarUrl, Email, PhoneNumber, BirthDate, Gender, Address, RegisteredAt)
    SELECT StudentID, FullName, PassHash, AvatarUrl, Email, PhoneNumber, BirthDate, Gender, Address, GETDATE()
    FROM @NewStudents;

    INSERT INTO dbo.Cart (CartID, StudentID, CreatedAt)
    SELECT 'Cart_' + StudentID, StudentID, GETDATE() FROM @NewStudents;
END;
GO

-- Trigger for Course auto-ID (formerly trg_KhoaHoc_InsteadOfInsert)
CREATE TRIGGER trg_Course_InsteadOfInsert
ON dbo.Course
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @baseMax INT = (
      SELECT ISNULL(MAX(CAST(SUBSTRING(CourseID,7,3) AS INT)),0) FROM dbo.Course
    );

    INSERT INTO dbo.Course
      (CourseID, SubjectID, Title, ImageUrl, Description, Price, DurationDays, TeacherID, UpdatedAt)
    SELECT
      COALESCE(i.CourseID, 'Course' + RIGHT(CAST(@baseMax + ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS VARCHAR(3)),3)),
      i.SubjectID, i.Title, i.ImageUrl, i.Description, i.Price, i.DurationDays, i.TeacherID, GETDATE()
    FROM inserted AS i;
END;
GO

-- Trigger for Lesson auto-ID (formerly dbo.trg_BaiHoc_InsteadOfInsert)
CREATE TRIGGER trg_Lesson_InsteadOfInsert
ON dbo.Lesson
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Lesson (LessonID, CourseID, LessonOrder, Title, VideoUrl, CreatedAt)
    SELECT
        COALESCE(i.LessonID, i.CourseID + '_' + RIGHT('00' + CAST(i.LessonOrder AS VARCHAR(2)),2)),
        i.CourseID, i.LessonOrder, i.Title, i.VideoUrl, GETDATE()
    FROM inserted AS i;
END;
GO

CREATE TRIGGER trg_LessonComment_InsteadOfInsert
ON dbo.LessonComment
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaxID INT;
    SELECT @MaxID = MAX(CAST(SUBSTRING(CommentID, 8, LEN(CommentID)-7) AS INT))
    FROM dbo.LessonComment
    WHERE ISNUMERIC(SUBSTRING(CommentID, 8, LEN(CommentID)-7)) = 1;

    SET @MaxID = ISNULL(@MaxID, 0);

    INSERT INTO dbo.LessonComment (CommentID, LessonID, PersonID, PersonType, ParentID, Content, CreatedAt)
    SELECT 
        COALESCE(i.CommentID, 'Comment' + RIGHT('000000' + CAST(@MaxID + ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS VARCHAR),6)),
        i.LessonID, i.PersonID, i.PersonType, i.ParentID, i.Content, GETDATE()
    FROM inserted i;
END;
GO

CREATE TRIGGER trg_OrderHistory_InsteadOfInsert
ON dbo.OrderHistory
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaxID INT;
    SELECT @MaxID = MAX(CAST(SUBSTRING(OrderID, 6, LEN(OrderID)-5) AS INT))
    FROM dbo.OrderHistory
    WHERE ISNUMERIC(SUBSTRING(OrderID, 6, LEN(OrderID)-5)) = 1;

    SET @MaxID = ISNULL(@MaxID, 0);

    INSERT INTO dbo.OrderHistory (OrderID, CartID, CourseID, CreateAt)
    SELECT
        COALESCE(i.OrderID, 'Order' + RIGHT('000000' + CAST(@MaxID + ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS VARCHAR),6)),
        i.CartID, i.CourseID, GETDATE()
    FROM inserted i;
END;
GO

CREATE TRIGGER trg_Cart_InsteadOfInsert
ON dbo.Cart
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaxID INT;
    SELECT @MaxID = MAX(CAST(SUBSTRING(CartID, 5, LEN(CartID)-4) AS INT))
    FROM dbo.Cart
    WHERE ISNUMERIC(SUBSTRING(CartID, 5, LEN(CartID)-4)) = 1;

    SET @MaxID = ISNULL(@MaxID, 0);

    INSERT INTO dbo.Cart (CartID, StudentID, CreatedAt)
    SELECT 
        COALESCE(i.CartID, 'Cart' + RIGHT('000' + CAST(@MaxID + ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS VARCHAR),3)),
        i.StudentID, GETDATE()
    FROM inserted i;
END;
GO



----- INSERT GIAOVIEN
INSERT INTO dbo.Teacher (FullName, AvatarUrl, Email, PhoneNumber, Description)
VALUES (N'Nguyễn Văn A', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747840647/1_manaaf.jpg', 'nguyenvana748@example.com', '0901234567', N'Hơn 10 năm kinh nghiệm trong nghề');

INSERT INTO dbo.Teacher (FullName, AvatarUrl, Email, PhoneNumber, Description)
VALUES (N'Trần Thị B', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747840647/2_s0bzbb.jpg', 'tranthib982@example.com', '0912345678', N'Giáo viên nhiệt tình trẻ tuổi');

INSERT INTO dbo.Teacher (FullName, AvatarUrl, Email, PhoneNumber, Description)
VALUES (N'Lê Văn C', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747840647/1_manaaf.jpg', 'levanc351@example.com', '0923456789', N'Giáo viên nhiệt tình trẻ tuổi');

INSERT INTO dbo.Teacher (FullName, AvatarUrl, Email, PhoneNumber, Description)
VALUES (N'Phạm Thị D', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747840647/2_s0bzbb.jpg', 'phamthid623@example.com', '0934567890', N'Giáo viên nhiệt tình trẻ tuổi');

INSERT INTO dbo.Teacher (FullName, AvatarUrl, Email, PhoneNumber, Description)
VALUES (N'Hoàng Văn E', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747840647/1_manaaf.jpg', 'hoangvane107@example.com', '0945678901', NULL);

INSERT INTO dbo.Teacher (FullName, AvatarUrl, Email, PhoneNumber, Description)
VALUES (N'Vũ Thị F', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747840647/2_s0bzbb.jpg', 'vuthif462@example.com', '0956789012', NULL);

INSERT INTO dbo.Teacher (FullName, AvatarUrl, Email, PhoneNumber, Description)
VALUES (N'Đặng Văn G', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747840647/1_manaaf.jpg', 'dangvang715@example.com', '0967890123', NULL);

INSERT INTO dbo.Teacher (FullName, AvatarUrl, Email, PhoneNumber, Description)
VALUES (N'Bùi Thị H', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747840647/2_s0bzbb.jpg', 'buithih289@example.com', '0978901234', NULL);

INSERT INTO dbo.Teacher (FullName, AvatarUrl, Email, PhoneNumber, Description)
VALUES (N'Ngô Văn I', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747840647/1_manaaf.jpg', 'ngovani390@example.com', '0989012345', NULL);

INSERT INTO dbo.Teacher (FullName, AvatarUrl, Email, PhoneNumber, Description)
VALUES (N'Đỗ Thị K', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747840647/2_s0bzbb.jpg', 'dothik178@example.com', '0990123456', NULL);


----- INSERT KHOAHOC
INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Toán', N'Toán 10 cơ bản', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Khóa học toán lớp 10 cơ bản dành cho học sinh phổ thông.', 500000, DEFAULT, 'Teacher1');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Hóa học', N'Hóa học 11 nâng cao', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Nâng cao kiến thức hóa học lớp 11 với các chuyên đề nâng cao.', 650000, 140, 'Teacher1');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Vật lý', N'Vật lý 10 - Sách bài tập', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Hướng dẫn giải bài tập Vật lý 10 theo chương trình chuẩn.', 400000, DEFAULT, 'Teacher2');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Ngữ văn', N'Ngữ văn 12 ôn thi THPT', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Tổng hợp kiến thức ngữ văn lớp 12 để ôn thi THPT.', 700000, 140, 'Teacher3');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Địa lý', N'Địa lý 12 luyện đề', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Luyện tập các đề thi thử địa lý lớp 12 theo cấu trúc đề thi mới.', 550000, 140, 'Teacher4');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Sinh học', N'Sinh học 10 cơ bản', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Tìm hiểu cấu trúc tế bào, sinh học phân tử và di truyền học cơ bản.', 500000, DEFAULT, 'Teacher4');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Tin học', N'Tin học 11 lập trình Pascal', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Khóa học lập trình Pascal cơ bản dành cho học sinh lớp 11.', 600000, DEFAULT, 'Teacher5');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Tiếng Anh', N'Tiếng Anh 10 nâng cao', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Trọn bộ kiến thức nâng cao tiếng Anh lớp 10, phát âm và giao tiếp.', 750000, DEFAULT, 'Teacher5');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Giáo dục công dân', N'GDCD 12 trọng tâm', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Tổng hợp kiến thức GDCD 12 trọng tâm thi THPT.', 400000, 140, 'Teacher6');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Toán', N'Toán 11 hình học nâng cao', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Chuyên đề hình học không gian lớp 11 nâng cao.', 600000, DEFAULT, 'Teacher6');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Hóa học', N'Hóa học 12 luyện thi đại học', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Các chuyên đề trọng điểm hóa học 12, luyện thi THPT quốc gia.', 700000, DEFAULT, 'Teacher7');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Vật lý', N'Vật lý 12 lý thuyết trọng tâm', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Các phần lý thuyết quan trọng Vật lý lớp 12, ôn luyện thi.', 500000, 140, 'Teacher7');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Tiếng Anh', N'Tiếng Anh 12 luyện đề', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Khóa luyện đề tiếng Anh 12 chuẩn cấu trúc đề thi quốc gia.', 800000, DEFAULT, 'Teacher8');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Sinh học', N'Sinh học 12 di truyền nâng cao', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Chuyên đề di truyền và biến dị dành cho học sinh khá giỏi.', 600000, DEFAULT, 'Teacher8');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Ngữ văn', N'Ngữ văn 10 cảm thụ văn học', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Phân tích, cảm nhận tác phẩm văn học lớp 10 theo hướng sáng tạo.', 450000, 140, 'Teacher9');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Lịch sử', N'Lịch sử Việt Nam hiện đại', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Tổng quan lịch sử Việt Nam thế kỷ XX và XXI.', 550000, DEFAULT, 'Teacher9');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Tin học', N'Tin học 12 ứng dụng văn phòng', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Sử dụng Word, Excel, PowerPoint hiệu quả trong học tập và thi cử.', 500000, DEFAULT, 'Teacher10');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Công nghệ', N'Công nghệ 12 - Lâm nghiệp, thuỷ sản', 'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Giới thiệu chung về lâm nghiệp; Trồng và chăm sóc rừng; Bảo vệ và khai thác tài nguyên rừng bền vững; Giới thiệu chung về thuỷ sản; Môi trường nuôi thuỷ sản; Công nghệ giống thuỷ sản; Công nghệ thức ăn thuỷ sản; Công nghệ nuôi thuỷ sản; Phòng, trị bệnh thuỷ sản; Bảo vệ và khai thác nguồn lợi thuỷ sản.', 400000, DEFAULT, 'Teacher6');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Toán', N'Toán 11 đại số', N'https://res.cloudinary.com/druj32kwu/image/upload/v1748266690/To%C3%A1n_jtqchi.png', N'Hệ phương trình, bất phương trình, logarit và mũ cho lớp 11.', 600000, DEFAULT, 'Teacher2');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Hóa học', N'Hóa học 10 cơ bản', N'https://res.cloudinary.com/druj32kwu/image/upload/v1748265930/Chemistry_vswrf7.png', N'Cấu tạo nguyên tử, bảng tuần hoàn và liên kết hóa học.', 550000, DEFAULT, 'Teacher4');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Tiếng Anh', N'Tiếng Anh giao tiếp THPT', N'https://res.cloudinary.com/druj32kwu/image/upload/v1748266328/TiengAnh_cuoidu.png', N'Luyện phản xạ và từ vựng tiếng Anh cho học sinh THPT.', 750000, DEFAULT, 'Teacher7');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Sinh học', N'Sinh học 11 chuyên đề tế bào', N'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Chuyên đề về cấu trúc và chức năng tế bào nâng cao.', 500000, DEFAULT, 'Teacher6');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Ngữ văn', N'Ngữ văn 11 cảm thụ văn học', N'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Kỹ năng đọc hiểu và phân tích tác phẩm văn học lớp 11.', 480000, DEFAULT, 'Teacher3');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Lịch sử', N'Lịch sử Việt Nam hiện đại lớp 11', N'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Tìm hiểu cách mạng, chiến tranh và xây dựng đất nước.', 420000, DEFAULT, 'Teacher1');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Địa lý', N'Địa lý kinh tế xã hội lớp 10', N'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Khái niệm và mối quan hệ giữa các yếu tố địa lý kinh tế.', 450000, DEFAULT, 'Teacher5');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Công nghệ', N'Công nghệ 11 - Vẽ kỹ thuật', N'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Kỹ thuật vẽ hình chiếu, hình cắt và biểu diễn vật thể.', 500000, DEFAULT, 'Teacher8');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Giáo dục công dân', N'GDCD 11 - Quyền công dân', N'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Tìm hiểu pháp luật và trách nhiệm của công dân trong xã hội.', 400000, DEFAULT, 'Teacher9');

INSERT INTO dbo.Course (Subject, Title, ImageUrl, Description, Price, DurationDays, TeacherID)
VALUES (N'Tin học', N'Tin học 12 - Lập trình C++ cơ bản', N'https://res.cloudinary.com/druj32kwu/image/upload/v1747841841/unknown_g8spau.png', N'Cấu trúc điều khiển, hàm và mảng trong ngôn ngữ lập trình C++.', 650000, DEFAULT, 'Teacher10');


INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES 
('Course1', 1, N'Không có');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES 
('Course2', 1, N'Đã hoàn thành khóa học Hóa học 10 cơ bản'),
('Course2', 2, N'Nắm vững bảng tuần hoàn và phản ứng hóa học cơ bản');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES 
('Course3', 1, N'Có khả năng giải bài tập vật lý cơ bản');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES 
('Course4', 1, N'Không có');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES 
('Course5', 1, N'Biết sử dụng bản đồ và đọc số liệu địa lý');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES 
('Course6', 1, N'Không có');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES 
('Course7', 1, N'Biết sử dụng máy tính và có kiến thức Tin học cơ bản'),
('Course7', 2, N'Đã làm quen với thuật toán và tư duy logic');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES 
('Course8', 1, N'Đã học xong khóa Tiếng Anh cơ bản hoặc tương đương'),
('Course8', 2, N'Có từ vựng và ngữ pháp trình độ A2 trở lên');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES 
('Course9', 1, N'Đã học qua kiến thức GDCD lớp 11');


INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES 
('Course10', 1, N'Không có');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES
('Course11', 1, N'Đã hoàn thành khóa học Hóa học 11 nâng cao'),
('Course11', 2, N'Biết cách giải các bài toán phản ứng nâng cao');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES
('Course12', 1, N'Không có');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES
('Course13', 1, N'Đã hoàn thành Tiếng Anh 10 và 11 nâng cao'),
('Course13', 2, N'Nắm vững ngữ pháp cơ bản và từ vựng học thuật');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES
('Course14', 1, N'Hoàn thành Sinh học 10 cơ bản'),
('Course14', 2, N'Đã học kiến thức nền về tế bào và ADN');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES
('Course15', 1, N'Không có');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES
('Course16', 1, N'Không có');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES
('Course17', 1, N'Đã học Tin học 11 lập trình Pascal'),
('Course17', 2, N'Có kỹ năng cơ bản sử dụng máy tính');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES
('Course18', 1, N'Không có');

INSERT INTO dbo.CourseRequirement (CourseID, RequirementOrder, Content) VALUES
('Course19', 1, N'Không có');

INSERT INTO dbo.CourseGoal (CourseID, GoalOrder, Content) VALUES
('Course1', 1, N'Nắm vững các kiến thức cơ bản Toán lớp 10'),
('Course1', 2, N'Rèn luyện kỹ năng giải bài tập cơ bản'),

('Course2', 1, N'Hiểu sâu kiến thức nâng cao về Hóa học lớp 11'),
('Course2', 2, N'Giải quyết các bài tập khó và luyện thi chuyên'),

('Course3', 1, N'Rèn luyện kỹ năng giải bài tập vật lý theo sách giáo khoa'),
('Course3', 2, N'Củng cố kiến thức cơ bản qua thực hành'),

('Course4', 1, N'Tổng hợp kiến thức Ngữ văn 12 ôn thi THPT'),
('Course4', 2, N'Phát triển kỹ năng viết và cảm thụ văn học'),

('Course5', 1, N'Làm quen với cấu trúc đề thi môn Địa lý'),
('Course5', 2, N'Tăng khả năng làm bài thi trắc nghiệm'),

('Course6', 1, N'Tìm hiểu cấu trúc tế bào và di truyền cơ bản'),
('Course6', 2, N'Hình thành nền tảng Sinh học lớp 10'),

('Course7', 1, N'Làm quen cú pháp và lệnh cơ bản trong Pascal'),
('Course7', 2, N'Thực hành viết chương trình đơn giản'),

('Course8', 1, N'Phát triển khả năng nói và giao tiếp tiếng Anh'),
('Course8', 2, N'Nâng cao kỹ năng viết và đọc hiểu'),

('Course9', 1, N'Hiểu rõ quyền và nghĩa vụ công dân trong xã hội'),
('Course9', 2, N'Sẵn sàng cho kỳ thi THPT môn GDCD'),

('Course10', 1, N'Củng cố kiến thức hình học không gian lớp 11 nâng cao'),
('Course10', 2, N'Phân tích và giải các bài toán về đường thẳng và mặt phẳng trong không gian'),
('Course10', 3, N'Rèn luyện kỹ năng vẽ hình và tưởng tượng không gian tốt hơn'),
('Course10', 4, N'Vận dụng định lý và công thức hình học vào giải bài tập nâng cao'),
('Course10', 5, N'Chuẩn bị cho các kỳ thi học sinh giỏi và kỳ thi THPT quốc gia phần hình học'),

('Course11', 1, N'Nắm vững các chuyên đề Hóa học lớp 12'),
('Course11', 2, N'Biết cách áp dụng lý thuyết vào bài tập trắc nghiệm'),
('Course11', 3, N'Luyện kỹ năng giải nhanh để thi THPT Quốc gia'),
('Course11', 4, N'Tăng cường phản xạ khi gặp câu hỏi lạ'),

('Course12', 1, N'Hệ thống lại toàn bộ lý thuyết Vật lý lớp 12'),
('Course12', 2, N'Hiểu rõ bản chất các hiện tượng vật lý'),
('Course12', 3, N'Ứng dụng lý thuyết vào giải bài tập nâng cao'),
('Course12', 4, N'Tự tin ôn luyện cho kỳ thi THPT quốc gia'),

('Course13', 1, N'Làm quen với các dạng đề thi THPT Quốc gia'),
('Course13', 2, N'Tăng cường từ vựng và cấu trúc câu học thuật'),
('Course13', 3, N'Nâng cao khả năng đọc hiểu và ngữ pháp'),
('Course13', 4, N'Luyện kỹ năng xử lý câu hỏi nhanh và chính xác'),

('Course14', 1, N'Hiểu sâu về quy luật di truyền học và biến dị'),
('Course14', 2, N'Ứng dụng lý thuyết vào giải bài tập phức tạp'),
('Course14', 3, N'Tăng cường tư duy phân tích và hệ thống kiến thức'),
('Course14', 4, N'Chuẩn bị tốt cho kỳ thi học kỳ và thi đại học'),

('Course15', 1, N'Phát triển kỹ năng đọc hiểu văn bản văn học'),
('Course15', 2, N'Biết cách cảm thụ và phân tích tác phẩm'),
('Course15', 3, N'Tăng khả năng diễn đạt cảm xúc qua bài viết'),
('Course15', 4, N'Chuẩn bị tốt cho các bài kiểm tra đọc hiểu'),

('Course16', 1, N'Hiểu rõ các sự kiện lịch sử Việt Nam thế kỷ XX'),
('Course16', 2, N'Liên hệ lịch sử với thực tiễn hiện nay'),
('Course16', 3, N'Biết cách phân tích, tổng hợp nội dung lịch sử'),
('Course16', 4, N'Làm quen với các dạng câu hỏi trong đề thi sử'),

('Course17', 1, N'Sử dụng thành thạo Word, Excel, PowerPoint'),
('Course17', 2, N'Thực hành tạo báo cáo, bảng biểu chuyên nghiệp'),
('Course17', 3, N'Nắm vững mẹo và kỹ thuật tin học văn phòng'),
('Course17', 4, N'Ứng dụng kiến thức vào thực tiễn đời sống và nghề nghiệp'),

('Course18', 1, N'Tìm hiểu về kỹ thuật nuôi trồng thủy sản, lâm nghiệp'),
('Course18', 2, N'Tiếp cận các mô hình công nghệ trong sản xuất nông nghiệp'),
('Course18', 3, N'Hiểu rõ chuỗi sản xuất và bảo quản sản phẩm nông lâm nghiệp'),
('Course18', 4, N'Ứng dụng kiến thức vào thực tiễn đời sống và nghề nghiệp'),

('Course19', 1, N'Nắm vững các chuyên đề đại số lớp 11'),
('Course19', 2, N'Luyện kỹ năng giải phương trình và bất phương trình'),
('Course19', 3, N'Phát triển tư duy logic và khả năng suy luận'),
('Course19', 4, N'Chuẩn bị nền tảng vững chắc cho chương trình lớp 12');

INSERT INTO dbo.Lesson (CourseID, LessonOrder, Title, VideoUrl) VALUES
('Course1', 1, N'Giới thiệu Toán 10 và định hướng học tập', 'https://res.cloudinary.com/druj32kwu/video/upload/v1748358829/2025-05-27_22-12-29_hm5ri6.mp4'),
('Course1', 2, N'Phương pháp giải phương trình bậc hai', 'https://res.cloudinary.com/druj32kwu/video/upload/v1748358829/2025-05-27_22-12-36_monkyj.mp4'),
('Course1', 3, N'Thực hành các dạng toán cơ bản', 'https://res.cloudinary.com/druj32kwu/video/upload/v1748358830/2025-05-27_22-12-42_eufxva.mp4'),

('Course2', 1, N'Cấu tạo nguyên tử nâng cao', 'https://res.cloudinary.com/druj32kwu/video/upload/v1748358829/2025-05-27_22-12-29_hm5ri6.mp4'),
('Course2', 2, N'Phân tích phản ứng oxi hóa khử', 'https://res.cloudinary.com/druj32kwu/video/upload/v1748358829/2025-05-27_22-12-36_monkyj.mp4'),
('Course2', 3, N'Bài tập tổng hợp chương 1-3', 'https://res.cloudinary.com/druj32kwu/video/upload/v1748358830/2025-05-27_22-12-42_eufxva.mp4'),

('Course3', 1, N'Cơ bản về chuyển động cơ', 'https://res.cloudinary.com/druj32kwu/video/upload/v1748358829/2025-05-27_22-12-29_hm5ri6.mp4'),
('Course3', 2, N'Phân tích đồ thị chuyển động', 'https://res.cloudinary.com/druj32kwu/video/upload/v1748358829/2025-05-27_22-12-36_monkyj.mp4'),
('Course3', 3, N'Giải bài tập sách giáo khoa phần I', 'https://res.cloudinary.com/druj32kwu/video/upload/v1748358830/2025-05-27_22-12-42_eufxva.mp4');


INSERT INTO Admin (
    AdminID, 
    FullName, 
    PassHash, 
    AvatarUrl,
    Email, 
    PhoneNumber
)
VALUES (
    'Admin001',                                                        -- MaAdmin: ID duy nhất cho admin
    N'Admin',                                         -- HoTen: Tên của admin
    'AQAAAAIAAYagAAAAEPBTMAOrkabgrzzyPWbupIoCW+A3XEkgDYhkECpIKh+I4MXb/bfXzmvY1cqAtjDA6Q==', -- PassHash: Mật khẩu ĐÃ ĐƯỢC HASH AN TOÀN cho admin này
    'https://res.cloudinary.com/your_cloud_name/image/upload/default_admin_avatar.png', -- DuongDanAnhDaiDien: URL ảnh đại diện (hoặc NULL nếu cho phép)
    'admin_chinh@example.com',                                         -- Email: Email của admin
    '0123456789'                                                    -- DienThoai: Số điện thoại (hoặc NULL)

);
-- sodienthoai: 0123456789 matkhau: 12345



select * from Student