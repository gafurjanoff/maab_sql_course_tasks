
IF NOT EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'lessontwo'
)
BEGIN
    CREATE DATABASE lessontwo;
END
GO

-- DDL DATA DEFINITION LANGUAGE 


/* COMMON DATA TYPES */


-- INTEGER

/* 


| Type     | Size | Range (roughly)        
| -------- | ---- | ---------------------- 
| TINYINT  | 1 B  | 0 → 255                
| SMALLINT | 2 B  | −32k → 32k             
| INT      | 4 B  | −2 billion → 2 billion 
| BIGINT   | 8 B  | -2^63, 2^63-1             



*/

DROP TABLE IF EXISTS person;
CREATE TABLE person
(

    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255),
    age SMALLINT

);



INSERT INTO person (name, age)
VALUES
('Samandar', 45),
('Oybek', 45),
('Murod', 26);


SELECT * FROM person;



-- DECIMAL 

DROP TABLE IF EXISTS product;
CREATE TABLE product
(   
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255),
    price DECIMAL(10,2)

);



INSERT INTO product(name, price)
VALUES
('cherry', 23.56),
('apple', 45.56);



SELECT * FROM product;


DROP TABLE IF EXISTS people;
CREATE TABLE people
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    birth_date DATE
);

INSERT INTO people (first_name, last_name,birth_date)
VALUES
    ('Samandar', 'Gofurjonov', '2004-03-07');



SELECT * FROM people;


SELECT GETDATE();

DROP TABLE IF EXISTS data;
CREATE TABLE data
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255),
    image VARBINARY(MAX)

);


INSERT INTO data (name, image)
SELECT
    'bag',
    BulkColumn
FROM OPENROWSET(
    BULK '/data/IMG_5371.HEIC',
    SINGLE_BLOB
) AS img;

SELECT * FROM data;

SELECT @@SERVERNAME