CREATE DATABASE finalexam;
GO

USE finalexam;
GO
-----------------------------------------------------------------------------------------------------------------------

--PUZZLE 1(Max Score: 10):
/*
Calculates the difference between the highest salaries in the marketing and engineering departments. 
Output just the absolute difference in salaries.
*/

DROP TABLE IF EXISTS db_dept
CREATE TABLE db_dept (
    id BIGINT PRIMARY KEY,
    department VARCHAR(50)
);

DROP TABLE IF EXISTS db_employee
CREATE TABLE db_employee (
    id BIGINT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary BIGINT,
    department_id BIGINT,
    FOREIGN KEY (department_id) REFERENCES db_dept(id)
);

INSERT INTO db_dept (id, department)
VALUES
(1, 'Marketing'),
(2, 'Engineering'),
(3, 'HR');

INSERT INTO db_employee (id, first_name, last_name, salary, department_id)
VALUES
(1, 'John', 'Smith', 6000, 1),
(2, 'Anna', 'Brown', 8000, 1),
(3, 'Mike', 'Wilson', 9000, 2),
(4, 'Sara', 'Taylor', 12000, 2),
(5, 'Emma', 'Davis', 5000, 3);


SELECT 

    ABS(
    MAX(CASE d.department WHEN 'Marketing' THEN e.salary END)
    -
    MAX(CASE d.department WHEN 'Engineering' THEN e.salary END)) Salary_Difference
    
FROM db_employee e
JOIN db_dept d ON e.department_id = d.id;


















-- warm-up

SELECT MAX(salary) AS max_marketing_salary
FROM db_employee
WHERE department_id = 1;

select max(salary) as max_engineering_salary
from db_employee
where department_id = 2;

-- a)

select abs (
   (select max(salary) from db_employee where department_id = 2) - 
   (select max(salary) from db_employee where department_id = 1)
) as salary_difference;

-- b)

SELECT 
    ABS(
        MAX(CASE WHEN d.department = 'Engineering' THEN e.salary END) -
        MAX(CASE WHEN d.department = 'Marketing' THEN e.salary END)
    ) AS salary_difference
FROM db_employee e
JOIN db_dept d ON e.department_id = d.id;

-- c) 

WITH max_salaries AS (
    SELECT 
        d.department,
        MAX(e.salary) AS max_salary
    FROM db_employee e
    JOIN db_dept d 
        ON e.department_id = d.id
    WHERE d.department IN ('Marketing', 'Engineering')
    GROUP BY d.department
)
SELECT 
    ABS(
        MAX(CASE WHEN department = 'Engineering' THEN max_salary END) -
        MAX(CASE WHEN department = 'Marketing' THEN max_salary END)
    ) AS salary_difference
FROM max_salaries;


--Expected Output

/*
salary_difference
-----------------
4000
*/

-----------------------------------------------------------------------------------------------------------------------

--PUZZLE 2(Max Score:15):
/*
Management wants to analyze only employees with official job titles. 
Find the job titles of the employees with the highest salary. If multiple employees have the same highest salary, 
include all their job titles.
*/

CREATE TABLE worker (
    worker_id BIGINT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary BIGINT,
    joining_date DATE
);

CREATE TABLE title (
    worker_ref_id BIGINT,
    worker_title VARCHAR(100),
    affected_from DATE,
    FOREIGN KEY (worker_ref_id) REFERENCES worker(worker_id)
);

INSERT INTO worker (worker_id, first_name, last_name, department, salary, joining_date)
VALUES
(1, 'John', 'Smith', 'Engineering', 12000, '2020-01-15'),
(2, 'Anna', 'Brown', 'Engineering', 12000, '2019-03-10'),
(3, 'Mike', 'Wilson', 'Marketing', 9000, '2021-06-01'),
(4, 'Sara', 'Taylor', 'HR', 8000, '2022-02-20'),
(5, 'Emma', 'Davis', 'Finance', 7000, '2021-09-05');


