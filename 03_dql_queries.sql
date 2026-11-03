-- =====================================================
-- FILE 3: DQL (Data Query Language)
-- Purpose : Answer real library questions using SELECT
-- Run after: 01_ddl_schema.sql and 02_dml_data.sql
-- =====================================================

USE library_db;

-- ---------- SECTION A: Basic SELECT ----------

-- Q1. Show all books
SELECT * FROM books;

-- Q2. Show only title, author and price
SELECT title, author, price FROM books;

-- Q3. Unique cities our members come from
SELECT DISTINCT city FROM members;

-- ---------- SECTION B: Filtering (WHERE) ----------

-- Q4. Books priced above 500
SELECT title, price FROM books WHERE price > 500;

-- Q5. Books published between 2000 and 2015
SELECT title, publish_year FROM books WHERE publish_year BETWEEN 2000 AND 2015;

-- Q6. Members from Delhi or Mumbai
SELECT full_name, city FROM members WHERE city IN ('Delhi', 'Mumbai');

-- Q7. Books whose title contains the word 'India'
SELECT title FROM books WHERE title LIKE '%India%';

-- Q8. Books borrowed but not yet returned
SELECT record_id, member_id, book_id, due_date
FROM borrow_records
WHERE return_date IS NULL;

-- ---------- SECTION C: Sorting and limiting ----------

-- Q9. Top 3 most expensive books
SELECT title, price FROM books ORDER BY price DESC LIMIT 3;

-- Q10. Members sorted by newest joined first
SELECT full_name, join_date FROM members ORDER BY join_date DESC;

-- ---------- SECTION D: Aggregate functions ----------

-- Q11. Total number of books, average and highest price
SELECT COUNT(*)  AS total_titles,
       AVG(price) AS avg_price,
       MAX(price) AS max_price
FROM books;

-- Q12. Total fine collected
SELECT SUM(fine_amount) AS total_fine FROM borrow_records;

-- ---------- SECTION E: GROUP BY and HAVING ----------

-- Q13. Number of members in each city
SELECT city, COUNT(*) AS total_members
FROM members
GROUP BY city
ORDER BY total_members DESC;

-- Q14. Cities having more than 1 member
SELECT city, COUNT(*) AS total_members
FROM members
GROUP BY city
HAVING COUNT(*) > 1;

-- ---------- SECTION F: JOINs ----------

-- Q15. Book title with its category name (INNER JOIN)
SELECT b.title, c.category_name
FROM books b
INNER JOIN categories c ON b.category_id = c.category_id;

-- Q16. Who borrowed which book
SELECT m.full_name, b.title, br.borrow_date, br.due_date, br.return_date
FROM borrow_records br
JOIN members m ON br.member_id = m.member_id
JOIN books   b ON br.book_id   = b.book_id
ORDER BY br.borrow_date;

-- Q17. All members, including those who never borrowed (LEFT JOIN)
SELECT m.full_name, COUNT(br.record_id) AS books_borrowed
FROM members m
LEFT JOIN borrow_records br ON m.member_id = br.member_id
GROUP BY m.member_id, m.full_name
ORDER BY books_borrowed DESC;

-- Q18. Most borrowed books
SELECT b.title, COUNT(*) AS times_borrowed
FROM borrow_records br
JOIN books b ON br.book_id = b.book_id
GROUP BY b.book_id, b.title
ORDER BY times_borrowed DESC
LIMIT 3;

-- Q19. Number of books in each category
SELECT c.category_name, COUNT(b.book_id) AS total_books
FROM categories c
LEFT JOIN books b ON c.category_id = b.category_id
GROUP BY c.category_id, c.category_name;

-- ---------- SECTION G: Real-world business questions ----------

-- Q20. Overdue books today (due date passed and not returned)
SELECT m.full_name, b.title, br.due_date,
       DATEDIFF('2026-10-26', br.due_date) AS days_overdue
FROM borrow_records br
JOIN members m ON br.member_id = m.member_id
JOIN books   b ON br.book_id   = b.book_id
WHERE br.return_date IS NULL
  AND br.due_date < '2026-10-26';

-- Q21. Total fine paid by each member
SELECT m.full_name, SUM(br.fine_amount) AS total_fine
FROM borrow_records br
JOIN members m ON br.member_id = m.member_id
GROUP BY m.member_id, m.full_name
HAVING SUM(br.fine_amount) > 0;

-- ---------- SECTION H: Subqueries ----------

-- Q22. Books priced above the average price
SELECT title, price
FROM books
WHERE price > (SELECT AVG(price) FROM books);

-- Q23. Members who have never borrowed a book
SELECT full_name
FROM members
WHERE member_id NOT IN (SELECT member_id FROM borrow_records);

-- Q24. Books that are currently out of stock
SELECT title, available_copies FROM books WHERE available_copies = 0;
