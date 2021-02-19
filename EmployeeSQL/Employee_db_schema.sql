-- Drop Tables if Existing
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS titles;
DROP TABLE IF EXISTS salaries;

-- Create tables- specify data types, primary keys and foreign keys 
CREATE TABLE employees (
    -- emp_no is a primary key,
    -- also found in dept_manager, dept_emp, and salaries
    emp_no INT   NOT NULL,
    -- each employee has a title id
    emp_title_id VARCHAR(5)   NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR(14)   NOT NULL,
    last_name VARCHAR(16)   NOT NULL,
    sex VARCHAR(1)   NOT NULL,
    hire_date DATE   NOT NULL,
    PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE departments (
    -- dept_no is a primary key,
    -- also found in dept_manager and dept_emp
    dept_no VARCHAR(4)   NOT NULL,
    dept_name VARCHAR(40)   NOT NULL,
    PRIMARY KEY (
        dept_no
     )
);

CREATE TABLE dept_manager (
    -- dept_no from departments is a primary as well as
    -- foreign key for dept_manager
    dept_no VARCHAR(4)   NOT NULL,
    emp_no INT   NOT NULL,
	-- emp_no from employees is a foreign Key for dept_manager
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    PRIMARY KEY (
        dept_no,emp_no
     )
);

CREATE TABLE dept_emp (
    -- emp_no from employees is a primary as well as
    -- Foreign Key for dept_emp
    emp_no INT   NOT NULL,
    -- dept_no from departments is a primary as well as
    -- foreign key for dept_emp
    dept_no VARCHAR(4)   NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    PRIMARY KEY (
        emp_no,dept_no
     )
);

CREATE TABLE titles (
    -- title_id is a primary key,
    -- also found in employees as emp_title_id
    title_id VARCHAR(5)   NOT NULL,
    title VARCHAR(50)   NOT NULL,
    PRIMARY KEY (
        title_id
     )
);

CREATE TABLE salaries (
    -- emp_no from employees is a primary key
    emp_no INT   NOT NULL,
    salary INT   NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    PRIMARY KEY (
        emp_no
     )
);
