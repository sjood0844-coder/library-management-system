-- Library Management System Database
-- MySQL schema based on the university project report.
-- Example personal/contact records are intentionally omitted.

CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;

CREATE TABLE Category (
    Category_ID INT PRIMARY KEY AUTO_INCREMENT,
    Category_Name VARCHAR(100) NOT NULL UNIQUE,
    Note VARCHAR(250)
);

CREATE TABLE Books (
    Book_ID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    Publication_year INT CHECK (Publication_year >= 1500),
    Category_ID INT,
    FOREIGN KEY (Category_ID) REFERENCES Category(Category_ID)
);

CREATE TABLE Members (
    Member_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Address VARCHAR(255) NOT NULL
);

CREATE TABLE Member_Phones (
    Phone_Number VARCHAR(20),
    Member_ID INT,
    PRIMARY KEY (Phone_Number, Member_ID),
    FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID) ON DELETE CASCADE
);

CREATE TABLE Borrowings (
    Borrow_ID INT PRIMARY KEY AUTO_INCREMENT,
    Return_Status ENUM('Returned', 'Not Returned') DEFAULT 'Not Returned',
    Borrow_Date DATE NOT NULL,
    Return_date DATE,
    Member_ID INT NOT NULL,
    Book_ID INT NOT NULL,
    FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID),
    CONSTRAINT check_dates CHECK (
        Return_date IS NULL OR Return_date >= Borrow_Date
    )
);

CREATE TABLE Halls (
    Hall_ID INT PRIMARY KEY AUTO_INCREMENT,
    Type VARCHAR(100),
    Usage_Schedule TEXT
);

CREATE TABLE Reservations (
    Reservation_ID INT PRIMARY KEY AUTO_INCREMENT,
    Reservation_Date DATE NOT NULL,
    From_Time TIME NOT NULL,
    To_Time TIME NOT NULL,
    Member_ID INT NOT NULL,
    Hall_ID INT NOT NULL,
    FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID),
    FOREIGN KEY (Hall_ID) REFERENCES Halls(Hall_ID),
    CONSTRAINT check_time CHECK (To_Time > From_Time)
);

-- View: reservation details with member and hall information.
CREATE VIEW Reservation_Report AS
SELECT
    r.Reservation_ID,
    r.Reservation_Date,
    r.From_Time,
    r.To_Time,
    m.Name AS Member_Name,
    h.Type AS Hall_Type
FROM Reservations AS r
JOIN Members AS m ON r.Member_ID = m.Member_ID
JOIN Halls AS h ON r.Hall_ID = h.Hall_ID;

-- To inspect the view after inserting your own records:
-- SELECT * FROM Reservation_Report;
