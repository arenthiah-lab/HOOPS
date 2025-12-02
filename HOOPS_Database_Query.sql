-- Create database
IF NOT EXISTS(Select * From sys.databases
WHERE NAME = N'HOOPS FOR ALL')
BEGIN
	CREATE DATABASE [HOOPS FOR ALL];
END
GO

USE [HOOPS FOR ALL]

--Drop Existing tables
IF EXISTS(Select * From sys.tables
WHERE NAME = N'OrderLineItem')
DROP TABLE [OrderLineItem];

IF EXISTS(Select * From sys.tables
WHERE NAME = N'Order')
DROP TABLE [Order];

IF EXISTS(Select * From sys.tables
WHERE NAME = N'OrderStatus')
DROP TABLE [OrderStatus];

IF EXISTS(Select * From sys.tables
WHERE NAME = N'Shipper')
DROP TABLE [Shipper];

IF EXISTS(Select * From sys.tables
WHERE NAME = N'Customer')
DROP TABLE [Customer];

IF EXISTS(Select * From sys.tables
WHERE NAME = N'EmployeeRole')
DROP TABLE [EmployeeRole];

IF EXISTS(Select * From sys.tables
WHERE NAME = N'EmployeePII')
DROP TABLE [EmployeePII];

IF EXISTS(Select * From sys.tables
WHERE NAME = N'Employee')
DROP TABLE [Employee];

IF EXISTS(Select * From sys.tables
WHERE NAME = N'Product')
DROP TABLE [Product];

IF EXISTS(Select * From sys.tables
WHERE NAME = N'Supplier')
DROP TABLE [Supplier];

IF EXISTS(Select * From sys.tables
WHERE NAME = N'Product')
DROP TABLE [Product];

IF EXISTS(Select * From sys.tables
WHERE NAME = N'State')
DROP TABLE [State];

IF EXISTS(Select * From sys.tables
WHERE NAME = N'Role')
DROP TABLE [Role];

IF EXISTS(Select * From sys.tables
WHERE NAME = N'ProductCategory')
DROP TABLE [ProductCategory];

--Create Tables
--Create ProductCategory Table
CREATE TABLE ProductCategory (
    ProductCategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(255)
);

-- Create Role Table
CREATE TABLE [Role] (
    RoleID INT PRIMARY KEY,
    Title VARCHAR(255),
    Salary MONEY,
    Commission DECIMAL(10, 2)
);

-- Create State Table
CREATE TABLE [State] (
    StateID INT PRIMARY KEY,
    StateAbbreviation CHAR(2),
    StateName VARCHAR(255)
);

-- Create Supplier Table
CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY,
    CompanyName VARCHAR(255),
    StateID INT,
    Street1 VARCHAR(255),
    Street2 VARCHAR(255),
    City VARCHAR(255),
    PostalCode VARCHAR(20),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    FOREIGN KEY (StateID) REFERENCES [State](StateID)
);

-- Create Product Table
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255),
    ProductCategoryID INT,
    UnitPrice MONEY,
    UnitCost MONEY,
    SupplierID INT,
    FOREIGN KEY (ProductCategoryID) REFERENCES ProductCategory(ProductCategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

-- Create Employee Table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    StateID INT,
    Street1 VARCHAR(255),
    Street2 VARCHAR(255),
    City VARCHAR(255),
    PostalCode VARCHAR(20),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    FOREIGN KEY (StateID) REFERENCES [State](StateID)
);

-- Create EmployeePII Table
CREATE TABLE EmployeePII (
    EmployeeID INT PRIMARY KEY,
    SSN CHAR(11),
    DOB DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);


-- Create EmployeeRole Table
CREATE TABLE EmployeeRole (
    EmployeeRoleID INT PRIMARY KEY,
    EmployeeID INT,
    RoleID INT,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (RoleID) REFERENCES Role(RoleID)
);

-- Create Customer Table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    StateID INT,
    Street1 VARCHAR(255),
    Street2 VARCHAR(255),
    City VARCHAR(255),
    PostalCode VARCHAR(20),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    FOREIGN KEY (StateID) REFERENCES [State](StateID)
);


-- Create Shipper Table
CREATE TABLE Shipper (
    ShipperID INT PRIMARY KEY,
    CompanyName VARCHAR(255),
    ShippingCostPerPound MONEY,
    StateID INT,
    Street1 VARCHAR(255),
    Street2 VARCHAR(255),
    City VARCHAR(255),
    PostalCode VARCHAR(20),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    FOREIGN KEY (StateID) REFERENCES [State](StateID)
);

-- Create OrderStatus Table
CREATE TABLE OrderStatus (
    OrderStatusID INT PRIMARY KEY,
    Status VARCHAR(255)
);


-- Create Order Table
CREATE TABLE [Order] (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    EmployeeID INT,
    OrderDate DATE,
    OrderStatusID INT,
    Preorder BIT,
    RequestedShipDate DATE,
    Street1 VARCHAR(255),
    Street2 VARCHAR(255),
    City VARCHAR(255),
    PostalCode VARCHAR(20),
    StateID INT,
	Email VARCHAR(100),
	Phone VARCHAR(20),
    ShipperID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (OrderStatusID) REFERENCES OrderStatus(OrderStatusID),
    FOREIGN KEY (StateID) REFERENCES State(StateID),
    FOREIGN KEY (ShipperID) REFERENCES Shipper(ShipperID)
);


