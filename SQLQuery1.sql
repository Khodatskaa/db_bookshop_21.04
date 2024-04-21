CREATE DATABASE [db_bookshop_triggers]
GO
USE [db_bookshop_triggers]
GO

CREATE TABLE Countries (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Shops (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(MAX) NOT NULL,
    CountryId INT NOT NULL
);

CREATE TABLE Themes (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Authors (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(MAX) NOT NULL,
    Surname NVARCHAR(MAX) NOT NULL,
    CountryId INT NOT NULL
);

CREATE TABLE Books (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL UNIQUE,
    Pages INT NOT NULL CHECK (Pages > 0),
    Price MONEY NOT NULL CHECK (Price >= 0),
    PublishDate DATE NOT NULL CHECK (PublishDate <= GETDATE()), 
    AuthorId INT NOT NULL,
    ThemeId INT NOT NULL
);

CREATE TABLE Sales (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Price MONEY NOT NULL CHECK (Price >= 0),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    SaleDate DATE NOT NULL DEFAULT GETDATE() CHECK (SaleDate <= GETDATE()), 
    BookId INT NOT NULL,
    ShopId INT NOT NULL
);

-- Trigger for enforcing PublishDate constraint on the Books table
GO
CREATE TRIGGER trg_Books_PublishDate_Insert
ON Books
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;   --

    IF EXISTS (SELECT 1 FROM inserted WHERE PublishDate > GETDATE())
    BEGIN
        RAISERROR('PublishDate cannot be in the future.', 16, 1);
        ROLLBACK;
    END;
END;
GO

-- Trigger for enforcing SaleDate constraint on the Sales table
GO
CREATE TRIGGER trg_Sales_SaleDate_Insert
ON Sales
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE SaleDate > GETDATE())
    BEGIN
        RAISERROR('SaleDate cannot be in the future.', 16, 1);
        ROLLBACK;
    END;
END;
GO

-- Trigger for enforcing non-empty Name constraint on the Countries table
GO
CREATE TRIGGER trg_Countries_Name_Insert
ON Countries
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE Name = '')
    BEGIN
        RAISERROR('Country name cannot be empty.', 16, 1);
        ROLLBACK;
    END;
END;
GO

-- Trigger for enforcing non-empty Name constraint on the Themes table
GO
CREATE TRIGGER trg_Themes_Name_Insert
ON Themes
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE Name = '')
    BEGIN
        RAISERROR('Theme name cannot be empty.', 16, 1);
        ROLLBACK;
    END;
END;
GO

-- Trigger for enforcing non-empty Name and Surname constraint on the Authors table
GO
CREATE TRIGGER trg_Authors_NameSurname_Insert
ON Authors
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE Name = '' OR Surname = '')
    BEGIN
        RAISERROR('Name and Surname cannot be empty.', 16, 1);
        ROLLBACK;
    END;
END;
GO