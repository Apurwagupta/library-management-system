-- PostgreSQL Database Schema for Library Management System

-- Table for storing information about books
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INT NOT NULL,
    publisher_id INT NOT NULL,
    published_date DATE,
    genre VARCHAR(100),
    isbn VARCHAR(13),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);

-- Table for storing information about authors
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table for storing information about publishers
CREATE TABLE publishers (
    publisher_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table for storing library members
CREATE TABLE members (
    member_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    membership_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table for storing transactions (loans and returns)
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    transaction_type VARCHAR(10) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    return_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Indexes for the tables
CREATE INDEX idx_books_author ON books(author_id);
CREATE INDEX idx_transactions_member ON transactions(member_id);

-- Trigger function to update updated_at field
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers
CREATE TRIGGER update_books_timestamp
BEFORE UPDATE ON books
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER update_authors_timestamp
BEFORE UPDATE ON authors
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER update_publishers_timestamp
BEFORE UPDATE ON publishers
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER update_members_timestamp
BEFORE UPDATE ON members
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER update_transactions_timestamp
BEFORE UPDATE ON transactions
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

-- Stored procedure to add a new book
CREATE OR REPLACE FUNCTION add_book(
    p_title VARCHAR,
    p_author_id INT,
    p_publisher_id INT,
    p_published_date DATE,
    p_genre VARCHAR,
    p_isbn VARCHAR
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO books (title, author_id, publisher_id, published_date, genre, isbn)
    VALUES (p_title, p_author_id, p_publisher_id, p_published_date, p_genre, p_isbn);
END;
$$ LANGUAGE plpgsql;

-- Example call for adding a book
-- CALL add_book('The Great Gatsby', 1, 1, '1925-04-10', 'Fiction', '9780743273565');
