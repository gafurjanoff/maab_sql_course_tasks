CREATE DATABASE fourthlesson;
GO

USE fourthlesson;


-- ## Task 1: 
-- If all the columns having zero value then don't show that row.

-- sql
-- CREATE TABLE [dbo].[TestMultipleZero]
-- (
--     [A] [int] NULL,
--     [B] [int] NULL,
--     [C] [int] NULL,
--     [D] [int] NULL
-- );
-- GO

-- INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
-- VALUES 
--     (0,0,0,1),
--     (0,0,1,0),
--     (0,1,0,0),
--     (1,0,0,0),
--     (0,0,0,0),
--     (1,1,1,0);




IF OBJECT_ID('dbo.testmultiplezero', 'U') IS NULL

    CREATE TABLE dbo.testmultiplezero(

        a INT,
        b INT,
        c INT,
        d INT
    );

GO

INSERT INTO dbo.testmultiplezero(A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,1);



SELECT * FROM dbo.testmultiplezero 
WHERE NOT (a = 0 OR b = 0 OR c = 0 OR d = 0 );



-- ## Task 2

-- Write a query which will find maximum value from multiple columns of the table.

-- sql
-- CREATE TABLE TestMax
-- (
--     Year1 INT
--     ,Max1 INT
--     ,Max2 INT
--     ,Max3 INT
-- );
-- GO
 
-- INSERT INTO TestMax 
-- VALUES
--     (2001,10,101,87)
--     ,(2002,103,19,88)
--     ,(2003,21,23,89)
--     ,(2004,27,28,91);




IF OBJECT_ID('dbo.testmax', 'U') IS NULL

        CREATE TABLE dbo.testmax(

            year1 INT,
            max1 INT,
            max2 INT,
            max3 INT

        );

GO


INSERT INTO TestMax 
VALUES
    (2001,10,101,87)
    ,(2002,103,19,88)
    ,(2003,21,23,89)
    ,(2004,27,28,91);


SELECT
    year1,
    CASE
        WHEN max1 >= max2 AND Max1 >= max3 THEN Max1
        WHEN max2 >= Max1 AND max2 >= max3 THEN Max2
        ELSE max3
    END AS MaxValue
FROM dbo.testmax;


-- SELECT * FROM dbo.testmax;




IF OBJECT_ID('dbo.empbirth', 'U') IS NULL

    CREATE TABLE dbo.empbirth(

        empid INT IDENTITY(1,1),
        empname VARCHAR(100),
        birthdate DATETIME
    );
GO


INSERT INTO dbo.empbirth (empname, birthdate)
VALUES
('Pawan' , '12/04/1983'),
('Zuzu' , '11/28/1986'),
('Parveen', '05/07/1977'),
('Mahesh', '01/13/1983'),
('Ramesh', '05/09/1983');


-- INSERT INTO EmpBirth(EmpName,BirthDate)
-- SELECT 'Pawan' , '12/04/1983'
-- UNION ALL
-- SELECT 'Zuzu' , '11/28/1986'
-- UNION ALL
-- SELECT 'Parveen', '05/07/1977'
-- UNION ALL
-- SELECT 'Mahesh', '01/13/1983'
-- UNION ALL
-- SELECT'Ramesh', '05/09/1983';


-- SELECT * FROM dbo.empbirth 
-- WHERE MONTH(birthdate) = 5 AND DAY(birthdate) BETWEEN 7 AND 15;


SELECT empid, empname, birthdate
FROM dbo.empbirth
WHERE
    DATEPART(month, birthdate) = 5
    AND DATEPART(day, birthdate) BETWEEN 7 AND 15;





IF OBJECT_ID('dbo.letters', 'U') IS NULL

    CREATE TABLE dbo.letters(
        letter CHAR(1)
    );
GO


INSERT INTO dbo.letters (letter)
VALUES
('a'),
 ('a'),
  ('a'),
   ('b'),
    ('c'),
     ('d'),
      ('e'),
       ('f');


SELECT * FROM dbo.letters
ORDER BY 
CASE 
    WHEN letter  = 'b' THEN 0  
    ELSE 1 
END,
letter;