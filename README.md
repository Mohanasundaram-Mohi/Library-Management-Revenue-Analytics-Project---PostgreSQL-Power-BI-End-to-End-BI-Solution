# 📚 Library Management & Revenue Analytics Project

### PostgreSQL + Power BI End-to-End BI Solution

---

# 📌 Project Overview

This project demonstrates an end-to-end Business Intelligence solution using:

* PostgreSQL (Database Design & SQL Analysis)
* Power BI (Data Modeling & Dashboarding)
* DAX (Analytical Calculations)

The system manages book inventory, members, employees, book issues, returns, and revenue tracking.

---

# 🗄 1️⃣ Database Creation

```sql
CREATE DATABASE library_project;

\c library_project;
```

---

# 🏗 2️⃣ Table Creation (Normalized Relational Model)

```sql
CREATE TABLE branch (
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(100),
    contact_no VARCHAR(15)
);

CREATE TABLE employees (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(50),
    position VARCHAR(30),
    salary DECIMAL(10,2),
    branch_id VARCHAR(10),
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

CREATE TABLE members (
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(50),
    member_address VARCHAR(100),
    reg_date DATE
);

CREATE TABLE books (
    isbn VARCHAR(50) PRIMARY KEY,
    book_title VARCHAR(100),
    category VARCHAR(30),
    rental_price DECIMAL(10,2),
    status VARCHAR(10),
    author VARCHAR(50),
    publisher VARCHAR(50)
);

CREATE TABLE issues_status (
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(10),
    issued_date DATE,
    issued_book_isbn VARCHAR(50),
    issued_emp_id VARCHAR(10),
    FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
    FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn),
    FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE return_status (
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(10),
    return_date DATE,
    FOREIGN KEY (issued_id) REFERENCES issues_status(issued_id)
);
```

---

# 🔄 3️⃣ CRUD Operations

## Create – Insert New Book

```sql
INSERT INTO books
VALUES('978-1-60129-456-2',
       'To Kill a Mockingbird',
       'Classic',
       6.00,
       'yes',
       'Harper Lee',
       'J.B. Lippincott & Co.');
```

## Update – Modify Member Address

```sql
UPDATE members
SET member_address = '125 Oak Street'
WHERE member_id = 'C103';
```

## Delete – Remove Issued Record

```sql
DELETE FROM issues_status
WHERE issued_id = 'IS121';
```

---

# 📊 4️⃣ Business Analysis Queries

## Books by Category

```sql
SELECT * 
FROM books
WHERE category = 'Classic';
```

## Total Rental Revenue by Category

```sql
SELECT 
    b.category,
    COUNT(ist.issued_id) AS total_issues,
    SUM(b.rental_price) AS total_revenue
FROM issues_status ist
JOIN books b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.category;
```

## Members Registered in Last 180 Days

```sql
SELECT *
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```

## Employees with Branch Details

```sql
SELECT 
    e.emp_name,
    e.position,
    e.salary,
    b.branch_address
FROM employees e
JOIN branch b
ON e.branch_id = b.branch_id;
```

---

# 🏗 5️⃣ CTAS (Create Table As Select)

## Book Issue Count Summary

```sql
CREATE TABLE book_issued_cnt AS
SELECT 
    b.isbn,
    b.book_title,
    COUNT(ist.issued_id) AS issue_count
FROM issues_status ist
JOIN books b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;
```

## Expensive Books Table

```sql
CREATE TABLE expensive_books AS
SELECT *
FROM books
WHERE rental_price > 7.00;
```

---

# ⚙ 6️⃣ Stored Procedures

## Issue Book Procedure

```sql
CREATE OR REPLACE PROCEDURE issue_book(
    p_issued_id VARCHAR(10),
    p_member_id VARCHAR(10),
    p_book_isbn VARCHAR(50),
    p_emp_id VARCHAR(10)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_status VARCHAR(10);
BEGIN
    SELECT status INTO v_status
    FROM books
    WHERE isbn = p_book_isbn;

    IF v_status = 'yes' THEN
        INSERT INTO issues_status
        VALUES(p_issued_id,p_member_id,CURRENT_DATE,p_book_isbn,p_emp_id);

        UPDATE books
        SET status = 'no'
        WHERE isbn = p_book_isbn;
    ELSE
        RAISE NOTICE 'Book Not Available';
    END IF;
END;
$$;
```

## Return Book Procedure

```sql
CREATE OR REPLACE PROCEDURE return_book(
    p_return_id VARCHAR(10),
    p_issued_id VARCHAR(10)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_isbn VARCHAR(50);
BEGIN
    INSERT INTO return_status
    VALUES(p_return_id,p_issued_id,CURRENT_DATE);

    SELECT issued_book_isbn INTO v_isbn
    FROM issues_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;
END;
$$;
```

---

# 📈 7️⃣ Power BI Data Model

Star Schema Implemented:

* Fact Table → issues_status
* Dimension Tables → branch, employees, members, books
* Transaction Table → return_status

Relationships: One-to-Many (1:*) with Single filter direction.

---

# 📊 8️⃣ DAX Measures Used in Power BI

## Total Books Issued

```DAX
Total Books Issued = COUNT(issues_status[issued_id])
```

## Total Revenue

```DAX
Total Revenue =
SUMX(
    issues_status,
    RELATED(books[rental_price])
)
```

## Total Returns

```DAX
Total Returns = COUNT(return_status[return_id])
```

## Active Issues (Not Returned)

```DAX
Active Issues =
COUNTROWS(
    FILTER(
        issues_status,
        ISBLANK(RELATED(return_status[return_id]))
    )
)
```

## Overdue Books (30 Days)

Calculated Column:

```DAX
Days Overdue =
DATEDIFF(issues_status[issued_date], TODAY(), DAY)
```

Measure:

```DAX
Overdue Books =
CALCULATE(
    COUNT(issues_status[issued_id]),
    issues_status[Days Overdue] > 30,
    ISBLANK(RELATED(return_status[return_id]))
)
```

---

# 📊 9️⃣ Dashboard Features

* KPI Cards (Revenue, Issues, Returns, Overdue)
* Revenue by Category Chart
* Branch Performance Analysis
* Employee Performance Table
* Member Registration Insights
* Active vs Returned Book Tracking

---

# 🚀 Key Learning Outcomes

* Relational Database Design
* Foreign Key Constraints
* CRUD Operations
* CTAS Implementation
* Stored Procedures
* Business-Oriented SQL Queries
* Star Schema Modeling
* DAX Calculations
* Interactive Dashboard Development
* End-to-End BI Workflow

---

![Library-System-Management_page-0001](https://github.com/user-attachments/assets/f912dec2-ee89-48fd-bddd-52200eeb0639)

<img width="532" height="326" alt="Data Modelling" src="https://github.com/user-attachments/assets/d812690d-4a8f-4c51-9211-e3e34e19fc9d" />


# 👨‍💻 Author

Mohan
PostgreSQL → Power BI End-to-End Analytics Project