INSERT INTO title (worker_ref_id, worker_title, affected_from)
VALUES
(1, 'Senior Data Engineer', '2021-01-01'),
(2, 'Lead Software Engineer', '2020-05-01'),
(3, 'Marketing Analyst', '2021-06-01'),
(4, 'HR Specialist', '2022-02-20');


SELECT 
    
    w.worker_id AS WORKERID,
    w.first_name AS FIRSTNAME,
    w.last_name AS LASTNAME,
    w.department AS DEPARTMENT,
    w.salary AS SALARY,
    w.joining_date AS JOINEDDATE,
    t.worker_title AS JOBTITLE,
    t.affected_from AS AFFECTFROM

FROM worker w
JOIN title t
ON w.worker_id = t.worker_ref_id



;WITH Highest_Salary AS 
(
    SELECT 
        t.worker_title AS JOBTITLE,
        DENSE_RANK()
        OVER(ORDER BY salary DESC)
        AS rnk

    FROM worker w
    JOIN title t
    ON w.worker_id = t.worker_ref_id
)

SELECT JOBTITLE FROM Highest_Salary
WHERE rnk = 1;





SELECT 
    
    -- w.salary AS SALARY,
    t.worker_title AS JOBTITLE


FROM worker w
JOIN title t
ON w.worker_id = t.worker_ref_id
WHERE w.salary = (
    SELECT 
        MAX(w2.salary)
        FROM worker w2
        JOIN title t2
        ON w2.worker_id = t2.worker_ref_id
);















-- warm-up

SELECT MAX(w.salary) AS max_salary
FROM worker w
JOIN title t 
    ON w.worker_id = t.worker_ref_id;

SELECT 
    w.worker_id,
    w.salary,
    t.worker_title
FROM worker w
JOIN title t 
    ON w.worker_id = t.worker_ref_id
    WHERE w.salary = 12000;

-- a)

SELECT 
    w.worker_id,
    w.salary,
    t.worker_title
FROM worker w
JOIN title t 
    ON w.worker_id = t.worker_ref_id
WHERE w.salary = (
    SELECT MAX(w2.salary)
    FROM worker w2
    JOIN title t2 
        ON w2.worker_id = t2.worker_ref_id
);

-- b)

WITH cte AS (
    SELECT
        t.worker_title,
        w.salary,
        DENSE_RANK() OVER (ORDER BY w.salary DESC) AS salary_rank
    FROM worker w
    JOIN title t
        ON w.worker_id = t.worker_ref_id
)
SELECT worker_title
FROM cte
WHERE salary_rank = 1;

-- c)

with cte as (
    select * 
    from worker 
    where salary = (select max(salary) from worker)
) 
select worker_title
from title as t 
join cte as c 
on t.worker_ref_id=c.worker_id

/*
worker_title
------------------------
Senior Data Engineer
Lead Software Engineer
*/

--PUZZLE 3(Max Score:20):
/*Identify returning active users 

by finding users who made a repeat purchase
within 7 days or less of their previous transaction, 
excluding same-day purchases. 

Output a list of these user_id.
*/

CREATE TABLE amazon_transactions (
    id BIGINT PRIMARY KEY,
    user_id BIGINT,
    item VARCHAR(100),
    revenue BIGINT,
    created_at DATE
);
INSERT INTO amazon_transactions (id, user_id, item, revenue, created_at)
VALUES
(1, 101, 'Laptop', 1200, '2023-01-01'),
(2, 101, 'Mouse', 50, '2023-01-06'),
(3, 102, 'Phone', 800, '2023-02-10'),
(4, 102, 'Charger', 40, '2023-02-10'),
(5, 103, 'Tablet', 600, '2023-03-01'),
(6, 103, 'Cover', 30, '2023-03-11'),
(7, 104, 'TV', 1500, '2023-04-01'),
(8, 104, 'HDMI Cable', 20, '2023-04-04'),
(9, 104, 'Soundbar', 300, '2023-04-20'),
(10, 105, 'Headphones', 200, '2023-05-01');




SELECT 
    DISTINCT user_id
FROM(
    SELECT 
        user_id,
        created_at,
        LAG(created_at)
        OVER(PARTITION BY user_id ORDER BY created_at)
        AS previous_purchase_date
    FROM amazon_transactions
) t
WHERE DATEDIFF(day, previous_purchase_date, created_at) BETWEEN 1 AND 7



