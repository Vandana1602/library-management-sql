# Library Management System (SQL)

This is a small SQL project I made to practise what I have learned so far in SQL. It is based on a simple library where members borrow books and return them. I used MySQL for it.

The database has four tables: categories, books, members and borrow_records. Each book belongs to a category, and the borrow_records table connects members with the books they borrowed. It also stores the due date, the return date and any fine.

## Files

01_ddl_schema.sql - creates the database and tables. It also has examples of ALTER, TRUNCATE and DROP.

02_dml_data.sql - adds sample data and has examples of INSERT, UPDATE and DELETE.

03_dql_queries.sql - has 24 SELECT queries, from simple ones to JOINs, GROUP BY, HAVING and subqueries. For example, finding overdue books, the most borrowed books and the total fine of each member.

## How to run

Open the files in MySQL Workbench (or any MySQL 8 client) and run them in order: first 01, then 02, then 03. The first file deletes and recreates the library_db database, so running it again will reset everything.

## What I practised

- Creating tables with primary keys, foreign keys and other constraints
- Inserting, updating and deleting data
- Filtering and sorting with WHERE, ORDER BY and LIMIT
- Grouping data with GROUP BY and HAVING
- Joining two or three tables together
- Writing simple subqueries

I plan to add more to this project later, like views, triggers and stored procedures.
