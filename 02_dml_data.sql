-- =====================================================
-- FILE 2: DML (Data Manipulation Language)
-- Purpose : Insert, update and delete data
-- Run after: 01_ddl_schema.sql
-- =====================================================

USE library_db;

-- 1. INSERT ------------------------------------------

INSERT INTO categories (category_name) VALUES
('Fiction'),
('Science'),
('Technology'),
('History'),
('Self-Help');

INSERT INTO books (title, author, category_id, price, publish_year, total_copies, available_copies, language) VALUES
('Wings of Fire',               'A.P.J. Abdul Kalam', 5, 350.00, 1999, 5, 5, 'English'),
('The Alchemist',               'Paulo Coelho',       1, 299.00, 1988, 4, 4, 'English'),
('A Brief History of Time',     'Stephen Hawking',    2, 450.00, 1988, 3, 3, 'English'),
('Clean Code',                  'Robert C. Martin',   3, 650.00, 2008, 4, 4, 'English'),
('Introduction to Algorithms',  'Thomas H. Cormen',   3, 899.00, 2009, 2, 2, 'English'),
('Sapiens',                     'Yuval Noah Harari',  4, 499.00, 2011, 5, 5, 'English'),
('India After Gandhi',          'Ramachandra Guha',   4, 599.00, 2007, 3, 3, 'English'),
('Atomic Habits',               'James Clear',        5, 399.00, 2018, 6, 6, 'English'),
('The Discovery of India',      'Jawaharlal Nehru',   4, 380.00, 1946, 2, 2, 'English'),
('Python Crash Course',         'Eric Matthes',       3, 550.00, 2015, 4, 4, 'English'),
('The White Tiger',             'Aravind Adiga',      1, 320.00, 2008, 3, 3, 'English'),
('Cosmos',                      'Carl Sagan',         2, 420.00, 1980, 2, 2, 'English');

INSERT INTO members (full_name, email, phone, city, join_date) VALUES
('Aarav Sharma',  'aarav.sharma@example.com',  '9810000001', 'Delhi',     '2025-01-10'),
('Priya Verma',   'priya.verma@example.com',   '9810000002', 'Mumbai',    '2025-02-15'),
('Rohan Gupta',   'rohan.gupta@example.com',   '9810000003', 'Delhi',     '2025-03-20'),
('Sneha Iyer',    'sneha.iyer@example.com',    '9810000004', 'Chennai',   '2025-05-05'),
('Karan Singh',   'karan.singh@example.com',   '9810000005', 'Jaipur',    '2025-07-18'),
('Ananya Das',    'ananya.das@example.com',    '9810000006', 'Kolkata',   '2025-09-01'),
('Vikram Rao',    'vikram.rao@example.com',    '9810000007', 'Bengaluru', '2026-01-12'),
('Meera Nair',    'meera.nair@example.com',    '9810000008', 'Delhi',     '2026-03-25');

INSERT INTO borrow_records (member_id, book_id, borrow_date, due_date, return_date, fine_amount) VALUES
(1, 1,  '2026-08-01', '2026-08-15', '2026-08-14',  0),
(1, 4,  '2026-09-05', '2026-09-19', '2026-09-25', 60),
(2, 2,  '2026-08-10', '2026-08-24', '2026-08-22',  0),
(2, 8,  '2026-10-01', '2026-10-15', NULL,          0),
(3, 4,  '2026-09-12', '2026-09-26', '2026-09-26',  0),
(3, 10, '2026-10-05', '2026-10-19', NULL,          0),
(4, 6,  '2026-09-20', '2026-10-04', '2026-10-10', 60),
(5, 3,  '2026-10-08', '2026-10-22', NULL,          0),
(6, 8,  '2026-10-12', '2026-10-26', NULL,          0),
(7, 5,  '2026-09-01', '2026-09-15', NULL,          0),
(7, 10, '2026-08-20', '2026-09-03', '2026-09-01',  0),
(8, 6,  '2026-10-15', '2026-10-29', NULL,          0);

-- 2. UPDATE ------------------------------------------

-- Update one member's phone number
UPDATE members
SET phone = '9899999999'
WHERE member_id = 3;

-- Increase price of all Technology books by 10%
UPDATE books
SET price = price * 1.10
WHERE category_id = 3;

-- Keep stock in sync: every book not yet returned reduces available copies by 1
UPDATE books b
SET available_copies = available_copies - (
    SELECT COUNT(*)
    FROM borrow_records br
    WHERE br.book_id = b.book_id
      AND br.return_date IS NULL
)
WHERE b.book_id > 0;   -- WHERE on the key column keeps MySQL Workbench "Safe Updates" mode happy

-- A member returns a book today: set return date
UPDATE borrow_records
SET return_date = '2026-10-26'
WHERE record_id = 6;

-- Give the returned copy back to stock
UPDATE books
SET available_copies = available_copies + 1
WHERE book_id = 10;

-- Mark a member as inactive
UPDATE members
SET status = 'INACTIVE'
WHERE member_id = 6;

-- 3. DELETE ------------------------------------------

-- Add a wrong/duplicate member by mistake, then delete it
INSERT INTO members (full_name, email, phone, city, join_date)
VALUES ('Test User', 'test.user@example.com', '0000000000', 'Nowhere', '2026-10-26');

DELETE FROM members
WHERE email = 'test.user@example.com';

-- Verify the data
SELECT * FROM books;
SELECT * FROM members;
SELECT * FROM borrow_records;
