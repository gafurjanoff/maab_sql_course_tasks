
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


INSERT INTO dbo.students (name, email)
VALUES
    ('Samandar', 'samandar@gmail.com'),
    ('Gofurjonov', 'gofurjonov@gmail.com'),
    ('Oybek', 'oybektulanboyev@gmail.com');
GO



SELECT * FROM students;

-- DELETE FROM students;


/* CONSTRAINTS */



IF OBJECT_ID('people', 'U') IS NULL
BEGIN
    CREATE TABLE people
    (
        id int PRIMARY KEY,
        name VARCHAR(50)

    );
END



-- INSERT INTO people (name)
-- VALUES
--     ('Samandar'),
--     ('Oybek');

INSERT INTO people (id, name)
VALUES
    (17,'Samandar'),
    (18,'Oybek');


SELECT * FROM people;

-- DELETE FROM people;


-- FOREIGN KEY CONSTRAINT

drop table department;
CREATE TABLE department
(
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

drop table employees;
CREATE TABLE employees
(
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id INT FOREIGN KEY REFERENCES department(id) 
);


INSERT INTO department (id, name)
VALUES
    (1, 'Engineering'),
    (2, 'Human Resources'),
    (3, 'Finance');



INSERT INTO employees (id, name, department_id)
VALUES
    (1, 'Alice', 1),
    (2, 'Bob', 1),
    (3, 'Carol', 2),
    (4, 'David', 3);


-- SHOW FOREIGN KEY REFERENCES TABLES

SELECT emp.id, 
       emp.name AS employee_name,
       dep.name AS department_name
       FROM employees emp JOIN department dep 
       ON emp.department_id = dep.id;


---------------------------------------------------------------------------------------------


SELECT ORIGINAL_LOGIN(), CURRENT_USER, SYSTEM_USER;