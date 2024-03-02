/* Ryan Taylor 
   Project 3
   2/27/2024
   **********************************************
   2/13/2024 - VERSION 0.1 - created the sql file for project 2 and set up the mod log,
							 set up the database to use master and check to see if the 
							 database exists and if not then create it, 

   2/15/2024 - VERSION 0.2 - Created Genre Table and GenreID as PRIMARY KEY,

							 Created Status Table and StatustID as PRIMARY KEY,

							 Created DiskType Table and DiskTypeID as PRIMARY KEY,

							 Created Disk Table and DiskID as PRIMARY KEY and GenreID, StatusID, DiskType as Foreign Keys,

							 Created Borrower Table and BorrowerID as PRIMARY KEY,

							 Created DiskHasBorrower Table and DiskHasBorrowerID as PRIMARY KEY and BorrowerID, DiskID as Foreign Keys,

							 Created ArtistType Table and ArtistTypeID as PRIMARY KEY,

							 Created Artist Table and ArtistID as PRIMARY KEY,

							 Created DiskHasArtist and DistHasArtistID as PRIMARY KEY and ArtistID, DiskID as Foreign Keys,

							 Executed the program to make sure that it worked properly.

  2/16/2024 - VERSION 0.3 - Set up the User login and Password

  2/27/2024 - VERSION 0.4 - Updated Project 2 to be Project 3, Updated DiskName to include 60 characters and updated PhoneNum to be a VarChar instead of a INT,
                            Inserted 5 Rows of Real-World Data into Genre, Status, and DiskType Tables,
							Inserted 20 new rows of data into Disk Table, Updated 1 Row with a where clause, Inserted 25 Rows into the Borrower Table and created 
							delete statement to delete 1 row using a where clause

  3/1/2024 - VERSION  0.5 - Inserted 25 rows into the DiskHasBorrower Table, Created Query to list the disks that are on loan and have not been returned.

   **********************************************
*/

--Needed to update DiskName to include 60 Characters instead of 20, Updated PhoneNum to be VarChar instead of INT

--Uses Master Database
USE master;
GO 

--Drops Database IF EXISTS
DROP DATABASE IF EXISTS disk_inventoryRT;
GO

--CREATES DATABASE
CREATE DATABASE disk_inventoryRT;
GO 

--CHECKS IF USER IS NULL AND CREATES USER LOGIN
IF SUSER_ID ('diskUserRT') IS NULL
	CREATE LOGIN diskUserRT WITH PASSWORD = 'RTPa$$word23',
	DEFAULT_DATABASE = disk_inventoryRT;

--USE DATABASE
USE disk_inventoryRT;
GO

--DROP USE IF EXISTS AND CREATES NEW USER
DROP USER IF EXISTS diskUserRT;
	CREATE USER diskUserRT;

--ALTERS ROLE IN DATABSE AND ADD MEMBER
ALTER ROLE db_datareader ADD MEMBER diskUserRT;

--Creates Genre table and sets the GenreID as the Primary Key
CREATE TABLE Genre
(GenreID			INT					PRIMARY KEY IDENTITY,
 Description		CHAR(20)			NOT NULL);

--Creates Status table and sets the StatusID as the Primary Key
CREATE TABLE Status
(StatusID			INT					PRIMARY KEY IDENTITY,
 Description		CHAR(20)			NOT NULL);

--Creates DiskType table and sets the DiskTypeID as the Primary Key
CREATE TABLE DiskType
(DiskTypeID				INT					PRIMARY KEY IDENTITY,
 Description		CHAR(20)			NOT NULL);

-- Creates Disk Table and sets the DiskID as the Primary Key and References the GenreID, StatusID, DiskTypeID as Foreign Keys
CREATE TABLE Disk
(DiskID				INT		NOT NULL	PRIMARY KEY IDENTITY,
 DiskName			VARCHAR(60)			NOT NULL,
 ReleaseDate		DATE				NOT NULL,
 GenreID			INT					NOT NULL
					   REFERENCES Genre(GenreID),
 StatusID			INT					NOT NULL
					   REFERENCES Status(StatusID),
 DiskTypeID			INT					NOT NULL
					   REFERENCES DiskType(DiskTypeID));

--Creates Borrower table and sets BorrowerID as Primary Key
CREATE TABLE Borrower
(BorrowerID			INT					PRIMARY KEY IDENTITY,
 FirstName			VARCHAR(20)			NOT NULL,
 LastName			VARCHAR(20)			NOT NULL,
 PhoneNum			VARCHAR(20)		    NOT NULL);

