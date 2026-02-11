
CREATE DATABASE lessonseventhtut;



USE lessonseventhtut;



IF OBJECT_ID('dbo.people', 'U') IS NOT NULL

    DROP TABLE dbo.people;

GO


CREATE TABLE dbo.people(

    ID INT,
    NAME VARCHAR(50),
    GENDER CHAR(1),
);
GO



INSERT INTO dbo.people (ID, NAME, GENDER)
VALUES
    (1, 'Alice', 'M'),
    (2, 'Bob',   'M'),
    (3, 'Carol', 'M'),
    (4, 'David', 'M'),
    (5, 'Eve',   'F'),
    (6, 'Frank', 'M'),
    (7, 'Grace', 'M'),
    (8, 'Heidi', 'F'),
    (9, 'Ivan',  'F'),
    (10, 'Judy', 'F');


SELECT * FROM dbo.people;


SELECT *,

    ROW_NUMBER() OVER(PARTITION BY GENDER ORDER BY ID)
    AS rn

FROM dbo.people;


SELECT *,

    ROW_NUMBER() OVER(PARTITION BY GENDER ORDER BY ID)
    AS rn

FROM dbo.people
ORDER BY rn;



SELECT *
FROM dbo.people
ORDER BY 
ROW_NUMBER()
OVER(PARTITION BY GENDER ORDER BY ID), GENDER DESC;


SELECT *
FROM dbo.people
ORDER BY 
ROW_NUMBER()
OVER(PARTITION BY GENDER ORDER BY ID), GENDER ASC;