-- Create OrderLineItem Table
CREATE TABLE OrderLineItem (
    OrderLineItemID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    ShipDate DATE,
    FOREIGN KEY (OrderID) REFERENCES [Order](OrderID),
    FOREIGN KEY (ProductID) REFERENCES [Product](ProductID)
);

--Load external data
--Bulk insert data into each table
--Code is based off the BuildCoffeeMerchant file used in class

DECLARE @data_path NVARCHAR(256);
SELECT @data_path = 'C:\Users\indym\OneDrive - University of Denver\Desktop\SQL\Project\';

EXECUTE (N'BULK INSERT ProductCategory FROM ''' + @data_path + N'ProductCategory.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    KEEPIDENTITY,
    TABLOCK
);');

EXECUTE (N'BULK INSERT [Role] FROM ''' + @data_path + N'Role.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    KEEPIDENTITY,
    TABLOCK
);');

EXECUTE (N'BULK INSERT [State] FROM ''' + @data_path + N'State.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    KEEPIDENTITY,
    TABLOCK
);');

EXECUTE (N'BULK INSERT Supplier FROM ''' + @data_path + N'Supplier.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    KEEPIDENTITY,
    TABLOCK
);');

EXECUTE (N'BULK INSERT Product FROM ''' + @data_path + N'Product.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    KEEPIDENTITY,
    TABLOCK
);');

EXECUTE (N'BULK INSERT Employee FROM ''' + @data_path + N'Employee.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    KEEPIDENTITY,
    TABLOCK
);');

EXECUTE (N'BULK INSERT EmployeePII FROM ''' + @data_path + N'EmployeePII.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    KEEPIDENTITY,
    TABLOCK
);');

EXECUTE (N'BULK INSERT EmployeeRole FROM ''' + @data_path + N'EmployeeRole.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    KEEPIDENTITY,
    TABLOCK
);');

EXECUTE (N'BULK INSERT Customer FROM ''' + @data_path + N'Customer.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    KEEPIDENTITY,
    TABLOCK
);');

EXECUTE (N'BULK INSERT Shipper FROM ''' + @data_path + N'Shipper.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    KEEPIDENTITY,
    TABLOCK
);');

EXECUTE (N'BULK INSERT OrderStatus FROM ''' + @data_path + N'OrderStatus.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    KEEPIDENTITY,
    TABLOCK
);');

EXECUTE (N'BULK INSERT [Order] FROM ''' + @data_path + N'Order.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    KEEPIDENTITY,
    TABLOCK
);');

EXECUTE (N'BULK INSERT OrderLineItem FROM ''' + @data_path + N'OrderLineItem.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    KEEPIDENTITY,
    TABLOCK
);');


-- See summary of database to check if bulk upload was successful
SELECT 
	s.name AS SchemaName, 
	t.name AS TableName, 
	SUM(p.rows) AS TableRowCount
FROM sys.schemas AS s
	JOIN sys.tables AS t ON t.schema_id = s.schema_id
	JOIN sys.partitions AS p ON p.object_id = t.object_id
WHERE p.index_id IN (1, 0)
GROUP BY s.name, t.name
ORDER BY SchemaName, TableName;

-- Drop the view if it already exists
DROP VIEW IF EXISTS dbo.vw_OrderDetails;
GO

-- Drop the function if it already exists
DROP FUNCTION IF EXISTS dbo.fn_GetOrderTotal;
GO

-- Drop the stored procedure if it already exists
DROP PROCEDURE IF EXISTS dbo.sp_GetOrderSummary;
GO

-- Create a view to get detailed order information
-- This view joins orders, customers, and shippers to provide order details along with customer and shipping information
CREATE VIEW vw_OrderDetails AS
SELECT 
    o.OrderID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.OrderDate,
    o.RequestedShipDate,
    s.CompanyName AS ShipperName,
    o.Street1, o.Street2, o.City, o.StateID, o.PostalCode
FROM [Order] o
JOIN Customer c ON o.CustomerID = c.CustomerID
JOIN Shipper s ON o.ShipperID = s.ShipperID;
GO

-- Create a function to calculate the total order cost for a given order
-- This function takes an OrderID and returns the total cost for that order
CREATE FUNCTION fn_GetOrderTotal(@OrderID INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @Total MONEY;
    SELECT @Total = SUM(p.UnitPrice * oli.Quantity)
    FROM OrderLineItem oli
    JOIN Product p ON oli.ProductID = p.ProductID
    WHERE oli.OrderID = @OrderID;
    RETURN @Total;
END;
GO

-- Create a stored procedure to get order details and total cost
-- This procedure takes an OrderID and returns the order details and total cost
CREATE PROCEDURE sp_GetOrderSummary
    @OrderID INT
AS
BEGIN
    SELECT 
        o.OrderID,
        c.FirstName + ' ' + c.LastName AS CustomerName,
        o.OrderDate,
        o.RequestedShipDate,
        s.CompanyName AS ShipperName,
        dbo.fn_GetOrderTotal(@OrderID) AS TotalOrderCost
    FROM [Order] o
    JOIN Customer c ON o.CustomerID = c.CustomerID
    JOIN Shipper s ON o.ShipperID = s.ShipperID
    WHERE o.OrderID = @OrderID;
END;
GO

-- Execute the view, function, and stored procedure for testing
-- Execute the view to get all order details
SELECT * FROM vw_OrderDetails;

-- Execute the function to get the total cost for a specific order (example: OrderID = 1)
SELECT dbo.fn_GetOrderTotal(1) AS OrderTotal;

-- Execute the stored procedure to get the summary for a specific order (example: OrderID = 1)
EXEC sp_GetOrderSummary @OrderID = 1;