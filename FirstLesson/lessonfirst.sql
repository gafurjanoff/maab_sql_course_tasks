CREATE DATABASE firstlesson;
GO

USE firstlesson;
GO



CREATE TABLE student(

    id INT,
    name VARCHAR(100),
    age INT

)

ALTER TABLE student
ALTER COLUMN id INT NOT NULL;


CREATE TABLE product(

    product_id INT UNIQUE,
    product_name VARCHAR(100),
    price DECIMAL(10,2)

);
GO


DROP TABLE product;

CREATE TABLE product(

    product_id INT,
    product_name VARCHAR(100),
    price DECIMAL(10,2),

CONSTRAINT uq_product_id UNIQUE(product_id)

);



ALTER TABLE product 
DROP CONSTRAINT uq_product_id;


ALTER TABLE product
ADD CONSTRAINT uq_product_id UNIQUE (product_id);


ALTER TABLE product
DROP CONSTRAINT uq_product_id;

ALTER TABLE product
ADD CONSTRAINT uq_product_id_name UNIQUE (product_id, product_name);




CREATE TABLE orders(

    order_id INT NOT NULL,
    customer_name VARCHAR(100),
    order_date DATE,
    CONSTRAINT pk_orders UNIQUE (order_id)

)
GO



ALTER TABLE orders
DROP CONSTRAINT pk_orders;


ALTER TABLE orders
ADD CONSTRAINT pk_orders PRIMARY KEY (order_id)




CREATE TABLE category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);
GO





CREATE TABLE item(

    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    category_id INT,
    CONSTRAINT fk_item_category FOREIGN KEY (category_id)
    REFERENCES  category(category_id)

)
GO


ALTER TABLE item 
DROP CONSTRAINT fk_item_category;


ALTER TABLE item
ADD CONSTRAINT fr_item_category 
FOREIGN KEY (category_id) 
REFERENCES category(category_id);



CREATE TABLE account(

    account_id INT PRIMARY KEY,
    balance  DECIMAL(10,2),
    account_type VARCHAR(20),

    CONSTRAINT ck_balance CHECK(balance >= 0),
    CONSTRAINT ck_account_type CHECK(account_type in ('Saving', 'Checking'))

);
GO


ALTER TABLE account
DROP CONSTRAINT ck_balance;



ALTER TABLE account
DROP CONSTRAINT ck_account_type;



ALTER TABLE account
ADD CONSTRAINT chk_balance CHECK (balance >= 0);

ALTER TABLE account
ADD CONSTRAINT chk_account_type
CHECK (account_type IN ('Saving', 'Checking'));




CREATE TABLE customer(

    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50)
    CONSTRAINT df_city DEFAULT 'Unknown' 

);
GO


ALTER TABLE customer
DROP CONSTRAINT df_city;



ALTER TABLE customer
ADD CONSTRAINT df_city DEFAULT 'Unknown' FOR city;



CREATE TABLE invoice (

    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    amount DECIMAL(10,2),


);
GO



INSERT INTO invoice (amount) VALUES (100);
INSERT INTO invoice (amount) VALUES (200);
INSERT INTO invoice (amount) VALUES (300);
INSERT INTO invoice (amount) VALUES (400);
INSERT INTO invoice (amount) VALUES (500);


-- select * from invoice;


SET IDENTITY_INSERT invoice ON;

INSERT INTO invoice (invoice_id, amount)
VALUES (100, 999.99);


-- select * from invoice;


SET IDENTITY_INSERT invoice OFF;


IF OBJECT_ID('dbo.books', 'U') IS NULL

    CREATE TABLE books(
        book_id INT IDENTITY(1,1) PRIMARY KEY,
        title VARCHAR(100) NOT NULL,
        price DECIMAL(10,2),
        genre VARCHAR(50) CONSTRAINT df_genre DEFAULT 'Unknown',
        CONSTRAINT ck_price CHECK(price >= 0)
); 
GO



-- Library Management System.



IF OBJECT_ID('dbo.book', 'U') IS NULL
BEGIN
    CREATE TABLE book(

        book_id INT PRIMARY KEY,
        title VARCHAR(200),
        author VARCHAR(100),
        published_year INT
    );
END;
GO

IF OBJECT_ID('dbo.member', 'U') is NULL
BEGIN
    CREATE TABLE member(

        member_id INT PRIMARY KEY,
        member_name VARCHAR(100),
        email VARCHAR(100),
        phone_number VARCHAR(50)
    );
END;
GO


IF OBJECT_ID('dbo.loan', 'U') is NULL
BEGIN
    CREATE TABLE loan(
        loan_id INT PRIMARY KEY,
        book_id INT,
        member_id INT,
        loan_date DATE NOT NULL,
        return_date DATE,

        CONSTRAINT fk_loan_book 
        FOREIGN KEY (book_id) REFERENCES book(book_id) 
        ON DELETE CASCADE,
        CONSTRAINT fk_loan_member 
        FOREIGN KEY (member_id) REFERENCES member(member_id)
        ON DELETE CASCADE,
    );
END;
GO






INSERT INTO book VALUES
(1, '1984', 'George Orwell', 1949),
(2, 'Dune', 'Frank Herbert', 1965);


INSERT INTO member VALUES
(1, 'Alice', 'alice@mail.com', '123456'),
(2, 'Bob', 'bob@mail.com', '987654');



INSERT INTO loan VALUES
(1, 1, 1, '2024-01-01', NULL),
(2, 2, 2, '2024-01-05', '2024-01-20');






