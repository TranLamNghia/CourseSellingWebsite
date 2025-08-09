-- 1. Thêm 3 học sinh mới
INSERT INTO Student (StudentID, FullName, PassHash, GradeID, AvatarUrl, Email, PhoneNumber, BirthDate, Gender, Address, RegisteredAt)
VALUES ('Student999', 'Nguyen Van A', 'AQAAAAIAAYagAAAAEPBTMAOrkabgrzzyPWbupIoCW+A3XEkgDYhkECpIKh+I4MXb/bfXzmvY1cqAtjDA6Q==', 10, NULL, 'a@example.com', '0900000001', '2000-01-01', 'Nam', 'HCM', GETDATE());

INSERT INTO Student (StudentID, FullName, PassHash, GradeID, AvatarUrl, Email, PhoneNumber, BirthDate, Gender, Address, RegisteredAt)
VALUES ('Student998', 'Tran Thi B', 'AQAAAAIAAYagAAAAEPBTMAOrkabgrzzyPWbupIoCW+A3XEkgDYhkECpIKh+I4MXb/bfXzmvY1cqAtjDA6Q==', 10, NULL, 'b@example.com', '0900000002', '2000-02-02', N'Nữ', 'HCM', GETDATE());

INSERT INTO Student (StudentID, FullName, PassHash, GradeID, AvatarUrl, Email, PhoneNumber, BirthDate, Gender, Address, RegisteredAt)
VALUES ('Student997', 'Le Van C', 'AQAAAAIAAYagAAAAEPBTMAOrkabgrzzyPWbupIoCW+A3XEkgDYhkECpIKh+I4MXb/bfXzmvY1cqAtjDA6Q==', 10, NULL, 'c@example.com', '0900000003', '2000-03-03', N'Nữ', 'HCM', GETDATE());

UPDATE Student SET StudentID = 'Student999' WHERE StudentID = 'Student1'
UPDATE Student SET StudentID = 'Student998' WHERE StudentID = 'Student2'
UPDATE Student SET StudentID = 'Student997' WHERE StudentID = 'Student3'

-- 2. Ghi nhận học sinh đã học CourseID = 1
INSERT INTO CourseStudent (CourseID, StudentID, EnrolledAt)
VALUES ('Course1', 'Student999', GETDATE());

INSERT INTO CourseStudent (CourseID, StudentID, EnrolledAt)
VALUES ('Course1', 'Student998', GETDATE());

INSERT INTO CourseStudent (CourseID, StudentID, EnrolledAt)
VALUES ('Course1', 'Student997', GETDATE());


-- 3. Thêm đánh giá của cả 3 học sinh cho cùng 1 khóa học
INSERT INTO CourseReview (StudentID, CourseID, Rating, ReviewTime)
VALUES ('Student999', 'Course1', 5, GETDATE());

INSERT INTO CourseReview (StudentID, CourseID, Rating, ReviewTime)
VALUES ('Student998', 'Course1', 4, GETDATE());

INSERT INTO CourseReview (StudentID, CourseID, Rating, ReviewTime)
VALUES ('Student997', 'Course1', 5, GETDATE());


select * from Student
select * from GradeLevel
select * from Course
select * from CourseStudent
select * from CourseRatingStats
select * from CourseReview
select * from Teacher order by TeachingSubjectID
select * from Subject order by SubjectID

update Teacher set Description =  N'Giáo viên Tin học' WHERE TeacherID = 'Teacher10'