--Creates DiskHasBorrower table and sets DiskHasBorrowerID as Primary Key and References the BorrowerID, DiskID as Foreign Keys
CREATE TABLE DiskHasBorrower
(DiskHasBorrowerID  INT					PRIMARY KEY IDENTITY,
 BorrowedDate		DATE				NULL,
 DueDate			DATE				NULL,
 ReturnedDate		DATE				NULL,
 BorrowerID			INT					NOT NULL
					   REFERENCES Borrower(BorrowerID),
 DiskID				INT					NOT NULL
					   REFERENCES Disk(DiskID));

--Creates ArtistType table and sets ArtistTypeID as Primary Key
CREATE TABLE ArtistType
(ArtistTypeID		INT					PRIMARY KEY IDENTITY,
 Description		CHAR(20)			NOT NULL);

--Creates Artist table and sets ArtistID as Primary Key and References ArtistTypeID as Foreign Key
CREATE TABLE Artist
(ArtistID			INT					PRIMARY KEY IDENTITY,
 FirstName			VARCHAR(20)			NOT NULL,
 LastName			VARCHAR(20)			NOT NULL,
 ArtistTypeID		INT					NOT NULL
					   REFERENCES ArtistType(ArtistTypeID));

--Creates DiskHasArtist table and sets DiskHasArtistID as Primary Key and References DiskID, ArtistID as Foreign Keys
CREATE TABLE DiskHasArtist
(DiskHasArtistID	INT					PRIMARY KEY IDENTITY,
 DiskID				INT					NOT NULL
					   REFERENCES Disk(DiskID),
 ArtistID			INT					NOT NULL
					   REFERENCES Artist(ArtistID));

--Inserting 5 new rows into DiskType Table
INSERT INTO DiskType
VALUES ('Cassette'),--1
	   ('CD'),--2
	   ('DVD'),--3
	   ('8-Track'),--4
	   ('Record');--5

--Inserting 5 new rows into Genre Table
INSERT INTO Genre
VALUES ('Pop'),--1
	   ('Rock'),--2
	   ('Jazz'),--3
	   ('R&B'),--4
	   ('Western Music'),--5
	   ('Action'),--6
	   ('Comedy');--7

--Inserting 5 new rows into Status Table
INSERT INTO Status
VALUES ('Available'),--1
	   ('On Loan'),--2
	   ('Reserved'),--3
	   ('Overdue'),--4
	   ('Lost');--5

--Inserting 20 new rows of data into Disk Table
INSERT INTO Disk (DiskName, ReleaseDate, GenreID, StatusID, DiskTypeID)
VALUES ('Back in Black', '1980-07-25', 2, 2, 2),
	   ('Hotel California', '1976-12-08', 2, 4, 1),
       ('Ghost Riders in the Sky', '1948-06-05', 6, 1, 5),
	   ('Kind of Blue', '1959-08-17', 4, 5, 5),
	   ('Thriller', '1982-11-30', 4, 3, 4),
	   ('Abbey Road', '1969-09-26', 1, 4, 5),
	   ('22', '2012-03-12', 1, 3, 2),
	   ('Die Hard', '1988-07-15', 6, 1, 3),
	   ('Dumb and Dumber', '1994-12-16', 7, 2, 3),
	   ('OK Computer', '1997-06-16', 2, 4, 2),
	   ('The Dark Side of the Moon', '1973-03-01', 2, 5, 1),
	   ('Blue Train', '1957-09-15', 3, 2, 5),
	   ('The Good, the Bad and the Ugly (Soundtrack)', '1966-12-29', 5, 1, 5),
	   ('Channel Orange', '2012-07-10', 4, 2, 2),
	   ('Mad Max: Fury Road', '2015-05-15', 6, 5, 3),
	   ('Super Troopers', '2001-02-15', 7, 3, 3),
	   ('Anchorman: The Legend of Ron Burgundy', '2004-07-09', 7, 1, 3),
	   ('A Love Supreme', '1965-02-25', 3, 4, 5),
	   ('1989', '2014-10-27', 1, 5, 2),
	   ('Led Zeppelin IV', '1971-11-08', 2, 2, 4),
	   ('Once Upon a Time in the West (Soundtrack)', '1969-12-21', 5, 1, 5);

--Update Statement for the Disk Table
UPDATE Disk
SET DiskTypeID = 1
WHERE DiskID = 21;

