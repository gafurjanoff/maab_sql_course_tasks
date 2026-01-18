
IF NOT EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'lessonone'
)
BEGIN
    CREATE DATABASE lessonone;
END
GO


USE lessonone;
GO


IF OBJECT_ID('dbo.students', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.students (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(100),
        email NVARCHAR(100)
    );
END
GO


-- INSERT INTO dbo.students (name, email)
-- VALUES
--     ('Samandar', 'samandar@gmail.com'),
--     ('Gofurjonov', 'gofurjonov@gmail.com'),
--     ('Oybek', 'oybektulanboyev@gmail.com');
-- GO



SELECT * FROM students;

DELETE FROM students;