SELECT 
    DISTINCT user_id,
    prev_purchase_date, 
    created_at,
    DATEDIFF(day, prev_purchase_date, created_at)
    AS datediffr
FROM(
    SELECT 
        user_id,
        created_at,
        LAG(created_at)
        OVER(PARTITION BY user_id ORDER BY created_at)
        AS prev_purchase_date
    FROM amazon_transactions
) t
WHERE DATEDIFF(day, prev_purchase_date, created_at) BETWEEN 1 AND 7




SELECT *
FROM amazon_transactions t1
JOIN amazon_transactions t2 
  ON t1.user_id = t2.user_id 
  AND t1.id <> t2.id
WHERE t2.created_at > t1.created_at 
  AND t2.created_at <= DATEADD(day, 7, t1.created_at); 




SELECT DISTINCT t1.user_id
FROM amazon_transactions t1
JOIN amazon_transactions t2 
  ON t1.user_id = t2.user_id 
  AND t1.id <> t2.id
WHERE DATEDIFF(day, t1.created_at, t2.created_at) > 0 
  AND DATEDIFF(day, t1.created_at, t2.created_at) <= 7;





















-- a)

SELECT DISTINCT user_id
FROM (
    SELECT
        user_id,
        created_at,
        LAG(created_at) OVER (PARTITION BY user_id ORDER BY created_at) AS prev_purchase_date
    FROM amazon_transactions
) t
WHERE DATEDIFF(day, prev_purchase_date, created_at) BETWEEN 1 AND 7;


-- b)

select distinct t1.user_id
from amazon_transactions as t1
join amazon_transactions as t2
    on t1.user_id=t2.user_id 
    and 
    datediff(day, t1.created_at, t2.created_at) between 1 and 7;


-- EXPECTED OUTPUT
/*
user_id
-------
101
104
*/

-------------------------------------------------------------------------------------------------------------------------------
 --PUZZLE 4(Max Score:15):

/*
Identify the top 3 areas with the highest customer density.
Customer density = (total number of unique customers in the area / area size).
Your output should include the area name and its calculated customer density, and ties will be ranked the same
*/

CREATE TABLE stores (
    store_id BIGINT PRIMARY KEY,
    area_name VARCHAR(50),
    area_size BIGINT,
    store_location VARCHAR(100),
    store_open_date DATE
);

CREATE TABLE transaction_records (
    transaction_id BIGINT PRIMARY KEY,
    customer_id BIGINT,
    store_id BIGINT,
    transaction_amount BIGINT,
    transaction_date DATE
);

INSERT INTO stores (store_id, area_name, area_size, store_location, store_open_date)
VALUES
(1, 'Downtown', 1000, 'City Center', '2018-01-01'),
(2, 'Uptown', 2000, 'North City', '2019-03-10'),
(3, 'Midtown', 1500, 'Central City', '2020-06-15'),
(4, 'Suburb', 3000, 'Outskirts', '2021-08-01');


INSERT INTO transaction_records (transaction_id, customer_id, store_id, transaction_amount, transaction_date)
VALUES
(1, 101, 1, 100, '2023-01-01'),
(2, 102, 1, 200, '2023-01-02'),
(3, 103, 1, 150, '2023-01-03'),
(4, 104, 1, 120, '2023-01-04'),
(5, 105, 1, 180, '2023-01-05'),
(6, 201, 2, 200, '2023-01-01'),
(7, 202, 2, 300, '2023-01-02'),
(8, 203, 2, 250, '2023-01-03'),
(9, 204, 2, 180, '2023-01-04'),
(10, 205, 2, 220, '2023-01-05'),
(11, 206, 2, 210, '2023-01-06'),
(12, 301, 3, 300, '2023-01-01'),
(13, 302, 3, 350, '2023-01-02'),
(14, 303, 3, 320, '2023-01-03'),
(15, 304, 3, 310, '2023-01-04'),
(16, 305, 3, 330, '2023-01-05'),
(17, 401, 4, 150, '2023-01-01'),
(18, 402, 4, 180, '2023-01-02'),
(19, 403, 4, 170, '2023-01-03'),
(20, 404, 4, 160, '2023-01-04');




