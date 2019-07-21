--	1.-	List the following details of each employee: employee number,
--		last name, first name, gender, and salary

-- [Option] 1
SELECT 
	employees.emp_no,
	employees.last_name,
	employees.first_name,
	employees.gender,
	salaries.salary
FROM employees,salaries
WHERE  employees.emp_no = salaries.emp_no;

-- [Option] 2
SELECT 
	employees.emp_no,
	employees.last_name,
	employees.first_name,
	employees.gender,
	salary_data.salary
FROM employees
JOIN salaries AS salary_data
  ON employees.emp_no = salary_data.emp_no;

--	2.-	List employees who were hired in 1986.
SELECT 
	employees.emp_no,
	employees.last_name,
	employees.first_name,
	employees.hire_date
FROM employees
WHERE date_part('year', employees.hire_date) = 1986;

--	3.-	List the manager of each department with the following information:
--		department number[*], department name[*], the manager's employee number[*],
--		last name[*], first name[*], and start[*] and end[*] employment dates.
SELECT
	dept_manager.dept_no,
	departments.dept_name,
	dept_manager.emp_no,
	employees.last_name,
	employees.first_name,
	dept_manager.from_date,
	dept_manager.to_date
FROM departments, dept_manager, employees
WHERE departments.dept_no = dept_manager.dept_no AND
employees.emp_no = dept_manager.emp_no;

--	4.-	List the department of each employee with the following information:
--		employee number, last name, first name, and department name.
SELECT
	dept_emp.emp_no,
	employees.last_name,
	employees.first_name,
	departments.dept_name
FROM dept_emp, employees, departments
WHERE dept_emp.emp_no = employees.emp_no AND
dept_emp.dept_no = departments.dept_no
ORDER BY emp_no;


--Just to test--
SELECT 
	dept_emp.emp_no,
	employees_data.last_name,
	employees_data.first_name
FROM dept_emp
JOIN employees AS employees_data
  ON dept_emp.emp_no = employees_data.emp_no
ORDER BY emp_no;

--	5.-	List all employees whose first name is "Hercules" and last names begin with "B."

-- Few columns
SELECT first_name,last_name
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

-- All columns
SELECT *
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

-- 6.-	List all employees in the Sales department, including their employee number,
--		last name, first name, and department name.
SELECT
	dept_emp.emp_no,
	employees.last_name,
	employees.first_name,
	departments.dept_name
FROM dept_emp, employees, departments
WHERE dept_emp.emp_no = employees.emp_no AND
dept_emp.dept_no = departments.dept_no AND
departments.dept_name = 'Sales'
ORDER BY emp_no;

--	7.-	List all employees in the Sales and Development departments, 
--		including their employee number, last name, first name, and department name.

SELECT
	dept_emp.emp_no,
	employees.last_name,
	employees.first_name,
	departments.dept_name
FROM dept_emp, employees, departments
WHERE dept_emp.emp_no = employees.emp_no AND
dept_emp.dept_no = departments.dept_no AND
(departments.dept_name = 'Sales' OR departments.dept_name = 'Development')
ORDER BY emp_no; 

--	8.-	In descending order, list the frequency count of employee last names, i.e.,
--		how many employees share each last name.

SELECT last_name, count(last_name)
FROM employees
GROUP BY last_name;



