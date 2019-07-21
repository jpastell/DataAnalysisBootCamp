CREATE TABLE departments (
   dept_no TEXT PRIMARY KEY,
   dept_name TEXT NOT NULL
);

CREATE TABLE employees (
    emp_no INT PRIMARY KEY,
    birth_date DATE NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT,
    gender TEXT,
    hire_date DATE
);

CREATE TABLE dept_emp (
    emp_no INT REFERENCES employees(emp_no),
    dept_no TEXT REFERENCES departments(dept_no),
    from_date DATE NOT NULL,
    to_date DATE NOT NULL
);

CREATE TABLE dept_manager (
    dept_no TEXT REFERENCES departments(dept_no),
    emp_no INT REFERENCES employees(emp_no),
    from_date DATE NOT NULL,
    to_date DATE NOT NULL
);

CREATE TABLE salaries (
    emp_no INT REFERENCES employees(emp_no),
    salary INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL
);


CREATE TABLE titles (
    emp_no INT REFERENCES employees(emp_no),
    title TEXT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL
);

SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM salaries;
SELECT * FROM titles;









