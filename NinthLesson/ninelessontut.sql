
USE ninthlesson;


create table employee (
	id INT,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	gender VARCHAR(50),
	salary INT,
	dept_id INT
);



SELECT * FROM employee;



SELECT * 
FROM (SELECT TOP 2*
FROM employee 
ORDER BY salary DESC) AS T
ORDER BY salary;



SELECT * FROM employee WHERE salary = (SELECT TOP 1 salary 
FROM (SELECT DISTINCT TOP 2  salary FROM employee
ORDER BY salary DESC) AS t1 
ORDER BY salary )


SELECT TOP 1 salary 
FROM (SELECT DISTINCT TOP 2  salary FROM employee
ORDER BY salary DESC) AS t1 
ORDER BY salary



SELECT * FROM (
    SELECT *,
    DENSE_RANK() 
    OVER(PARTITION BY dept_id ORDER BY salary DESC ) AS rnk
    FROM employee
) t2
WHERE rnk = 2;



SELECT TOP 1 salary 
FROM(
    SELECT DISTINCT TOP 2 salary 
    FROM employee
    WHERE dept_id = 2
    ORDER BY salary DESC) AS mytable
ORDER BY salary ASC;



SELECT *
FROM employee e1 
WHERE salary = (
    SELECT TOP 1 salary 
FROM(
    SELECT DISTINCT TOP 2 salary 
    FROM employee e2
    WHERE e1.dept_id = e2.dept_id
    ORDER BY salary DESC) AS mytable
ORDER BY salary ASC);







