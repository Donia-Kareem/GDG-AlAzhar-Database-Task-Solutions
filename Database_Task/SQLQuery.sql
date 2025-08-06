
--1 Write a query that displays Full name of an employee who has more than
 --3 letters in his/her First Name
SELECT CONCAT(Fname,' ',Lname)
FROM Employee
WHERE LEN(Fname)>3

--2. Write a query to display the total number of Programming books
 --available in the library with alias name ‘NO OF PROGRAMMING BOOKS

 SELECT COUNT(C.Id) AS 'NO OF PROGRAMMING BOOKS'
 FROM Category C  
 WHERE Cat_name='Programming'

 --3 Write a query to display the number of books published by
 --(HarperCollins) with the alias name 'NO_OF_BOOKS'

 SELECT COUNT(B.Publisher_id) AS 'NO_OF_BOOKS'
 FROM BooK B , Publisher P
 where B.Publisher_id=P.Id AND P.Name='HarperCollins'
 
 --4 Write a query to display the User SSN and name, date of borrowing and
 --due date of the User whose due date is before July 2022

 SELECT SSN , User_Name 
 FROM Users S ,Borrowing B
 WHERE S.SSN=B.User_ssn AND Due_date< '2022-07-01'

 --5 Write a query to display book title, author name and display in the
 --following format, [Book Title] is written by [Author Name].

 SELECT '['+B.Title+']'+  ' is written by '+ '['+A.Name+']' AS InfoAboutBook
 FROM Book B ,Author A,Book_Author BA
 WHERE B.Id=BA.Book_id AND BA.Author_id=A.Id


 --6 Write a query to display the name of users who have letter 'A' in their names

 SELECT USER_NAME
 FROM Users
 WHERE USER_NAME LIKE '%A%'


 --7 Write a query that display user SSN who makes the most borrowing
 SELECT B.User_ssn,COUNT(B.User_ssn) AS NUM_OF_BORROWING
 FROM Borrowing B
 GROUP BY B.User_ssn
 HAVING COUNT(B.User_ssn)=
 (SELECT MAX(UserBorrowCount)
    FROM (
        SELECT COUNT(*) AS UserBorrowCount
        FROM Borrowing
        GROUP BY User_ssn
    )AS BorrowCount
)

--8 Write a query that displays the total amount of money that each user paid
 --for borrowing books

 SELECT SSN,SUM(B.Amount) AS Total_amount_of_money
 FROM Users U ,Borrowing B
 WHERE U.SSN=B.User_ssn
 GROUP BY U.SSN

-- 9write a query that displays the category which has the book that has the
 --minimum amount of money for borrowing

 SELECT C.Cat_name
 FROM Category C,Borrowing B,Book BO
 WHERE B.Book_id=BO.Id AND BO.Cat_id=C.Id
 AND B.Amount = (
    SELECT MIN(Amount)
    FROM Borrowing
)
-- 10.write a query that displays the email of an employee if it's not found,
 --display address if it's not found, display date of birthday
 SELECT COALESCE(Email, Address , CONVERT(VARCHAR(20), DOB))
 FROM Employee

 --11 Write a query to list the category and number of books in each category
 --with the alias name 'Count Of Books'

 SELECT C.Cat_name,COUNT(B.Cat_id)
 FROM Category C,Book B
 WHERE C.Id=B.Cat_id
 GROUP BY C.Cat_name 

 --12 Write a query that display books id which is not found in floor num = 1
 --and shelf-code = A1

 SELECT B.Id
 FROM Book B
 WHERE B.Id NOT IN(SELECT  B.Id
 FROM Shelf S ,Book B
 WHERE B.Shelf_code='A1' AND S.Floor_num=1
 )

 --13.Write a query that displays the floor number , Number of Blocks and
 --number of employees working on that floor.

 SELECT F.Number,F.Num_blocks,COUNT(E.Id) AS NUM_OF_EMPL_WORK
 FROM Floor F ,Employee E
 WHERE F.Number=E.Floor_no
 GROUP BY F.Number,F.Num_blocks

 --14 Display Book Title and User Name to designate Borrowing that occurred
 --within the period ‘3/1/2022’ and ‘10/1/2022’

 SELECT B.Title,U.User_Name
 FROM Book B,Users U, Borrowing BO
 WHERE B.Id=BO.Book_id AND BO.User_ssn=U.SSN
 AND BO.Borrow_date BETWEEN '2022-03-01' AND '2022-10-01'


 -- 15.Display Employee Full Name and Name Of his/her Supervisor as
 --Supervisor Name

 SELECT  E.Fname + ' ' + E.Fname AS Employee_Name,
  SU.Fname Supervisor_Name
 FROM Employee E,Employee SU
 WHERE E.Super_id=SU.Id

 --16 Select Employee name and his/her salary but if there is no salary display
 --Employee bonus.

 SELECT  Fname , COALESCE(Salary,Bouns)
 FROM Employee

