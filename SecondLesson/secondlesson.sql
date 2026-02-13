CREATE DATABASE lessontwo;
GO

-- USE lessontwo;



IF OBJECT_ID('dbo.test_identity', 'U') IS NOT NULL
    DROP TABLE test_identity;

GO


CREATE TABLE test_identity(

    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50)
);
GO


INSERT INTO dbo.test_identity (name) VALUES
('A'), ('B'), ('C'), ('D'), ('E');
GO


SELECT * FROM dbo.test_identity;


DELETE FROM dbo.test_identity;
GO


SELECT * FROM dbo.test_identity;


INSERT INTO dbo.test_identity (name) VALUES ('F');
GO


SELECT * FROM dbo.test_identity;


-- The new row will have:

-- id = 6



-- What happens to IDENTITY with DELETE?

-- Rows are removed

-- Identity counter does NOT reset

-- SQL Server remembers the last value

-- DELETE affects data only, not metadata.




TRUNCATE TABLE dbo.test_identity;
GO


SELECT * FROM dbo.test_identity;


INSERT INTO dbo.test_identity (name) VALUES ('F');
GO

SELECT * FROM dbo.test_identity;


-- Now WE will see:

-- id = 1

-- Answer 

-- What happens to IDENTITY with TRUNCATE?

-- All rows removed

-- Identity counter resets

-- Faster than DELETE

-- Cannot be used if:

-- Table has foreign keys

-- You want row-by-row logging

-- TRUNCATE affects data and identity metadata.



-- DROP TABLE dbo.test_identity;
-- GO


SELECT * FROM dbo.test_identity;


-- What happens when you DROP a table?

-- Data is gone 

-- Structure is gone 

-- Constraints, indexes, identity, everything is gone 

-- The table no longer exists

-- DROP affects the object itself.



IF OBJECT_ID('dbo.data_types_demo', 'U') IS NOT NULL
    DROP TABLE dbo.data_types_demo;
GO


CREATE TABLE dbo.data_types_demo (
    demo_id INT IDENTITY(1,1) PRIMARY KEY,     

    age INT,                                  
    salary DECIMAL(10,2),                 

    full_name VARCHAR(100),                  
    description NVARCHAR(200),                

    birth_date DATE,                       
    login_time TIME,                          
    created_at DATETIME,                       
    
    is_active BIT,                          

    profile_picture VARBINARY(50),             

    unique_code UNIQUEIDENTIFIER              
);
GO


INSERT INTO dbo.data_types_demo (
    age,
    salary,
    full_name,
    description,
    birth_date,
    login_time,
    created_at,
    is_active,
    profile_picture,
    unique_code
)
VALUES (
    22,
    45678.90,
    'Alice Johnson',
    N'Student from international program',
    '2002-05-14',
    '09:30:00',
    GETDATE(),
    1,
    0x1234ABCD,
    NEWID()
);
GO


SELECT * FROM dbo.data_types_demo;
GO




DECLARE @name NVARCHAR(20) = N'你好';
SELECT @name;


IF OBJECT_ID('dbo.photos', 'U') IS NOT NULL
    DROP TABLE dbo.photos;

GO


CREATE TABLE photos(

    photo_id INT IDENTITY(1,1) PRIMARY KEY,
    image_data VARBINARY(MAX)
);

GO




INSERT INTO dbo.photos (image_data)
SELECT *
FROM OPENROWSET(
    BULK '/data/myphoto.jpg',
    SINGLE_BLOB
) AS img;

GO

SELECT @@VERSION

SELECT * FROM photos;


IF OBJECT_ID('dbo.student', 'U') is NOT NULL

    DROP TABLE dbo.student;
GO


CREATE TABLE dbo.student(

    student_id INT IDENTITY(1,1) PRIMARY KEY,
    student_name VARCHAR(100),
    classes INT,
    tuition_per_class DECIMAL(10,2),
    total_tuition AS (classes * tuition_per_class)
);

GO

INSERT INTO dbo.student (student_name, classes, tuition_per_class)
VALUES
('Alice', 3, 500.00),
('Bob', 5, 450.00),
('Charlie', 4, 600.00);
GO

SELECT * FROM student;




IF OBJECT_ID('dbo.worker', 'U') IS NOT NULL
    DROP TABLE dbo.worker;
GO

CREATE TABLE dbo.worker (
    id INT,
    name VARCHAR(100)
);
GO

BULK INSERT  dbo.worker 
FROM '/data/workers.csv'
WITH (
    FIRST_ROW = 2,
    FIELDTERMINATOR = ',',
     ROWTERMINATOR = '\n'
);

SELECT * FROM dbo.worker;







