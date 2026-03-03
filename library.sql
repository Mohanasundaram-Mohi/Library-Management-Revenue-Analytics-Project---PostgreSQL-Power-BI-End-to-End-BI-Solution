----Library Management System project-2

---- creating branch table 
DROP TABLE IF EXISTS BRANCH;
CREATE TABLE BRANCH
	(
	branch_id VARCHAR(10) PRIMARY KEY, 
	manager_id VARCHAR(10),
	branch_address VARCHAR(55),
	contact_no VARCHAR(10)
	);

ALTER TABLE BRANCH
ALTER COLUMN contact_no TYPE VARCHAR(25);

DROP TABLE IF EXISTS EMPLOYEES; 
CREATE TABLE EMPLOYEES
	(
	emp_id VARCHAR(10) PRIMARY KEY,
	emp_name VARCHAR(25),	
	position VARCHAR(25),
	salary int,
	branch_id VARCHAR(25) -- FK
	);


DROP TABLE IF EXISTS BOOKS; 
CREATE TABLE BOOKS 
	(
	isbn VARCHAR(20) PRIMARY KEY, 
	book_title VARCHAR(75), 
	category VARCHAR(10),
	rental_price FLOAT,
	status VARCHAR(15),
	author VARCHAR(35),
	publisher VARCHAR(50)
	);

	ALTER TABLE BOOKS
	ALTER COLUMN CATEGORY TYPE VARCHAR(25);

DROP TABLE IF EXISTS MEMBERS; 
CREATE TABLE MEMBERS 
	(
	member_id VARCHAR(20) PRIMARY KEY,
	member_name	VARCHAR(25),
	member_address VARCHAR(77),
	reg_date DATE );


DROP TABLE IF EXISTS ISSUED_STATUS; 
CREATE TABLE ISSUES_STATUS 
	(
	issued_id VARCHAR(10) PRIMARY KEY,
	issued_member_id VARCHAR(10), -- FK
	issued_book_name VARCHAR(75),	
	issued_date	DATE,
	issued_book_isbn VARCHAR(25), --FK
	issued_emp_id VARCHAR(10) -- FK
)

DROP TABLE IF EXISTS RETURN_STATUS; 
CREATE TABLE RETURN_STATUS 
	(
	return_id VARCHAR(25) PRIMARY KEY, 
	issued_id VARCHAR(25),
	return_book_name VARCHAR(75),
	return_date DATE,
	return_book_isbn VARCHAR(20)
	);

----------FOREIGN KEY

ALTER TABLE ISSUES_STATUS 
ADD CONSTRAINT FK_MEMBERS
FOREIGN KEY (issued_member_id)
REFERENCES MEMBERS(member_id); 


ALTER TABLE ISSUES_STATUS 
ADD CONSTRAINT FK_BOOKS
FOREIGN KEY (issued_book_isbn)
REFERENCES BOOKS(isbn); 

ALTER TABLE EMPLOYEES
ADD CONSTRAINT FK_BRANCH
FOREIGN KEY (branch_id )
REFERENCES BRANCH(branch_id); 

ALTER TABLE RETURN_STATUS
ADD CONSTRAINT FK_ISSUED_STATUS
FOREIGN KEY (issued_id)
REFERENCES ISSUES_STATUS(issued_id); 