--17.Display max and min salary for Employees

SELECT MAX(Salary) AS 'MAX Salary',MIN(Salary) AS 'MIN Salary'
FROM Employee E

--18 Write a function that take Number and display if it is even or odd

CREATE  FUNCTION CHEACK(@NUM INT)
RETURNS VARCHAR(10)
AS 
BEGIN
DECLARE @RES VARCHAR(10)
IF(@NUM%2=0)
SET  @RES='EVEN'
ELSE
SET  @RES='Odd'
RETURN @RES
END
--CALL
SELECT dbo.CHEACK(7)
SELECT dbo.CHEACK(8)

--19.write a function that take category name and display Title of books in that
 --category
CREATE FUNCTION DisplyTitle(@category VARCHAR(50))
RETURNS VARCHAR(30) 
AS 
BEGIN
DECLARE @RES VARCHAR(30)
SELECT @RES=B.Title
FROM Category C,Book B
WHERE C.Id=B.Cat_id AND C.Cat_name=@category
RETURN @RES
END

---20 write a function that takes the phone of the user and displays Book Title ,
 --user-name, amount of money and due-date.

 CREATE FUNCTION BookInfo (@phone VARCHAR(11))
 RETURNS TABLE
 AS 
 RETURN(
 SELECT B.Title,U.User_Name,BO.Amount,BO.Due_date
 FROM User_phones UP,Users U,Book B,Borrowing BO
 WHERE UP.Phone_num=@phone AND UP.User_ssn=U.SSN AND U.SSN=BO.User_ssn
 AND BO.Book_id=B.Id
 )
 --CALL
 SELECT * FROM dbo.BookInfo('0120255444')

--21 21.Write a function that take user name and check if it's duplicated
--return Message in the following format ([User Name] is Repeated [Count]
--times) if it's not duplicated display msg with this format [user name] is
--not duplicated,if it's not Found Return [User Name] is Not Found
CREATE FUNCTION CheckDuplicateUser (@UserName VARCHAR(50))
RETURNS VARCHAR(100)
AS
BEGIN
DECLARE @Count INT
DECLARE @Mess VARCHAR(100)
SELECT @Count = COUNT(*)
FROM Users U
WHERE U.User_Name = @UserName
IF @Count = 0
SET @Mess = '[' + @UserName + '] is Not Found'
ELSE IF @Count = 1
SET @Mess= '[' + @UserName + '] is not duplicated';
ELSE
SET @Mess= '[' + @UserName + '] is Repeated ' + CONVERT(VARCHAR,@Count) + 'times'
RETURN @Mess
END
--CALL
SELECT dbo.CheckDuplicateUser('Amr Ahmed')

--22.Create a scalar function that takes date and Format to return Date With
 --That Format.

 CREATE FUNCTION DATEFORMATT(@INDATE DATE ,@FORMAT VARCHAR(50))
 RETURNS VARCHAR(100)
 AS 
 BEGIN
 DECLARE @FormattedDate VARCHAR(100)
 SET @FormattedDate=FORMAT(@INDATE,@FORMAT)
 RETURN @FormattedDate
 END
 --CALL
 SELECT dbo.DATEFORMATT(GETDATE(), 'yyyy-MM-dd')

-- 23.Create a stored procedure to show the number of books per Category.

CREATE PROCEDURE GetBooksPerCategory
AS
BEGIN
SET NOCOUNT ON
SELECT 
c.Cat_name,COUNT(b.Id) AS BookCount
FROM Category c LEFT JOIN Book b
ON 
c.Id = b.Cat_id
GROUP BY c.Cat_name
END


---25Create a viewAlexAndCairoEmp that displays Employee data for users
 --who live in Alex or Cairo

CREATE VIEW viewAlexAndCairoEmp
AS
SELECT *
FROM Employee E
WHERE E.Address IN ('Alex', 'Cairo')
--CALL
SELECT * FROM viewAlexAndCairoEmp

--26.create a view "V2" That displays number of books per shelf

CREATE VIEW NUM_BOOKS_PER_SHELF
AS
SELECT B.Shelf_code,COUNT(B.Id) AS BOOK_COUNT
FROM Book B
GROUP BY B.Shelf_code
--CALL
SELECT * FROM NUM_BOOKS_PER_SHELF


--27.create a view "V3" That display the shelf code that have maximum
 --number of books using the previous view "V2"

 CREATE VIEW V3
 AS 
 SELECT Shelf_code, BOOK_COUNT 
 FROM NUM_BOOKS_PER_SHELF
 WHERE BOOK_COUNT =(
 SELECT MAX(BOOK_COUNT)
FROM NUM_BOOKS_PER_SHELF
)
--CALL
SELECT * FROM V3