SELECT 
    s.area_name AS AREA_NAME,
    COUNT(DISTINCT t.customer_id)
    AS [Unique Customers],

    ROUND((COUNT(DISTINCT t.customer_id) * 1.0)/s.area_size,4) AS [Customer Density]
FROM stores s
RIGHT JOIN transaction_records t
ON s.store_id = t.store_id
GROUP BY  s.area_name, s.area_size
ORDER BY [Customer Density] DESC




SELECT 
    s.area_name AS AREA_NAME,
    COUNT(DISTINCT t.customer_id)
    AS [Unique Customers],

    ROUND((COUNT(DISTINCT t.customer_id) * 1.0)/s.area_size,4) AS [Customer Density]
FROM stores s
LEFT JOIN transaction_records t
ON s.store_id = t.store_id
GROUP BY  s.area_name, s.area_size
ORDER BY [Customer Density] DESC



SELECT 
    s.area_name AS AREA_NAME,
    COUNT(DISTINCT t.customer_id)
    AS [Unique Customers],

    ROUND((COUNT(DISTINCT t.customer_id) * 1.0)/s.area_size,4) AS [Customer Density]
FROM stores s
INNER JOIN transaction_records t
ON s.store_id = t.store_id
GROUP BY  s.area_name, s.area_size
ORDER BY [Customer Density] DESC






WITH AreaMetrics AS (
    SELECT 
        s.area_name,
        (COUNT(DISTINCT t.customer_id) * 1.0 / s.area_size) AS customer_density
    FROM stores s
    JOIN transaction_records t ON s.store_id = t.store_id
    GROUP BY s.area_name, s.area_size
),
RankedDensity AS (
    SELECT 
        area_name,
        customer_density,
        DENSE_RANK() OVER (ORDER BY customer_density DESC) as rnk
    FROM AreaMetrics
)
SELECT 
    area_name,
    customer_density
FROM RankedDensity
WHERE rnk <= 3;










-- a) 


SELECT TOP 3
    s.area_name AS Area,
    COUNT(DISTINCT t.customer_id) AS [Unique Customers],
    s.area_size AS [Area Size],
    ROUND(COUNT(DISTINCT t.customer_id) * 1.0 / s.area_size, 4) AS Density
FROM stores s
LEFT JOIN transaction_records t
    ON s.store_id = t.store_id
GROUP BY s.area_name, s.area_size
ORDER BY Density DESC;

-- b)

with uniq as (
    select store_id,
    count(distinct customer_id) as UniqueGuys
    from transaction_records
    group by store_id
)
select top 3 area_name,
UniqueGuys, 
area_size, 
(cast(UniqueGuys as decimal)/area_size) as density
from stores as s
join uniq as u 
on s.store_id=u.store_id
order by density desc




-------------------------------------------------------------------------------------------------------------------------------
 --PUZZLE 5(Max Score:25):
/*
Provided a table with user id and the dates they visited the platform, find the top 3 users with the longest continuous streak of visiting the platform as of August 10, 2022. 
Output the user ID and the length of the streak.
In case of a tie, display all users with the top three longest streaks.
*/

CREATE TABLE user_streaks (
    user_id VARCHAR(50),
    date_visited DATE
);

INSERT INTO user_streaks (user_id, date_visited)
VALUES
('A', '2022-08-05'),
('A', '2022-08-06'),
('A', '2022-08-07'),
('A', '2022-08-08'),
('A', '2022-08-09'),
('A', '2022-08-10'),
('B', '2022-08-06'),
('B', '2022-08-07'),
('B', '2022-08-08'),
('B', '2022-08-09'),
('B', '2022-08-10'),
('C', '2022-08-05'),
('C', '2022-08-06'),
('C', '2022-08-07'),
('C', '2022-08-08'),
('C', '2022-08-09'),
('C', '2022-08-10'),
('D', '2022-08-07'),
('D', '2022-08-08'),
('D', '2022-08-09'),
('D', '2022-08-10'),
('E', '2022-08-01'),
('E', '2022-08-03'),
('E', '2022-08-10');