--Insert Data into Borrower Table
INSERT INTO Borrower (FirstName, LastName, PhoneNum)
VALUES ('Nolan', 'Smith', '5555555555'),
       ('Scotti', 'Khomin', '135-998-2390'),
	   ('Niccolo', 'Latch', '811-933-2928'),
	   ('Kirstyn', 'McIlwrath', '773-233-8709'),
       ('Kasper', 'Leyden', '842-228-3848'),
	   ('Latashia', 'McAless', '986-452-2798'),
	   ('Phip', 'Peperell', '814-698-0519'),
	   ('Donnie', 'Hindenberger', '849-295-9919'),
	   ('Happy', 'Clues', '259-217-0516'),
	   ('Fayette', 'Blancowe', '507-480-5538'),
	   ('Nancie', 'Selborne', '996-633-8339'),
	   ('Giselbert', 'Gonthard', '463-771-6101'),
	   ('Gerda', 'Moorhead', '186-668-9866'),
	   ('Corbie', 'Ors', '682-254-2675'),
	   ('Vania', 'Mullis', '427-460-7512'),
	   ('Adrea', 'Abisetti', '347-818-7709'),
	   ('Cynthie', 'Shortall', '492-880-1866'),
	   ('Mauricio', 'Dransfield', '513-132-2419'),
	   ('Burt', 'Castagno', '447-270-7536'),
	   ('Timofei', 'MacCartney', '850-682-1091'),
	   ('Marchelle', 'Halvorsen', '470-478-6698'),
       ('Bea', 'Flay', '691-762-7667'),
	   ('Chick', 'Scaife', '829-714-9960'),
	   ('Gerrilee', 'Farnhill', '189-759-5413'),
	   ('Jocko', 'McMorran', '736-873-7069');

--DELETE STATEMENT ON THE BORROWER TABLE 
DELETE FROM Borrower
WHERE LastName = 'Smith';

--INSERT DATA INTO DISKHASBORROWER TABLE 
INSERT INTO DiskHasBorrower (BorrowedDate, DueDate, ReturnedDate, DiskID, BorrowerID)
VALUES ('2023-03-17', '2023-04-17', '2023-04-16', 4, 2),
       ('2023-04-17', '2023-05-17', '2023-05-20', 2, 2),
	   ('2023-05-17', '2023-06-17', '2023-06-25', 3, 3),
	   ('2023-07-17', '2023-08-17', NULL, 4, 4),
	   ('2023-08-17', '2023-09-17', '2023-08-30', 5, 5),
	   ('2023-10-17', '2023-11-17', NULL, 6, 6),
	   ('2023-11-17', '2023-12-17', NULL, 7, 7),
	   ('2023-12-17', '2023-12-25', NULL, 8, 8),
	   ('2023-02-17', '2023-03-17', NULL, 1, 9),
	   ('2023-01-17', '2023-02-17', NULL, 2, 10),
	   ('2023-04-17', '2023-04-25', NULL, 9, 11),
	   ('2023-05-17', '2023-05-30', NULL, 4, 2),
	   ('2023-06-17', '2023-07-26', NULL, 3, 3),
	   ('2023-11-17', '2023-11-25', '2023-11-22', 12, 13),
	   ('2023-10-17', '2023-10-24', NULL, 12, 14),
	   ('2023-02-17', '2023-06-17', NULL, 1, 15),
	   ('2023-03-17', '2023-05-17', NULL, 9, 16),
	   ('2023-03-17', '2023-05-17', NULL, 14, 17),
	   ('2023-01-17', '2023-04-17', '2023-04-02', 15, 18),
	   ('2023-07-17', '2023-08-17', '2023-09-16', 19, 19),
	   ('2023-06-17', '2023-10-17', '2023-09-22', 15, 20),
	   ('2023-03-17', '2023-07-17', NULL, 6, 21),
	   ('2023-12-17', '2023-12-20', '2023-12-23', 12, 22),
	   ('2023-12-17', '2023-12-20', '2023-12-23', 13, 22),
	   ('2023-10-17', '2023-10-25', '2023-10-30', 2, 25),
	   ('2023-10-17', '2023-10-25', '2023-10-30', 15, 24); 
       
--QUERY THAT LISTS THE DISKS THAT ARE ON LOAN AND HAVE NOT BEEN RETURNED
SELECT BorrowerID, DiskID, BorrowedDate, ReturnedDate
FROM DiskHasBorrower
WHERE ReturnedDate IS NULL;