---28.Create a table named ‘ReturnedBooks’With the Following Structure :....
--- then create A trigger that instead of inserting the data of returned book
 --checks if the return date is the due date or not if not so the user must pay
 --a fee and it will be 20% of the amount that was paid before.

 CREATE TABLE ReturnedBooks (
UserSSN VARCHAR(20),
BookID INT,
DueDate DATE,
ReturnDate DATE,
Fees DECIMAL(10, 2),PRIMARY KEY (UserSSN, BookID)
)

CREATE TRIGGER TRG_RETURNBOOKS
ON ReturnedBooks 
INSTEAD OF INSERT
AS
BEGIN
DECLARE @UserSSN VARCHAR(20)
DECLARE @BookID INT
DECLARE @DueDate DATE
DECLARE @ReturnDate DATE
DECLARE @Fees DECIMAL(10, 2)
DECLARE @AmountPaid DECIMAL(10, 2)

SELECT 
@UserSSN = I.UserSSN,
@BookID = I.BookID,
@DueDate = I.DueDate,
@ReturnDate = I.ReturnDate
FROM INSERTED I

SELECT @AmountPaid = B.Amount
FROM Borrowing B
WHERE B.User_ssn = @UserSSN AND B.Book_id = @BookID

IF @ReturnDate > @DueDate
BEGIN
SET @Fees = @AmountPaid * 0.20
END
ELSE
BEGIN
SET @Fees = 0.00
END

INSERT INTO ReturnedBooks (UserSSN, BookID, DueDate, ReturnDate, Fees)
VALUES (@UserSSN, @BookID, @DueDate, @ReturnDate, @Fees)

END


--29In the Floor table insert new Floor With Number of blocks 2 , employee
 --with SSN = 20 asamanager for this Floor,The start date for this manager
 --is Now. Do what is required if you know that : Mr.Omar Amr(SSN=5)
 --moved to be the manager of the new Floor (id = 6), and they give Mr.Ali
 --Mohamed(his SSN =12) His position 
INSERT INTO Floor (Number,Num_blocks, MG_ID, Hiring_Date)
VALUES (7, 2, 20, GETDATE())

DECLARE @PreFloorID INT

SELECT @PreFloorID = F.Number
FROM Floor F
WHERE F.MG_ID = 5  AND F.Number != 6

UPDATE Floor 
SET MG_ID = 5,Hiring_Date= GETDATE()
WHERE Number = 6

IF @PreFloorID IS NOT NULL
BEGIN
UPDATE Floor 
SET MG_ID = 12,
Hiring_Date = GETDATE()
WHERE  Number = @PreFloorID
END
ELSE
BEGIN
PRINT 'Mr.Omar was not managing any previous floor'
END

--31.Create a trigger to prevent anyone from Modifying or Delete or Insert in
 --the Employee table ( Display a message for user to tell him that he can’t
 --take any action with this Table)

CREATE TRIGGER PreventEmployeeActions
ON Employee
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
SET NOCOUNT ON
RAISERROR ('You cannot take any action (INSERT, UPDATE, DELETE) on the Employees table.', 16, 1)
END


-- 32.Testing Referential Integrity , Mention What Will Happen When:
-- A. AddanewUserPhone NumberwithUser_SSN= 50in
--Uer_Phones Table
SELECT * FROM Users WHERE SSN = 50
INSERT INTO User_Phones (User_SSN, Phone_num)
VALUES (50, '01122334455')
--B. Modify the employee id 20 in the employee table to 21
 SELECT * FROM Employee WHERE Id=21
 UPDATE Employee SET Id = 21 WHERE Id = 20
 -- C. Delete the employee with id 1
SELECT * FROM Employee WHERE Id = 1
DELETE FROM Employee WHERE Id = 1
-- D. Delete the employee with id 12 
DELETE FROM Employee WHERE Id = 12
-- E. Create an index on column (Salary) that allows you to cluster the
--ata in table Employee. 

CREATE  index salaryind
ON Employee (Salary)

---33.Try to Create Login With Your NameAnd give yourself access Only to
 --Employee and Floor tables then allow this login to select and insert data
 --into tables and deny Delete and update (Don't Forget To take screenshot
-- to every step) 
--1
CREATE LOGIN DoniaLogin WITH PASSWORD = '1234@dd'
--2 
CREATE USER DoniaUser FOR LOGIN DoniaLogin
--3
GRANT SELECT, INSERT ON Employee TO DoniaUser
GRANT SELECT, INSERT ON Floor TO DoniaUser
--4
DENY UPDATE, DELETE ON Employee TO DoniaUser
DENY UPDATE, DELETE ON Floor TO DoniaUser
--5 test
SELECT * FROM Employee
INSERT INTO Floor (Number, Num_blocks) VALUES (9, 9)
DELETE FROM Employee WHERE Id = 1






 








