

SET SQL_SAFE_UPDATES = 0;


-- 1. CREATE DATABASE ---------------------------------
DROP DATABASE IF EXISTS library_db;
CREATE DATABASE library_db;
USE library_db;

-- 2. CREATE TABLES -----------------------------------

-- Categories of books (parent table)
CREATE TABLE categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- Books (linked to categories)
CREATE TABLE books (
    book_id            INT AUTO_INCREMENT PRIMARY KEY,
    title              VARCHAR(150) NOT NULL,
    author             VARCHAR(100) NOT NULL,
    category_id        INT,
    price              DECIMAL(8,2) CHECK (price > 0),
    published_year     INT,
    total_copies       INT NOT NULL DEFAULT 1,
    available_copies   INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_books_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Library members
CREATE TABLE members (
    member_id  INT AUTO_INCREMENT PRIMARY KEY,
    full_name  VARCHAR(100) NOT NULL,
    email      VARCHAR(100) NOT NULL UNIQUE,
    phone      VARCHAR(15),
    city       VARCHAR(50),
    join_date  DATE NOT NULL
);

-- Borrowing history (links members and books)
CREATE TABLE borrow_records (
    record_id       INT AUTO_INCREMENT PRIMARY KEY,
    member_id       INT NOT NULL,
    book_id         INT NOT NULL,
    borrow_date     DATE NOT NULL,
    due_date        DATE NOT NULL,
    return_date     DATE NULL,                 -- NULL means not returned yet
    fine_amount     DECIMAL(6,2) DEFAULT 0,
    CONSTRAINT fk_borrow_member FOREIGN KEY (member_id) REFERENCES members(member_id),
    CONSTRAINT fk_borrow_book   FOREIGN KEY (book_id)   REFERENCES books(book_id)
);

-- 3. ALTER TABLE -------------------------------------
-- Add a new column
ALTER TABLE members ADD COLUMN status VARCHAR(10) DEFAULT 'ACTIVE';

-- Add another column
ALTER TABLE books ADD COLUMN language VARCHAR(30) DEFAULT 'English';

-- Change a column's size/type
ALTER TABLE members MODIFY COLUMN phone VARCHAR(20);

-- Rename a column
ALTER TABLE books RENAME COLUMN published_year TO publish_year;

-- 4. CREATE INDEX (speeds up searches) ---------------
CREATE INDEX idx_books_title ON books(title);

-- 5. DROP and TRUNCATE ----------------------
CREATE TABLE temp_notes (
    note_id INT PRIMARY KEY,
    note    VARCHAR(100)
);

INSERT INTO temp_notes VALUES (1, 'demo row 1'), (2, 'demo row 2');

TRUNCATE TABLE temp_notes;   -- removes all rows, keeps the table structure
DROP TABLE temp_notes;       -- removes the table completely

-- 6. Check the structure -----------------------------
SHOW TABLES;
DESCRIBE books;
