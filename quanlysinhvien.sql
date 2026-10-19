CREATE DATABASE QuanLySinhVien;
USE QuanLySinhVien;
CREATE TABLE Class(
ClassID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
ClassName VARCHAR(60) NOT NULL,
StartDate DATETIME NOT NULL,
Status BIT
);
CREATE TABLE Student(
StudentId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
StudentName VARCHAR(30) NOT NULL,
Address VARCHAR(50),
Phone VARCHAR(20),
Status BIT,
ClassId INT NOT NULL,
FOREIGN KEY (ClassId) REFERENCES Class (ClassID)
);
CREATE TABLE Subject(
SubId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
SubName VARCHAR(30) NOT NULL,
Credit TINYINT NOT NULL DEFAULT 1 CHECK ( Credit >= 1 ),
Status BIT DEFAULT 1
);
CREATE TABLE Mark(
MarkId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
SubId INT NOT NULL,
StudentId INT NOT NULL,
Mark FLOAT DEFAULT 0 CHECK ( Mark BETWEEN 0 AND 100),
ExamTimes TINYINT DEFAULT 1,
UNIQUE (SubId, StudentId),
FOREIGN KEY (SubId) REFERENCES Subject (SubId),
FOREIGN KEY (StudentId) REFERENCES Student (StudentId)
 );
 INSERT INTO Class (ClassID, ClassName, StartDate, Status)
VALUES (1, 'A1', '2008-12-20', 1);

INSERT INTO Class (ClassID, ClassName, StartDate, Status)
VALUES (2, 'A2', '2008-12-22', 1);

INSERT INTO Class (ClassID, ClassName, StartDate, Status)
VALUES (3, 'B3', CURRENT_DATE, 0);

-- Bước 3: Thêm dữ liệu vào bảng Student (không chèn StudentID nếu là cột khóa chính tự tăng - AUTO_INCREMENT)
INSERT INTO Student (StudentName, Address, Phone, Status, ClassId)
VALUES ('Hung', 'Ha Noi', '0912113113', 1, 1);

INSERT INTO Student (StudentName, Address, Status, ClassId)
VALUES ('Hoa', 'Hai phong', 1, 1);

INSERT INTO Student (StudentName, Address, Phone, Status, ClassId)
VALUES ('Manh', 'HCM', '0123123123', 0, 2);

-- Bước 4: Thêm nhiều bản ghi cùng lúc vào bảng Subject
INSERT INTO Subject (SubID, SubName, Credit, Status)
VALUES (1, 'CF', 5, 1),
       (2, 'C', 6, 1),
       (3, 'HDJ', 5, 1),
       (4, 'RDBMS', 10, 1);

-- Bước 5: Thêm dữ liệu vào bảng Mark
INSERT INTO Mark (SubId, StudentId, Mark, ExamTimes)
VALUES (1, 1, 8, 1),
       (1, 2, 10, 2),
       (2, 1, 12, 1);
SELECT *
FROM Student;
SELECT *
FROM Student
WHERE Status = true;
SELECT *
FROM Subject
WHERE Credit < 10;
SELECT S.StudentId, S.StudentName, C.ClassName
FROM Student S join Class C on S.ClassId = C.ClassID;
SELECT S.StudentId, S.StudentName, C.ClassName
FROM Student S join Class C on S.ClassId = C.ClassID
WHERE C.ClassName = 'A1';
SELECT S.StudentId, S.StudentName, Sub.SubName, M.Mark
FROM Student S join Mark M on S.StudentId = M.StudentId join Subject Sub on M.SubId = Sub.SubId;
SELECT S.StudentId, S.StudentName, Sub.SubName, M.Mark
FROM Student S join Mark M on S.StudentId = M.StudentId join Subject Sub on M.SubId = Sub.SubId
WHERE Sub.SubName = 'CF';
USE QuanLySinhVien;

-- 1. Hiển thị tất cả các sinh viên có tên bắt đầu bằng ký tự 'h' (hoặc 'H')
SELECT *
FROM Student
WHERE StudentName LIKE 'h%';

-- 2. Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12
SELECT *
FROM Class
WHERE MONTH(StartDate) = 12;

-- 3. Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3 đến 5
SELECT *
FROM Subject
WHERE Credit BETWEEN 3 AND 5;

-- 4. Thay đổi mã lớp (ClassID) của sinh viên có tên 'Hung' thành 2
UPDATE Student
SET ClassId = 2
WHERE StudentName = 'Hung';

-- 5. Hiển thị các thông tin: StudentName, SubName, Mark. Dữ liệu sắp xếp theo điểm thi (Mark) giảm dần, nếu trùng sắp xếp theo tên (StudentName) tăng dần
SELECT S.StudentName, Sub.SubName, M.Mark
FROM Student S
JOIN Mark M ON S.StudentId = M.StudentId
JOIN Subject Sub ON M.SubId = Sub.SubId
ORDER BY M.Mark DESC, S.StudentName ASC;