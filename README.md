# Employee Database: A Mystery in Two Parts (SQL)

## Background

For this challenge, you will work on the employee database at Pewlett Hackard Corporation from the 1980s and 1990s. All that remains of the database of employees from that period is in six CSV files.
You will design the tables to hold data in the CSVs, import the CSVs into a SQL database, and answer questions about the data. In other words, you will perform:

* Data Engineering

* Data Analysis

## 1. Data Modeling

Inspect the CSVs and sketch out an ERD of the tables. The entities are employees, departments, salaries, titles, department_managers, and department_employees.

The ER diagram looks as follows: 

![](https://github.com/poonam-ux/SQL-Challenge_Employee_db_Data_Engineering/blob/main/EmployeeSQL/Images/ERD_original_size.png)

## 2. Data Engineering

Use the information you have to create a table schema for each of the six CSV files. Remember to specify data types, primary keys, foreign keys, and other constraints. Import each CSV file into the corresponding SQL table. Note: be sure to import the data in the same order that the tables were created and account for the headers when importing.

## 3. Data Analysis

After importing all the CSVs, analyze the data-

1. list the following details of each employee: employee number, last name, first name, sex, and salary

```
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
JOIN salaries
ON employees.emp_no = salaries.emp_no;
```
   
2. list first name, last name, and hire date for employees who were hired in 1986.

```
SELECT first_name, last_name, hire_date 
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1987-01-01';
```
 
3. list the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name. employee number, last name, first name.
```
SELECT departments.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM departments
JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no
JOIN employees
ON dept_manager.emp_no = employees.emp_no;
```

4. list the department of each employee with the following information: employee number, last name, first name, and department name.
```
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no;
```

5. list first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."

```
SELECT first_name, last_name,sex
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';
```

6. list all employees in the Sales department, including their employee number, last name, first name, and department name.

```
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';
```

7. list all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

```
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales' 
OR departments.dept_name = 'Development'
```
8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

```
SELECT last_name,
COUNT(last_name) AS "frequency"
FROM employees
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC;
```
## 4. Data Testing and Visualization using Python

```
!pip install sqlalchemy
!pip install psycopg2
```
```
# Import modules (dependencies)
from sqlalchemy import create_engine
from config import username, password
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
```
```
# Create engine and connection to employee db.
engine = create_engine(f"postgresql://{username}:{password}@localhost:5432/employee_db")
connection = engine.connect()
```
```
# Get employee salaries from the salaries file 
employee_salary_df = pd.read_sql("select * from salaries", connection)
# Diplaye the head
employee_salary_df.head()
```
![](https://github.com/poonam-ux/SQL-Challenge_Employee_db_Data_Engineering/blob/main/EmployeeSQL/Images/employee_salaries_dataframe.png)
```
# Plot the histogram
plt.figure(figsize=(12, 8))
plt.hist(employee_salary_df["salary"], color='#0172D8', bins=15)
plt.ylabel(f'Number of employees',fontsize=15)
plt.xlabel('Salary ($)',fontsize=15)
plt.title("Frequency Distribution of salary ranges for employees",fontsize=20)
plt.grid()
plt.savefig("./Images/employee_salary_distribution.png", bbox_inches='tight')
plt.show()
```
![](https://github.com/poonam-ux/SQL-Challenge_Employee_db_Data_Engineering/blob/main/EmployeeSQL/Images/employee_salary_distribution.png)
```
# Query All Records in the Titles Table
titles_df = pd.read_sql("SELECT * FROM titles", connection)
titles_df.head()
```
```
# Query to test and get the head records from employees table
employee_df = pd.read_sql("select * from employees", connection)
# Diplaye the head
employee_df.head()
```
```
employees_db = employee_df.rename(columns={"emp_title_id":"title_id"})
employees_db.head()
```
```
# Merge employee and titles dataframes
combined_data = pd.merge(employees_db, titles_df, on="title_id", how="inner")
combined_data.head()
```
```
merged_data= pd.merge(combined_data, employee_salary_df, on="emp_no", how="inner")
merged_data.head()
```
```
# Select salary column
salary_df=merged_data[['title','salary']]
salary_df.head()
```
```
# Group average salary by job title.
average_salary_by_title = salary_df.groupby(['title']).mean()
average_salary_by_title
```
```
# Reset Index
avg_salary_df = average_salary_by_title.reset_index()
avg_salary_df
```
```
# Plot the data
# Set x_axis, y_axis & Tick Locations
fig1, ax1 = plt.subplots(figsize=(15, 10))
x_axis = avg_salary_df["title"]
ticks = np.arange(len(x_axis))
y_axis = avg_salary_df["salary"]

# Create Bar Chart Based on Above Data
plt.bar(x_axis, y_axis, align="center",alpha=0.7, color=["black", "yellow", "skyblue", "teal", "blue", "brown", "purple"])
# Create Ticks for Bar Chart's x_axis
plt.xticks(ticks, x_axis, rotation="vertical")
plt.xlabel("Employee Titles",fontsize=15)
plt.ylabel("Salaries ($)",fontsize=15)
plt.title("Average Employee Salary by Title",fontsize=20)
# Save Figure
plt.savefig("./Images/average_salary_by_title.png", bbox_inches='tight')

# Show plot
plt.show()
```
![](https://github.com/poonam-ux/SQL-Challenge_Employee_db_Data_Engineering/blob/main/EmployeeSQL/Images/average_salary_by_title.png)
