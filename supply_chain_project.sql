
-- ===============================
-- Supply Chain Project (MySQL)
-- Schema + Sample Data + 10 Queries
-- ===============================

-- Recreate database so the script is idempotent
DROP DATABASE IF EXISTS supply_chain;
CREATE DATABASE supply_chain;
USE supply_chain;

-- -------------------------------
-- 1) TABLES
-- -------------------------------

CREATE TABLE Supplier (
    Id INT PRIMARY KEY,
    CompanyName VARCHAR(40),
    ContactName VARCHAR(50),
    ContactTitle VARCHAR(40),
    City VARCHAR(40),
    Country VARCHAR(40),
    Phone VARCHAR(30),
    Fax VARCHAR(30)
) ENGINE=InnoDB;

CREATE TABLE Product (
    Id INT PRIMARY KEY,
    ProductName VARCHAR(50),
    SupplierId INT,
    UnitPrice DECIMAL(12,2),
    Package VARCHAR(30),
    IsDiscontinued BIT,
    CONSTRAINT fk_product_supplier
        FOREIGN KEY (SupplierId) REFERENCES Supplier(Id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Customer (
    Id INT PRIMARY KEY,
    FirstName VARCHAR(40),
    LastName VARCHAR(40),
    City VARCHAR(40),
    Country VARCHAR(40),
    Phone VARCHAR(20)
) ENGINE=InnoDB;

CREATE TABLE Orders (
    Id INT PRIMARY KEY,
    OrderDate DATETIME,
    ShippingNumber VARCHAR(10),
    CustomerId INT,
    TotalAmount DECIMAL(12,2),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (CustomerId) REFERENCES Customer(Id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE OrderItem (
    Id INT PRIMARY KEY,
    OrderId INT,
    ProductId INT,
    UnitPrice DECIMAL(12,2),
    Quantity INT,
    CONSTRAINT fk_oi_order
        FOREIGN KEY (OrderId) REFERENCES Orders(Id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_oi_product
        FOREIGN KEY (ProductId) REFERENCES Product(Id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- -------------------------------
-- 2) SAMPLE DATA (small but realistic)
--    You can replace/extend this with your real data later.
-- -------------------------------

-- Suppliers
INSERT INTO Supplier (Id, CompanyName, ContactName, ContactTitle, City, Country, Phone, Fax) VALUES
(1, 'FreshFoods Ltd',   'Alice Smith',  'Manager', 'London',    'UK',        '020-111-1111', '020-111-1110'),
(2, 'Nordic Seafoods',  'Erik Larsen',  'Sales',   'Oslo',      'Norway',    '047-222-2222', '047-222-2221'),
(3, 'Iberia Spices',    'Maria Garcia', 'Owner',   'Madrid',    'Spain',     '034-333-3333', '034-333-3332'),
(4, 'Baltic Grains',    'Jonas Petra',  'Director','Vilnius',   'Lithuania', '370-444-4444', '370-444-4443'),
(5, 'Andes Produce',    'Carla Ruiz',   'Manager', 'Lima',      'Peru',      '051-555-5555', '051-555-5554');

-- Products
INSERT INTO Product (Id, ProductName, SupplierId, UnitPrice, Package, IsDiscontinued) VALUES
(1, 'Organic Apples',     1, 2.50, 'Box of 10', 0),
(2, 'Atlantic Salmon',    2,12.00, '1kg pack',  0),
(3, 'Smoked Paprika',     3, 3.20, '100g jar',  0),
(4, 'Rye Flour',          4, 1.80, '1kg bag',   0),
(5, 'Quinoa',             5, 4.50, '500g pack', 0),
(6, 'Cheddar Cheese',     1, 5.00, '250g',      0),
(7, 'Sardines',           2, 2.00, 'Tin',       0),
(8, 'Olive Oil',          3, 8.00, '1L',        0);

-- Customers
INSERT INTO Customer (Id, FirstName, LastName, City, Country, Phone) VALUES
(1, 'John',  'Doe',     'Birmingham', 'UK',     '070-101-0101'),
(2, 'Priya', 'Patel',   'London',     'UK',     '070-202-0202'),
(3, 'Hans',  'Muller',  'Berlin',     'Germany','049-303-0303'),
(4, 'Emma',  'Stone',   'New York',   'USA',    '001-404-0404'),
(5, 'Liam',  'O''Connor','Dublin',    'Ireland','353-505-0505');

-- Orders (TotalAmount matches the sum of their items below)
INSERT INTO Orders (Id, OrderDate, ShippingNumber, CustomerId, TotalAmount) VALUES
(1, '2024-01-15', 'SH10001', 1, 25.00),
(2, '2024-02-03', 'SH10002', 2, 40.50),
(3, '2024-02-20', 'SH10003', 3, 20.40),
(4, '2024-03-05', 'SH10004', 1, 23.20),
(5, '2024-03-28', 'SH10005', 4, 30.40),
(6, '2024-04-10', 'SH10006', 5, 24.00),
(7, '2024-04-22', 'SH10007', 2, 24.60);

-- Order Items
INSERT INTO OrderItem (Id, OrderId, ProductId, UnitPrice, Quantity) VALUES
-- Order 1 (John UK): Apples
(1, 1, 1, 2.50, 10),
-- Order 2 (Priya UK): Salmon (discount), Olive Oil (discount)
(2, 2, 2,11.00,  3),
(3, 2, 8, 7.50,  1),
-- Order 3 (Hans DE): Rye Flour, Sardines (discount)
(4, 3, 4, 1.80,  5),
(5, 3, 7, 1.90,  6),
-- Order 4 (John UK): Quinoa (discount), Smoked Paprika
(6, 4, 5, 4.20,  4),
(7, 4, 3, 3.20,  2),
-- Order 5 (Emma USA): Olive Oil, Cheddar (discount)
(8, 5, 8, 8.00,  2),
(9, 5, 6, 4.80,  3),
-- Order 6 (Liam IE): Salmon, Apples (discount)
(10,6, 2,12.00,  1),
(11,6, 1, 2.40,  5),
-- Order 7 (Priya UK): Sardines (discount), Paprika (discount)
(12,7, 7, 1.80, 12),
(13,7, 3, 3.00,  1);

-- -------------------------------
-- 3) PRACTICE QUERIES
-- -------------------------------

-- Q1. Lowest and highest order dates
SELECT MIN(OrderDate) AS LowestDate, MAX(OrderDate) AS HighestDate
FROM Orders;

-- Q2. Customers who did not place any orders
SELECT c.Id, c.FirstName, c.LastName, c.Country
FROM Customer c
LEFT JOIN Orders o ON o.CustomerId = c.Id
WHERE o.Id IS NULL;

-- Q3. Customer who placed the largest single order (by order TotalAmount)
SELECT c.Id, CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, o.Id AS OrderId, o.TotalAmount
FROM Orders o
JOIN Customer c ON c.Id = o.CustomerId
ORDER BY o.TotalAmount DESC
LIMIT 1;

-- Q4. Top 5 customers by total amount spent (sum of their orders)
SELECT c.Id,
       CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       SUM(o.TotalAmount) AS TotalSpent
FROM Customer c
JOIN Orders o ON o.CustomerId = c.Id
GROUP BY c.Id, CustomerName
ORDER BY TotalSpent DESC
LIMIT 5;

-- Q5. Top 3 suppliers by revenue generated (sum of order item price * qty)
SELECT s.Id, s.CompanyName,
       SUM(oi.UnitPrice * oi.Quantity) AS Revenue
FROM Supplier s
JOIN Product p ON p.SupplierId = s.Id
JOIN OrderItem oi ON oi.ProductId = p.Id
GROUP BY s.Id, s.CompanyName
ORDER BY Revenue DESC
LIMIT 3;

-- Q6. Combined list of customers and suppliers
-- TYPE ('CUSTOMER'/'SUPPLIER'), ContactName, City, Country, Phone
SELECT 'CUSTOMER' AS Type,
       CONCAT(c.FirstName, ' ', c.LastName) AS ContactName,
       c.City, c.Country, c.Phone
FROM Customer c
UNION ALL
SELECT 'SUPPLIER' AS Type, s.ContactName, s.City, s.Country, s.Phone
FROM Supplier s;

-- Q7. Customers who ordered more than 10 different products in a single order
SELECT o.Id AS OrderId,
       CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       COUNT(DISTINCT oi.ProductId) AS DistinctProducts
FROM Orders o
JOIN Customer c ON c.Id = o.CustomerId
JOIN OrderItem oi ON oi.OrderId = o.Id
GROUP BY o.Id, CustomerName
HAVING COUNT(DISTINCT oi.ProductId) > 10;

-- Q8. Total amount saved in each order (list price - selling price)
-- list price = Product.UnitPrice, selling price = OrderItem.UnitPrice
SELECT o.Id AS OrderId,
       ROUND(SUM( (p.UnitPrice - oi.UnitPrice) * oi.Quantity ), 2) AS TotalSaved
FROM Orders o
JOIN OrderItem oi ON oi.OrderId = o.Id
JOIN Product p ON p.Id = oi.ProductId
GROUP BY o.Id
HAVING TotalSaved > 0
ORDER BY TotalSaved DESC;

-- Q9. Suppliers such that there are NO customers in the supplier's country
SELECT s.Id, s.CompanyName, s.Country
FROM Supplier s
WHERE NOT EXISTS (
   SELECT 1 FROM Customer c WHERE c.Country = s.Country
)
ORDER BY s.Country;

-- Q10. Products for which the UK is dependent on other countries for supply.
-- (Products ordered by UK customers whose supplier is NOT in the UK)
SELECT DISTINCT p.ProductName,
       s.Country AS SupplierCountry
FROM Orders o
JOIN Customer c ON c.Id = o.CustomerId
JOIN OrderItem oi ON oi.OrderId = o.Id
JOIN Product p ON p.Id = oi.ProductId
JOIN Supplier s ON s.Id = p.SupplierId
WHERE c.Country = 'UK'
  AND s.Country <> 'UK'
ORDER BY p.ProductName, SupplierCountry;