;WITH numbered AS (
    SELECT
        user_id,
        date_visited,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY date_visited) AS rn
    FROM user_streaks
    WHERE date_visited <= '2022-08-10'
),

grouped AS (
    SELECT
        user_id,
        date_visited,
        DATEADD(day, -rn, date_visited) AS grp
    FROM numbered
),

streaks AS (
    SELECT
        user_id,
        MIN(date_visited) AS start_date,
        MAX(date_visited) AS end_date,
        COUNT(*) AS streak_length
    FROM grouped
    GROUP BY user_id, grp
    HAVING MAX(date_visited) = '2022-08-10'
),

ranked AS (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY streak_length DESC) AS rnk
    FROM streaks
)

SELECT user_id, streak_length
FROM ranked
WHERE rnk <= 3
ORDER BY streak_length DESC;
















-- a)

WITH StreakGroups AS (
    SELECT 
        user_id,
        date_visited,
        DATEADD(day, -ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY date_visited), date_visited) AS group_id
    FROM user_streaks
    WHERE date_visited <= '2022-08-10'
),
StreakCounts AS (
    SELECT 
        user_id,
        COUNT(*) AS streak_length
    FROM StreakGroups
    GROUP BY user_id, group_id
    HAVING MAX(date_visited) = '2022-08-10'
)
-- Use TOP 3 to limit the final output to exactly 3 rows
SELECT TOP 3
    user_id, 
    streak_length
FROM StreakCounts
ORDER BY streak_length DESC, user_id ASC;

-- b)

WITH StreakGroups AS (
    SELECT 
        user_id,
        date_visited,
        -- Generate anchor dates to identify consecutive sequences
        DATEADD(day, -ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY date_visited), date_visited) AS group_id
    FROM user_streaks
    WHERE date_visited <= '2022-08-10'
),
StreakCounts AS (
    SELECT 
        user_id,
        COUNT(*) AS streak_length
    FROM StreakGroups
    GROUP BY user_id, group_id
    -- Only include the streak that is active on the target date
    HAVING MAX(date_visited) = '2022-08-10'
),
FinalRanking AS (
    SELECT 
        user_id,
        streak_length,
        -- ROW_NUMBER guarantees a unique rank for every row
        ROW_NUMBER() OVER (ORDER BY streak_length DESC, user_id ASC) as row_num
    FROM StreakCounts
)
SELECT 
    user_id,
    streak_length
FROM FinalRanking
WHERE row_num <= 3
ORDER BY row_num;

-- c)

with streaks as (
    select *, case 
    when day(date_visited)=lag(day(date_visited)) over(partition by user_id order by date_visited)+1 
    or ROW_NUMBER() over(partition by user_id order by date_visited)=1
    then 1 
    else 0
    end as streak
    from user_streaks
    where date_visited<='2022-08-10'
),
streaksSum as ( 
    select distinct USER_ID, sum(streak) over(partition by user_id) as Lenght
    from streaks
) 
select * 
from streaksSum
where Lenght in (select top 3 Lenght from streaksSum order by Lenght desc)
order by Lenght desc

-- d) Ties included version

WITH StreakGroups AS (
    SELECT 
        user_id,
        date_visited,
        -- Correct way to subtract days in SQL Server:
        DATEADD(day, -ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY date_visited), date_visited) AS group_id
    FROM user_streaks
    WHERE date_visited <= '2022-08-10'
),
StreakCounts AS (
    SELECT 
        user_id,
        COUNT(*) AS streak_length
    FROM StreakGroups
    GROUP BY user_id, group_id
    HAVING MAX(date_visited) = '2022-08-10'
),
RankedStreaks AS (
    SELECT 
        user_id,
        streak_length,
        DENSE_RANK() OVER (ORDER BY streak_length DESC) as rnk
    FROM StreakCounts
)
SELECT 
    user_id, 
    streak_length
FROM RankedStreaks
WHERE rnk <= 3
ORDER BY streak_length DESC, user_id;


