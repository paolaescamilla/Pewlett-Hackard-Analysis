-- Creating tables for PH-EmployeeDB
CREATE TABLE departments(dept_no VARCHAR(4) NOT NULL, dept_name VARCHAR(40)NOT NULL, PRIMARY KEY(dept_no), UNIQUE(dept_name));

-- Creating table for Employees
CREATE TABLE employees(emp_no INT NOT NULL, birth_date DATE NOT NULL, first_name VARCHAR NOT NULL, last_name VARCHAR NOT NULL, gender VARCHAR NOT NULL, hire_date DATE NOT NULL, PRIMARY KEY(emp_no));

-- Creating table for department manager
CREATE TABLE dept_manager(dept_no VARCHAR(4)NOT NULL, emp_no INT NOT NULL, from_date DATE NOT NULL, to_date DATE NOT NULL, FOREIGN KEY(emp_no)REFERENCES employees (emp_no),FOREIGN KEY(dept_no)REFERENCES departments(dept_no), PRIMARY KEY(emp_no, dept_no));

-- Creating table for salaries
CREATE TABLE salaries(emp_no INT NOT NULL, salary INT NOT NULL,from_date DATE NOT NULL, to_date DATE NOT NULL, FOREIGN KEY(emp_no) REFERENCES employees (emp_no),PRIMARY KEY(emp_no));

-- Creating table for department employees
CREATE TABLE dept_employees(emp_no INT NOT NULL, dept_no VARCHAR(4)NOT NULL, from_date DATE NOT NULL, to_date DATE NOT NULL, FOREIGN KEY(emp_no)REFERENCES employees(emp_no),PRIMARY KEY(emp_no, dept_no, from_date));

--Creating table for titles
CREATE TABLE titles(emp_no INT NOT NULL, title VARCHAR NOT NULL, from_date DATE NOT NULL, to_date DATE NOT NULL,FOREIGN KEY(emp_no)REFERENCES EMPLOYEES(emp_no), PRIMARY KEY(emp_no, title, from_date));

SELECT*FROM titles;

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT*FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_employees.to_date
FROM retirement_info
LEFT JOIN dept_employees
ON retirement_info.emp_no = dept_employees.emp_no;

--Abreviation of the code above
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_employees as de	
ON ri.emp_no = de.emp_no;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

--abbreviation of the code above
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

--Join retirement info and department employees
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_employees as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO employee_by_dept
FROM current_emp as ce
LEFT JOIN dept_employees as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

-- Create new table for employee info
SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--create a join between employee info and salaries
SELECT e.emp_no,e.first_name,e.last_name,e.gender, s.salary, de.to_date
INTO emp_info_salaries
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_employees as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31') AND (de.to_date = '9999-01-01');

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

-- table to consolidate department retirees
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_employees AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

--list of employees just for sales
SELECT e.emp_no, ri.first_name, ri.last_name, di.dept_name
INTO sales_info
FROM retirement_info as ri
INNER JOIN employees AS e
ON (ri.first_name = e.first_name)
INNER JOIN dept_info AS di
ON (e.emp_no = di.emp_no);

SELECT *
INTO sales_info_final
FROM sales_info
WHERE dept_name IN ('Sales')

SELECT *
INTO sales_development_employees
FROM sales_info
WHERE dept_name IN ('Sales', 'Development')

--CHALLENGE BEGINS
--DELIVERABLE 1
-- Retrieve columns from employees table
SELECT emp_no, first_name, last_name, birth_date
INTO employees_retrieved --create a new table
FROM employees

-- Retrieve columns from title table
SELECT emp_no, title, from_date, to_date
INTO titles_retrieved -- create a new table
FROM titles

--Join both tables on primary key
SELECT er.emp_no, er.first_name, er.last_name, tr.title, tr.from_date, tr.to_date
INTO retirement_titles
FROM employees_retrieved AS er
INNER JOIN titles_retrieved AS tr
ON (er.emp_no = tr.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')--filter on birth_date
ORDER BY emp_no ASC;--order by employee number

--Retrieve info from Retirement Titles table
SELECT emp_no, first_name, last_name, title
FROM retirement_titles
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, first_name DESC;

--Retrieve employees by their most recent job title
SELECT emp_no, title
FROM unique_titles
--Retrieve number ot titles from unique titles table
SELECT (title)
FROM unique_titles
--create a Retiring Titles table
SELECT 
	title, 
	COUNT (title)
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

--DELIVERABLE 2
--Retrieve columns from Employees table
SELECT emp_no, first_name, last_name, birth_date
--INTO employees_retrieved --create a new table
FROM employees

--retrieve dates from dept employee
SELECT from_date, to_date
--INTO dates --create a new table
FROM dept_employees

--retrieve title
SELECT title
--INTO title_employees --create a new table
FROM titles

--compile previous retrieves in one table
SELECT er.emp_no, er.first_name, er.last_name, d.from_date, d.to_date, te.title
--INTO mentorship_elibigility
FROM employees_retrieved AS er
INNER JOIN titles_retrieved AS tr
ON (er.emp_no = tr.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')--filter on birth_date
ORDER BY emp_no ASC;--order by employee number

SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, first_name DESC;