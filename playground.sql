CREATE DATABASE playgroundb;
GO

USE playgroundb;



CREATE TABLE employees
(
    id INT, 
    name VARCHAR(50)
);
GO


INSERT INTO employees
VALUES
(1, 'Samandar'),
(2, 'Jahon'),
(3, 'Murod'),
(4, 'Gulom'),
(5, 'Oybek'),
(NULL, NULL);
GO


SELECT * FROM employees;
SELECT 1 AS EXTS FROM employees;


CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50)
);


-- Entity Integrity

-- 1. This works (Identity created)
INSERT INTO Students (StudentID, Name) VALUES (1, 'Mario');

-- 2. Error! Violates Uniqueness (Primary Key already exists)
INSERT INTO Students (StudentID, Name) VALUES (1, 'Luigi');

-- 3. Error! Violates Non-Null (Primary Key cannot be NULL)
INSERT INTO Students (StudentID, Name) VALUES (NULL, 'Peach');



-- ------ ======== Referential Integrity ========


-- The 'Parent' Table
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);
GO

DROP TABLE IF EXISTS Styudents;
-- The 'Child' Table
CREATE TABLE Styudents (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    DeptID INT,
    -- This line enforces Referential Integrity
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);
GO





-- ERROR: This will fail because DeptID 99 does not exist yet!
INSERT INTO Styudents (StudentID, Name, DeptID) VALUES (1, 'Mario', 99);


INSERT INTO Departments(DeptID, DeptName)
VALUES
(99, 'Computer Science');
GO

SELECT 
    s.StudentID, 
    s.Name, 
    d.DeptName
FROM Styudents s
INNER JOIN Departments d
ON d.DeptID = s.DeptID;


CREATE TABLE Users (IsActive BIT);
INSERT INTO Users VALUES (1); -- True



SELECT NEWID() AS GUID; 


--  ==== DATEADD(datepart, number, date)$$



SELECT DATEADD(day, 10, '2023-01-01'); 

SELECT DATEADD(day, 10, '2026-01-01');
-- Result: 2026-01-11


SELECT DATEADD(month, -3, '2026-02-21');
-- Result: 2025-11-21

SELECT DATEADD(yyyy, -3, '2026-02-21');
-- Result: 2025-11-21

SELECT DATEADD(week, 2, GETDATE()) AS DueDate;


--- DATEDIFF(datepart, startdate, enddate)


SELECT DATEDIFF(day, GETDATE(), '2026-06-06')


SELECT EOMONTH(GETDATE(), 0)


SELECT DATEDIFF(year, '2022-09-01', '2026-02-21') AS YearsEnrolled;
-- Result: 4 
-- (It counts how many "Year" boundaries were crossed)

SELECT DATEDIFF(day, '2026-02-10', GETDATE()) AS DaysOverdue;
-- Result: 11

SELECT EOMONTH('2026-02-01'); 
-- Result: 2026-02-28


CREATE TABLE Exams (
    ExamID INT PRIMARY KEY,
    ExamName VARCHAR(50),
    ExamDate DATE
);

INSERT INTO Exams VALUES (1, 'Database Systems', '2026-02-10');
INSERT INTO Exams VALUES (2, 'Calculus II', '2026-06-15');


SELECT 
    ExamName, 
    ExamDate,
    DATEADD(day, 14, ExamDate) AS ResultsDate,
    DATEADD(month, 3, ExamDate) AS RetakeDate
FROM Exams;

SELECT 
    ExamName,
    DATEDIFF(day, ExamDate, GETDATE()) AS DaysSinceExam,
    DATEDIFF(day, GETDATE(), ExamDate) AS DaysUntilExam
FROM Exams;


SELECT 
    ExamName, 
    ExamDate,
    EOMONTH(ExamDate) AS EndOfExamMonth
FROM Exams;

-- Create a practice table for our university examples
CREATE TABLE StudentScores (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50),
    Score INT,
    LastExamDate DATE,
    DepartmentID INT
);

INSERT INTO StudentScores VALUES 
(1, 'Mario', 95, '2026-02-01', 10),
(2, 'Luigi', 95, '2026-02-05', 10),
(3, 'Peach', 85, '2026-01-20', 20),
(4, 'Yoshi', NULL, '2026-02-15', 20);


SELECT StudentName, Score,
    RANK() OVER (ORDER BY Score DESC) AS RankWithGaps, -- 1, 1, 3
    DENSE_RANK() OVER (ORDER BY Score DESC) AS DenseRank -- 1, 1, 2
FROM StudentScores;

SELECT COUNT(*) AS AllRows,        -- Returns 4
       COUNT(Score) AS ValidScores -- Returns 3 (ignores Yoshi's NULL score)
FROM StudentScores;


-- See the score of the person ranked immediately below you
SELECT StudentName, Score,
    LEAD(Score) OVER (ORDER BY Score DESC) AS NextLowerScore
FROM StudentScores;

-- Replace Yoshi's NULL score with a 0
SELECT StudentName, ISNULL(Score, 0) AS FinalScore 
FROM StudentScores;

-- Shows all students and all departments, even those with no matches
SELECT S.StudentName, D.DeptName
FROM StudentScores S
FULL OUTER JOIN Departments D ON S.DepartmentID = D.DeptID;


-- Used at the very end of a recursive query
WITH Numbers AS (
    SELECT 1 as n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 200
)
SELECT n FROM Numbers
OPTION (MAXRECURSION 200); -- Limits how deep the loop can go



WITH Numbers AS (
    SELECT 1 as n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 150 -- You want 150 rows
)
SELECT n FROM Numbers;
-- This will FAIL with an error!
-- Why? Because the default limit is 100.



WITH Numbers AS (
    SELECT 1 as n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 150 -- You want 150 rows
)
SELECT n FROM Numbers
OPTION(MAXRECURSION 160);


UPDATE Students SET Name = 'Mario' WHERE StudentID = 1;


-- UNION VS UNION ALL

-- Returns 1, 2 (removes the duplicate)
SELECT 1 UNION SELECT 1 UNION SELECT 2; 

-- Returns 1, 1, 2 (keeps everything)
SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 2;

TRUNCATE TABLE Styudents;

DELETE FROM Styudents



-- Adding valid departments first
INSERT INTO Departments (DeptID, DeptName) 
VALUES (10, 'Computer Science'),
       (20, 'Data Analysis'),
       (30, 'Physics');

-- These will succeed because DeptIDs 10 and 20 exist
INSERT INTO Styudents (StudentID, Name, DeptID) 
VALUES (1, 'Mario', 10),
       (2, 'Luigi', 10),
       (3, 'Peach', 20);

SELECT DeptID, COUNT(*) 
FROM Styudents 
GROUP BY DeptID 
HAVING COUNT(*) >= 2;

SELECT * FROM Styudents;

SELECT CEILING(4.2); -- Result: 5
SELECT FLOOR(4.2);   -- Result: 4



-- Converts a number to text so it can be combined with a string
SELECT 'The price is ' + CAST(100 AS VARCHAR);



CREATE TABLE ##GlobalData (ID INT); -- Anyone on the server can see this.


SELECT RIGHT('abcdef', 3)