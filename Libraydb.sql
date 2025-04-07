CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    genre VARCHAR(100),
    published_year YEAR,
    status ENUM('Available', 'Borrowed') DEFAULT 'Available'
);

CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE,
    address TEXT
);

CREATE TABLE Librarians (
    librarian_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE
);

CREATE TABLE Borrowed_Books (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    member_id INT,
    borrow_date DATE DEFAULT (CURRENT_DATE),
    return_date DATE NULL,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE
);


INSERT INTO Books (title, author, genre, published_year, status) 
VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 1925, 'Available'),
('1984', 'George Orwell', 'Dystopian', 1949, 'Borrowed'),
('Moby Dick', 'Herman Melville', 'Adventure', 2002, 'Available'),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 'Available');

INSERT INTO Members (name, email, phone, address) 
VALUES
('John Doe', 'john.doe@example.com', '123-456-7890', '123 Main St, New York'),
('Jane Smith', 'jane.smith@example.com', '987-654-3210', '456 Elm St, California'),
('Alice Brown', 'alice.brown@example.com', '555-555-5555', '789 Oak St, Texas'),
('Bob White', 'bob.white@example.com', '444-444-4444', '101 Pine St, Florida');

INSERT INTO Librarians (name, email, phone) 
VALUES
('Sarah Miller', 'sarah.miller@example.com', '123-987-6543'),
('David Johnson', 'david.johnson@example.com', '555-123-9876'),
('Emma Wilson', 'emma.wilson@example.com', '333-444-5555'),
('Michael Davis', 'michael.davis@example.com', '666-777-8888');

INSERT INTO Borrowed_Books (book_id, member_id, borrow_date, return_date) 
VALUES
(5, 1, '2025-03-16', NULL),
(6, 2, '2025-03-14', '2025-03-18'),
(7, 3, '2025-03-12', NULL),
(8, 4, '2025-03-10', '2025-03-20');

SELECT * FROM Books
WHERE status = 'Available';

INSERT INTO Books (title, author, genre, published_year, status) 
VALUES ('The Catcher in the Rye', 'J.D. Salinger', 'Fiction', 1951, 'Available');

UPDATE Books
SET status = 'Borrowed'
WHERE book_id = 9; 

DELETE FROM Members
WHERE member_id = 1; 

START TRANSACTION;

UPDATE Borrowed_Books 
SET return_date = CURRENT_DATE 
WHERE borrow_id = 1;
UPDATE Books 
SET status = 'Available' 
WHERE book_id = 5;
COMMIT;

START TRANSACTION;

UPDATE Borrowed_Books 
SET return_date = CURRENT_DATE 
WHERE borrow_id = 1;

UPDATE Books 
SET status = 'Available' 
WHERE book_id = 5;
COMMIT;

SELECT b.book_id, b.title, bb.borrow_date, m.name AS borrowed_by
FROM Borrowed_Books bb
JOIN Books b ON bb.book_id = b.book_id
JOIN Members m ON bb.member_id = m.member_id
WHERE bb.return_date IS NULL;

SELECT b.book_id, b.title, bb.borrow_date, m.name AS borrowed_by
FROM Borrowed_Books bb
JOIN Books b ON bb.book_id = b.book_id
JOIN Members m ON bb.member_id = m.member_id
WHERE bb.return_date IS NULL AND DATEDIFF(CURRENT_DATE, bb.borrow_date) > 14;

