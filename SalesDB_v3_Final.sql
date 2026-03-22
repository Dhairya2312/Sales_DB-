-- ============================================================
--  SalesDB - Complete SQL Server Database Script (FIXED)
--  Tables: Customers, Products, Orders, OrderDetails
--  200+ rows of realistic sales data
--  20 Advanced Analytics Queries
-- ============================================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SalesDB')
BEGIN
    ALTER DATABASE SalesDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SalesDB;
END
GO

CREATE DATABASE SalesDB;
GO

USE SalesDB;
GO

-- ============================================================
--  SECTION 1: TABLE CREATION WITH RELATIONSHIPS
-- ============================================================

CREATE TABLE Customers (
    CustomerID      INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName    NVARCHAR(100)   NOT NULL,
    Email           NVARCHAR(150)   UNIQUE NOT NULL,
    Phone           NVARCHAR(20),
    City            NVARCHAR(60)    NOT NULL,
    State           NVARCHAR(60)    NOT NULL,
    Region          NVARCHAR(30)    NOT NULL,
    Country         NVARCHAR(50)    NOT NULL DEFAULT 'India',
    Segment         NVARCHAR(30)    NOT NULL,
    JoinDate        DATE            NOT NULL,
    IsActive        BIT             NOT NULL DEFAULT 1
);
GO

CREATE TABLE Products (
    ProductID       INT IDENTITY(1,1) PRIMARY KEY,
    ProductName     NVARCHAR(150)   NOT NULL,
    Category        NVARCHAR(60)    NOT NULL,
    SubCategory     NVARCHAR(60)    NOT NULL,
    Brand           NVARCHAR(80),
    UnitPrice       DECIMAL(10,2)   NOT NULL,
    CostPrice       DECIMAL(10,2)   NOT NULL,
    StockQuantity   INT             NOT NULL DEFAULT 0,
    IsActive        BIT             NOT NULL DEFAULT 1
);
GO

CREATE TABLE Orders (
    OrderID         INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID      INT             NOT NULL,
    OrderDate       DATE            NOT NULL,
    ShipDate        DATE,
    Status          NVARCHAR(20)    NOT NULL DEFAULT 'Pending',
    ShipMode        NVARCHAR(30),
    PaymentMode     NVARCHAR(30),
    Discount        DECIMAL(5,2)    NOT NULL DEFAULT 0.00,
    TaxRate         DECIMAL(5,2)    NOT NULL DEFAULT 18.00,
    ShippingCost    DECIMAL(8,2)    NOT NULL DEFAULT 0.00,
    Notes           NVARCHAR(300),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
GO

CREATE TABLE OrderDetails (
    OrderDetailID   INT IDENTITY(1,1) PRIMARY KEY,
    OrderID         INT             NOT NULL,
    ProductID       INT             NOT NULL,
    Quantity        INT             NOT NULL,
    UnitPrice       DECIMAL(10,2)   NOT NULL,
    Discount        DECIMAL(5,2)    NOT NULL DEFAULT 0.00,
    CONSTRAINT FK_OrderDetails_Orders   FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT CHK_Quantity     CHECK (Quantity > 0),
    CONSTRAINT CHK_UnitPrice    CHECK (UnitPrice >= 0),
    CONSTRAINT CHK_Discount     CHECK (Discount >= 0 AND Discount <= 100)
);
GO

CREATE INDEX IX_Orders_CustomerID      ON Orders(CustomerID);
CREATE INDEX IX_Orders_OrderDate       ON Orders(OrderDate);
CREATE INDEX IX_Orders_Status          ON Orders(Status);
CREATE INDEX IX_OrderDetails_OrderID   ON OrderDetails(OrderID);
CREATE INDEX IX_OrderDetails_ProductID ON OrderDetails(ProductID);
CREATE INDEX IX_Products_Category      ON Products(Category);
CREATE INDEX IX_Customers_Region       ON Customers(Region);
CREATE INDEX IX_Customers_Segment      ON Customers(Segment);
GO

-- ============================================================
--  SECTION 2: CUSTOMERS (50 rows)
-- ============================================================

INSERT INTO Customers (CustomerName, Email, Phone, City, State, Region, Country, Segment, JoinDate) VALUES
-- North
('Rajesh Kumar',        'rajesh.kumar@gmail.com',        '9811001001', 'Delhi',             'Delhi',           'North',   'India', 'Corporate',     '2021-03-15'),
('Priya Sharma',        'priya.sharma@outlook.com',      '9811001002', 'Chandigarh',        'Punjab',          'North',   'India', 'Consumer',      '2021-07-22'),
('Amit Singh',          'amit.singh@yahoo.com',          '9811001003', 'Jaipur',            'Rajasthan',       'North',   'India', 'Small Business','2020-11-10'),
('Neha Verma',          'neha.verma@gmail.com',          '9811001004', 'Lucknow',           'Uttar Pradesh',   'North',   'India', 'Consumer',      '2022-01-05'),
('Vikas Gupta',         'vikas.gupta@rediffmail.com',    '9811001005', 'Agra',              'Uttar Pradesh',   'North',   'India', 'Enterprise',    '2020-06-30'),
('Sunita Yadav',        'sunita.yadav@gmail.com',        '9811001006', 'Kanpur',            'Uttar Pradesh',   'North',   'India', 'Consumer',      '2021-09-14'),
('Rohit Mehta',         'rohit.mehta@hotmail.com',       '9811001007', 'Amritsar',          'Punjab',          'North',   'India', 'Small Business','2022-04-20'),
('Kavita Joshi',        'kavita.joshi@gmail.com',        '9811001008', 'Dehradun',          'Uttarakhand',     'North',   'India', 'Corporate',     '2021-12-01'),
('Deepak Tiwari',       'deepak.tiwari@gmail.com',       '9811001009', 'Varanasi',          'Uttar Pradesh',   'North',   'India', 'Consumer',      '2022-08-19'),
('Pooja Agarwal',       'pooja.agarwal@outlook.com',     '9811001010', 'Meerut',            'Uttar Pradesh',   'North',   'India', 'Enterprise',    '2020-03-25'),
-- South
('Arjun Nair',          'arjun.nair@gmail.com',          '9822001001', 'Chennai',           'Tamil Nadu',      'South',   'India', 'Corporate',     '2021-05-10'),
('Divya Menon',         'divya.menon@gmail.com',         '9822001002', 'Kochi',             'Kerala',          'South',   'India', 'Consumer',      '2020-09-17'),
('Suresh Reddy',        'suresh.reddy@yahoo.com',        '9822001003', 'Hyderabad',         'Telangana',       'South',   'India', 'Enterprise',    '2021-02-28'),
('Lakshmi Iyer',        'lakshmi.iyer@gmail.com',        '9822001004', 'Bengaluru',         'Karnataka',       'South',   'India', 'Small Business','2022-06-11'),
('Karthik Pillai',      'karthik.pillai@hotmail.com',    '9822001005', 'Coimbatore',        'Tamil Nadu',      'South',   'India', 'Consumer',      '2021-10-03'),
('Anusha Rao',          'anusha.rao@gmail.com',          '9822001006', 'Visakhapatnam',     'Andhra Pradesh',  'South',   'India', 'Corporate',     '2020-12-22'),
('Venkat Krishnan',     'venkat.krishnan@rediff.com',    '9822001007', 'Madurai',           'Tamil Nadu',      'South',   'India', 'Consumer',      '2022-03-08'),
('Meena Subramanian',   'meena.subramanian@gmail.com',   '9822001008', 'Thiruvananthapuram','Kerala',          'South',   'India', 'Small Business','2021-07-16'),
('Prasad Desai',        'prasad.desai@gmail.com',        '9822001009', 'Mysuru',            'Karnataka',       'South',   'India', 'Enterprise',    '2020-05-04'),
('Geetha Balachandran', 'geetha.b@outlook.com',          '9822001010', 'Puducherry',        'Puducherry',      'South',   'India', 'Consumer',      '2022-09-29'),
-- East
('Sanjay Ghosh',        'sanjay.ghosh@gmail.com',        '9833001001', 'Kolkata',           'West Bengal',     'East',    'India', 'Corporate',     '2021-01-14'),
('Rina Chatterjee',     'rina.chatterjee@yahoo.com',     '9833001002', 'Bhubaneswar',       'Odisha',          'East',    'India', 'Consumer',      '2020-08-07'),
('Manish Panda',        'manish.panda@gmail.com',        '9833001003', 'Patna',             'Bihar',           'East',    'India', 'Small Business','2022-02-18'),
('Priyanka Das',        'priyanka.das@hotmail.com',      '9833001004', 'Guwahati',          'Assam',           'East',    'India', 'Consumer',      '2021-11-25'),
('Sourav Mondal',       'sourav.mondal@gmail.com',       '9833001005', 'Kolkata',           'West Bengal',     'East',    'India', 'Enterprise',    '2020-04-13'),
('Ananya Sen',          'ananya.sen@outlook.com',        '9833001006', 'Durgapur',          'West Bengal',     'East',    'India', 'Consumer',      '2022-07-31'),
('Bikash Roy',          'bikash.roy@gmail.com',          '9833001007', 'Ranchi',            'Jharkhand',       'East',    'India', 'Small Business','2021-04-09'),
('Tanmoy Datta',        'tanmoy.datta@rediff.com',       '9833001008', 'Siliguri',          'West Bengal',     'East',    'India', 'Corporate',     '2020-10-02'),
('Shreya Bose',         'shreya.bose@gmail.com',         '9833001009', 'Agartala',          'Tripura',         'East',    'India', 'Consumer',      '2022-05-17'),
('Debashish Nayak',     'debashish.nayak@gmail.com',     '9833001010', 'Cuttack',           'Odisha',          'East',    'India', 'Enterprise',    '2021-08-23'),
-- West
('Rahul Shah',          'rahul.shah@gmail.com',          '9844001001', 'Mumbai',            'Maharashtra',     'West',    'India', 'Enterprise',    '2021-02-11'),
('Nisha Patel',         'nisha.patel@outlook.com',       '9844001002', 'Ahmedabad',         'Gujarat',         'West',    'India', 'Corporate',     '2020-07-19'),
('Hardik Jain',         'hardik.jain@gmail.com',         '9844001003', 'Surat',             'Gujarat',         'West',    'India', 'Small Business','2021-06-06'),
('Riya Desai',          'riya.desai@yahoo.com',          '9844001004', 'Pune',              'Maharashtra',     'West',    'India', 'Consumer',      '2022-01-27'),
('Mihir Bhatt',         'mihir.bhatt@gmail.com',         '9844001005', 'Vadodara',          'Gujarat',         'West',    'India', 'Corporate',     '2020-11-15'),
('Foram Trivedi',       'foram.trivedi@hotmail.com',     '9844001006', 'Rajkot',            'Gujarat',         'West',    'India', 'Consumer',      '2022-10-08'),
('Akash Parekh',        'akash.parekh@gmail.com',        '9844001007', 'Nashik',            'Maharashtra',     'West',    'India', 'Small Business','2021-03-21'),
('Komal Mehta',         'komal.mehta@gmail.com',         '9844001008', 'Mumbai',            'Maharashtra',     'West',    'India', 'Enterprise',    '2020-09-30'),
('Dhaval Modi',         'dhaval.modi@outlook.com',       '9844001009', 'Bhavnagar',         'Gujarat',         'West',    'India', 'Consumer',      '2022-06-14'),
('Smita Kulkarni',      'smita.kulkarni@gmail.com',      '9844001010', 'Aurangabad',        'Maharashtra',     'West',    'India', 'Corporate',     '2021-12-09'),
-- Central
('Ramesh Dubey',        'ramesh.dubey@gmail.com',        '9855001001', 'Bhopal',            'Madhya Pradesh',  'Central', 'India', 'Corporate',     '2021-04-05'),
('Anita Mishra',        'anita.mishra@yahoo.com',        '9855001002', 'Indore',            'Madhya Pradesh',  'Central', 'India', 'Small Business','2020-08-21'),
('Lokesh Shukla',       'lokesh.shukla@gmail.com',       '9855001003', 'Raipur',            'Chhattisgarh',    'Central', 'India', 'Consumer',      '2022-02-14'),
('Mamta Pandey',        'mamta.pandey@hotmail.com',      '9855001004', 'Jabalpur',          'Madhya Pradesh',  'Central', 'India', 'Enterprise',    '2021-09-07'),
('Sunil Pathak',        'sunil.pathak@gmail.com',        '9855001005', 'Gwalior',           'Madhya Pradesh',  'Central', 'India', 'Consumer',      '2020-12-03'),
('Rekha Soni',          'rekha.soni@outlook.com',        '9855001006', 'Ujjain',            'Madhya Pradesh',  'Central', 'India', 'Small Business','2022-07-18'),
('Pankaj Chouhan',      'pankaj.chouhan@gmail.com',      '9855001007', 'Bilaspur',          'Chhattisgarh',    'Central', 'India', 'Consumer',      '2021-10-26'),
('Geeta Rawat',         'geeta.rawat@rediff.com',        '9855001008', 'Rewa',              'Madhya Pradesh',  'Central', 'India', 'Corporate',     '2020-06-12'),
('Dinesh Bajpai',       'dinesh.bajpai@gmail.com',       '9855001009', 'Satna',             'Madhya Pradesh',  'Central', 'India', 'Enterprise',    '2022-03-29'),
('Usha Tripathi',       'usha.tripathi@outlook.com',     '9855001010', 'Korba',             'Chhattisgarh',    'Central', 'India', 'Consumer',      '2021-06-20');
GO

-- ============================================================
--  SECTION 3: PRODUCTS (40 rows)
--  FIX: All apostrophes use '' (double single-quote), not \'
-- ============================================================

INSERT INTO Products (ProductName, Category, SubCategory, Brand, UnitPrice, CostPrice, StockQuantity) VALUES
-- Electronics
('Apple iPhone 15',              'Electronics',     'Smartphones',  'Apple',      79999.00, 65000.00, 150),
('Samsung Galaxy S24',           'Electronics',     'Smartphones',  'Samsung',    74999.00, 58000.00, 120),
('OnePlus 12',                   'Electronics',     'Smartphones',  'OnePlus',    64999.00, 50000.00, 200),
('Dell Inspiron 15 Laptop',      'Electronics',     'Laptops',      'Dell',       55999.00, 43000.00,  80),
('HP Pavilion Laptop',           'Electronics',     'Laptops',      'HP',         49999.00, 38500.00,  90),
('Lenovo ThinkPad E14',          'Electronics',     'Laptops',      'Lenovo',     58999.00, 46000.00,  75),
('Sony WH-1000XM5 Headphones',   'Electronics',     'Audio',        'Sony',       29999.00, 20000.00, 300),
('boAt Rockerz 450',             'Electronics',     'Audio',        'boAt',        1499.00,   800.00,1000),
('LG 43 inch Smart TV',          'Electronics',     'Televisions',  'LG',         32999.00, 25000.00,  60),
('Samsung 55 inch QLED TV',      'Electronics',     'Televisions',  'Samsung',    59999.00, 45000.00,  40),
-- Furniture
('Ergonomic Office Chair',       'Furniture',       'Chairs',       'Featherlite',12999.00,  8500.00, 200),
('Executive Desk',               'Furniture',       'Desks',        'Godrej',     18999.00, 13000.00,  80),
('Bookshelf 5 Tier',             'Furniture',       'Storage',      'Durian',      6499.00,  4200.00, 150),
('L-Shaped Corner Desk',         'Furniture',       'Desks',        'Featherlite',22999.00, 16000.00,  50),
('3-Seater Sofa',                'Furniture',       'Sofas',        'HomeTown',   24999.00, 18000.00,  40),
('Queen Size Bed Frame',         'Furniture',       'Beds',         'Durian',     19999.00, 14500.00,  35),
-- Office Supplies
('Canon Printer PIXMA G3010',    'Office Supplies', 'Printers',     'Canon',      11999.00,  8500.00, 120),
('HP LaserJet M1005',            'Office Supplies', 'Printers',     'HP',         14999.00, 11000.00,  90),
('A4 Paper Ream 500 Sheets',     'Office Supplies', 'Stationery',   'JK Copier',    299.00,   180.00,5000),
('Blue Pen Box 10 Pcs',          'Office Supplies', 'Stationery',   'Reynolds',     199.00,   100.00,3000),
('Stapler Heavy Duty',           'Office Supplies', 'Stationery',   'Kangaro',      499.00,   280.00, 800),
('File Cabinet 4-Drawer',        'Office Supplies', 'Storage',      'Godrej',     14999.00, 10500.00,  60),
('Whiteboard 4x3 ft',            'Office Supplies', 'Boards',       'Bi-Office',   3499.00,  2100.00, 200),
('Projector Epson EB-X41',       'Office Supplies', 'AV Equipment', 'Epson',      32999.00, 25000.00,  30),
-- Clothing
-- FIX: "Men's" written as 'Mens Formal Shirt' — apostrophe removed to avoid syntax error
('Mens Formal Shirt',            'Clothing',        'Mens Wear',    'Arrow',       2499.00,  1400.00, 500),
('Womens Kurti Cotton',          'Clothing',        'Womens Wear',  'Biba',        1299.00,   700.00, 700),
('Mens Casual Jeans',            'Clothing',        'Mens Wear',    'Levis',       3499.00,  2100.00, 400),
('Sports Shoes Men',             'Clothing',        'Footwear',     'Nike',        6999.00,  4200.00, 350),
('Casual Sneakers Women',        'Clothing',        'Footwear',     'Adidas',      5999.00,  3600.00, 300),
('Winter Jacket Unisex',         'Clothing',        'Outerwear',    'Puma',        4999.00,  3000.00, 250),
-- Food & Beverage
('Tata Gold Tea 500g',           'Food & Beverage', 'Tea & Coffee', 'Tata',         399.00,   220.00,2000),
('Nescafe Classic 200g',         'Food & Beverage', 'Tea & Coffee', 'Nestle',       699.00,   420.00,1500),
('Basmati Rice 5kg',             'Food & Beverage', 'Grains',       'India Gate',   649.00,   420.00,3000),
('Amul Butter 500g',             'Food & Beverage', 'Dairy',        'Amul',         299.00,   190.00,4000),
('Fortune Sunflower Oil 5L',     'Food & Beverage', 'Cooking Oil',  'Fortune',      899.00,   620.00,2500),
('Britannia Good Day Biscuits',  'Food & Beverage', 'Snacks',       'Britannia',    149.00,    80.00,5000),
('Maggi Noodles 12 Pack',        'Food & Beverage', 'Instant Food', 'Nestle',       299.00,   180.00,4000),
-- FIX: "Lay's" written as 'Lays Chips Party Pack'
('Lays Chips Party Pack',        'Food & Beverage', 'Snacks',       'PepsiCo',      299.00,   160.00,3500),
('Himalaya Honey 500g',          'Food & Beverage', 'Health Food',  'Himalaya',     499.00,   300.00,1800),
('Organic Oats 1kg',             'Food & Beverage', 'Health Food',  'Quaker',       399.00,   230.00,2200);
GO

-- ============================================================
--  SECTION 4: ORDERS (116 rows)
-- ============================================================

INSERT INTO Orders (CustomerID, OrderDate, ShipDate, Status, ShipMode, PaymentMode, Discount, TaxRate, ShippingCost) VALUES
(1,  '2023-01-05', '2023-01-08', 'Delivered', 'Standard',    'Credit Card',  5.00, 18.00,  99.00),
(2,  '2023-01-12', '2023-01-14', 'Delivered', 'Express',     'UPI',          0.00, 18.00, 149.00),
(3,  '2023-01-18', '2023-01-21', 'Delivered', 'Standard',    'COD',          0.00, 18.00,  99.00),
(4,  '2023-01-25', '2023-01-27', 'Delivered', 'First Class', 'Net Banking', 10.00, 18.00, 199.00),
(5,  '2023-02-02', '2023-02-05', 'Delivered', 'Express',     'Credit Card',  0.00, 18.00, 149.00),
(6,  '2023-02-09', '2023-02-11', 'Delivered', 'Standard',    'UPI',          5.00, 18.00,  99.00),
(7,  '2023-02-15', '2023-02-18', 'Delivered', 'Standard',    'COD',          0.00, 18.00,  99.00),
(8,  '2023-02-22', '2023-02-25', 'Delivered', 'Express',     'Wallet',       0.00, 18.00, 149.00),
(9,  '2023-03-01', '2023-03-03', 'Delivered', 'Standard',    'UPI',          0.00, 18.00,  99.00),
(10, '2023-03-07', '2023-03-10', 'Delivered', 'First Class', 'Credit Card', 15.00, 18.00, 199.00),
(11, '2023-03-14', '2023-03-17', 'Delivered', 'Standard',    'Net Banking',  0.00, 18.00,  99.00),
(12, '2023-03-20', '2023-03-23', 'Delivered', 'Express',     'UPI',          5.00, 18.00, 149.00),
(13, '2023-03-27', '2023-03-30', 'Delivered', 'Standard',    'COD',          0.00, 18.00,  99.00),
(14, '2023-04-04', '2023-04-07', 'Delivered', 'Standard',    'Credit Card', 10.00, 18.00,  99.00),
(15, '2023-04-10', '2023-04-13', 'Delivered', 'Express',     'UPI',          0.00, 18.00, 149.00),
(16, '2023-04-17', '2023-04-20', 'Delivered', 'Standard',    'COD',          0.00, 18.00,  99.00),
(17, '2023-04-24', '2023-04-27', 'Delivered', 'First Class', 'Net Banking',  5.00, 18.00, 199.00),
(18, '2023-05-02', '2023-05-05', 'Delivered', 'Standard',    'UPI',          0.00, 18.00,  99.00),
(19, '2023-05-09', '2023-05-12', 'Delivered', 'Express',     'Credit Card',  0.00, 18.00, 149.00),
(20, '2023-05-16', '2023-05-19', 'Delivered', 'Standard',    'Wallet',      10.00, 18.00,  99.00),
(21, '2023-05-23', '2023-05-26', 'Delivered', 'Standard',    'UPI',          0.00, 18.00,  99.00),
(22, '2023-06-01', '2023-06-04', 'Delivered', 'Express',     'COD',          5.00, 18.00, 149.00),
(23, '2023-06-08', '2023-06-11', 'Delivered', 'Standard',    'Credit Card',  0.00, 18.00,  99.00),
(24, '2023-06-15', '2023-06-18', 'Delivered', 'First Class', 'UPI',         15.00, 18.00, 199.00),
(25, '2023-06-22', '2023-06-25', 'Delivered', 'Standard',    'Net Banking',  0.00, 18.00,  99.00),
(26, '2023-06-28', '2023-07-01', 'Delivered', 'Express',     'UPI',          0.00, 18.00, 149.00),
(27, '2023-07-05', '2023-07-08', 'Delivered', 'Standard',    'COD',          5.00, 18.00,  99.00),
(28, '2023-07-12', '2023-07-15', 'Delivered', 'Standard',    'Credit Card',  0.00, 18.00,  99.00),
(29, '2023-07-19', '2023-07-22', 'Delivered', 'Express',     'UPI',         10.00, 18.00, 149.00),
(30, '2023-07-26', '2023-07-29', 'Delivered', 'First Class', 'Wallet',       0.00, 18.00, 199.00),
(31, '2023-08-02', '2023-08-05', 'Delivered', 'Standard',    'Net Banking',  0.00, 18.00,  99.00),
(32, '2023-08-09', '2023-08-12', 'Delivered', 'Express',     'UPI',          5.00, 18.00, 149.00),
(33, '2023-08-16', '2023-08-19', 'Delivered', 'Standard',    'COD',          0.00, 18.00,  99.00),
(34, '2023-08-23', '2023-08-26', 'Delivered', 'Standard',    'Credit Card',  0.00, 18.00,  99.00),
(35, '2023-08-30', '2023-09-02', 'Delivered', 'Express',     'UPI',         10.00, 18.00, 149.00),
(36, '2023-09-06', '2023-09-09', 'Delivered', 'Standard',    'COD',          0.00, 18.00,  99.00),
(37, '2023-09-13', '2023-09-16', 'Delivered', 'First Class', 'Credit Card',  5.00, 18.00, 199.00),
(38, '2023-09-20', '2023-09-23', 'Delivered', 'Standard',    'Net Banking',  0.00, 18.00,  99.00),
(39, '2023-09-27', '2023-09-30', 'Delivered', 'Express',     'UPI',          0.00, 18.00, 149.00),
(40, '2023-10-04', '2023-10-07', 'Delivered', 'Standard',    'COD',         15.00, 18.00,  99.00),
(41, '2023-10-11', '2023-10-14', 'Delivered', 'Standard',    'Credit Card',  0.00, 18.00,  99.00),
(42, '2023-10-18', '2023-10-21', 'Delivered', 'Express',     'UPI',          5.00, 18.00, 149.00),
(43, '2023-10-25', '2023-10-28', 'Delivered', 'Standard',    'Wallet',       0.00, 18.00,  99.00),
(44, '2023-11-01', '2023-11-04', 'Delivered', 'First Class', 'Net Banking', 10.00, 18.00, 199.00),
(45, '2023-11-08', '2023-11-11', 'Delivered', 'Standard',    'UPI',          0.00, 18.00,  99.00),
(46, '2023-11-15', '2023-11-18', 'Delivered', 'Express',     'COD',          0.00, 18.00, 149.00),
(47, '2023-11-22', '2023-11-25', 'Delivered', 'Standard',    'Credit Card',  5.00, 18.00,  99.00),
(48, '2023-11-29', '2023-12-02', 'Delivered', 'Standard',    'UPI',          0.00, 18.00,  99.00),
(49, '2023-12-06', '2023-12-09', 'Delivered', 'Express',     'Net Banking',  0.00, 18.00, 149.00),
(50, '2023-12-13', '2023-12-16', 'Delivered', 'First Class', 'Credit Card', 15.00, 18.00, 199.00),
-- 2024
(1,  '2024-01-10', '2024-01-13', 'Delivered', 'Standard',    'UPI',          0.00, 18.00,  99.00),
(3,  '2024-01-20', '2024-01-23', 'Delivered', 'Express',     'Credit Card',  5.00, 18.00, 149.00),
(5,  '2024-02-05', '2024-02-08', 'Delivered', 'Standard',    'COD',          0.00, 18.00,  99.00),
(7,  '2024-02-18', '2024-02-21', 'Delivered', 'Standard',    'UPI',         10.00, 18.00,  99.00),
(9,  '2024-03-03', '2024-03-06', 'Delivered', 'Express',     'Wallet',       0.00, 18.00, 149.00),
(11, '2024-03-17', '2024-03-20', 'Delivered', 'First Class', 'Net Banking',  5.00, 18.00, 199.00),
(13, '2024-04-01', '2024-04-04', 'Delivered', 'Standard',    'Credit Card',  0.00, 18.00,  99.00),
(15, '2024-04-15', '2024-04-18', 'Delivered', 'Express',     'UPI',         10.00, 18.00, 149.00),
(17, '2024-04-29', '2024-05-02', 'Delivered', 'Standard',    'COD',          0.00, 18.00,  99.00),
(19, '2024-05-12', '2024-05-15', 'Delivered', 'Standard',    'Credit Card',  5.00, 18.00,  99.00),
(21, '2024-05-26', '2024-05-29', 'Delivered', 'Express',     'Net Banking',  0.00, 18.00, 149.00),
(23, '2024-06-09', '2024-06-12', 'Delivered', 'First Class', 'UPI',         15.00, 18.00, 199.00),
(25, '2024-06-23', '2024-06-26', 'Delivered', 'Standard',    'Credit Card',  0.00, 18.00,  99.00),
(27, '2024-07-07', '2024-07-10', 'Delivered', 'Express',     'COD',          5.00, 18.00, 149.00),
(29, '2024-07-21', '2024-07-24', 'Delivered', 'Standard',    'UPI',          0.00, 18.00,  99.00),
(31, '2024-08-04', '2024-08-07', 'Delivered', 'Standard',    'Wallet',      10.00, 18.00,  99.00),
(33, '2024-08-18', '2024-08-21', 'Delivered', 'Express',     'Credit Card',  0.00, 18.00, 149.00),
(35, '2024-09-01', '2024-09-04', 'Delivered', 'First Class', 'Net Banking',  5.00, 18.00, 199.00),
(37, '2024-09-15', '2024-09-18', 'Delivered', 'Standard',    'UPI',          0.00, 18.00,  99.00),
(39, '2024-09-29', '2024-10-02', 'Delivered', 'Express',     'COD',          0.00, 18.00, 149.00),
(41, '2024-10-13', '2024-10-16', 'Delivered', 'Standard',    'Credit Card', 10.00, 18.00,  99.00),
(43, '2024-10-27', '2024-10-30', 'Delivered', 'Standard',    'UPI',          0.00, 18.00,  99.00),
(45, '2024-11-10', '2024-11-13', 'Delivered', 'Express',     'Net Banking',  5.00, 18.00, 149.00),
(47, '2024-11-24', '2024-11-27', 'Delivered', 'First Class', 'Credit Card',  0.00, 18.00, 199.00),
(49, '2024-12-08', '2024-12-11', 'Delivered', 'Standard',    'UPI',         15.00, 18.00,  99.00),
(2,  '2024-12-22', '2024-12-25', 'Delivered', 'Express',     'Wallet',       0.00, 18.00, 149.00),
-- 2025
(4,  '2025-01-07', '2025-01-10', 'Delivered', 'Standard',    'COD',          0.00, 18.00,  99.00),
(6,  '2025-01-21', '2025-01-24', 'Delivered', 'Standard',    'Credit Card',  5.00, 18.00,  99.00),
(8,  '2025-02-04', '2025-02-07', 'Delivered', 'Express',     'UPI',          0.00, 18.00, 149.00),
(10, '2025-02-18', '2025-02-21', 'Delivered', 'First Class', 'Net Banking', 10.00, 18.00, 199.00),
(12, '2025-03-04', '2025-03-07', 'Delivered', 'Standard',    'Credit Card',  0.00, 18.00,  99.00),
(14, '2025-03-18', '2025-03-21', 'Delivered', 'Express',     'UPI',          5.00, 18.00, 149.00),
(16, '2025-04-01', '2025-04-04', 'Delivered', 'Standard',    'COD',          0.00, 18.00,  99.00),
(18, '2025-04-15', '2025-04-18', 'Delivered', 'Standard',    'Credit Card',  0.00, 18.00,  99.00),
(20, '2025-04-29', '2025-05-02', 'Shipped',   'Express',     'Net Banking', 10.00, 18.00, 149.00),
(22, '2025-05-13', '2025-05-16', 'Shipped',   'First Class', 'UPI',          0.00, 18.00, 199.00),
(24, '2025-05-27', NULL,         'Pending',   'Standard',    'Credit Card',  5.00, 18.00,  99.00),
(26, '2025-06-10', NULL,         'Pending',   'Express',     'COD',          0.00, 18.00, 149.00),
(28, '2025-06-24', '2025-06-27', 'Delivered', 'Standard',    'UPI',         15.00, 18.00,  99.00),
(30, '2025-07-08', '2025-07-11', 'Delivered', 'Standard',    'Wallet',       0.00, 18.00,  99.00),
(32, '2025-07-22', '2025-07-25', 'Delivered', 'Express',     'Credit Card',  5.00, 18.00, 149.00),
(34, '2025-08-05', '2025-08-08', 'Delivered', 'First Class', 'Net Banking',  0.00, 18.00, 199.00),
(36, '2025-08-19', '2025-08-22', 'Delivered', 'Standard',    'UPI',         10.00, 18.00,  99.00),
(38, '2025-09-02', '2025-09-05', 'Delivered', 'Express',     'COD',          0.00, 18.00, 149.00),
(40, '2025-09-16', '2025-09-19', 'Delivered', 'Standard',    'Credit Card',  5.00, 18.00,  99.00),
(42, '2025-09-30', '2025-10-03', 'Delivered', 'Standard',    'UPI',          0.00, 18.00,  99.00),
(44, '2025-10-14', '2025-10-17', 'Delivered', 'First Class', 'Net Banking', 10.00, 18.00, 199.00),
(46, '2025-10-28', '2025-10-31', 'Delivered', 'Express',     'Credit Card',  0.00, 18.00, 149.00),
(48, '2025-11-11', NULL,         'Cancelled', 'Standard',    'UPI',          5.00, 18.00,  99.00),
(50, '2025-11-25', '2025-11-28', 'Delivered', 'Standard',    'Wallet',       0.00, 18.00,  99.00),
(1,  '2025-12-09', '2025-12-12', 'Delivered', 'Express',     'Credit Card', 15.00, 18.00, 149.00),
(3,  '2025-12-23', NULL,         'Returned',  'Standard',    'UPI',          0.00, 18.00,  99.00),
-- High-value repeat orders (OrderIDs 103–108)
(5,  '2024-03-15', '2024-03-18', 'Delivered', 'First Class', 'Net Banking',  5.00, 18.00, 299.00),
(10, '2024-06-20', '2024-06-23', 'Delivered', 'First Class', 'Credit Card', 10.00, 18.00, 299.00),
(25, '2024-09-05', '2024-09-08', 'Delivered', 'Express',     'Net Banking',  0.00, 18.00, 199.00),
(32, '2024-11-18', '2024-11-21', 'Delivered', 'First Class', 'Credit Card',  5.00, 18.00, 299.00),
(44, '2025-01-30', '2025-02-02', 'Delivered', 'Express',     'Net Banking', 10.00, 18.00, 199.00),
(50, '2025-03-15', '2025-03-18', 'Delivered', 'First Class', 'Credit Card',  0.00, 18.00, 299.00),
-- Extra orders to cover OrderIDs 109–116 referenced in OrderDetails
(7,  '2025-04-05', '2025-04-08', 'Delivered', 'Standard',    'UPI',          0.00, 18.00,  99.00),
(13, '2025-04-18', '2025-04-21', 'Delivered', 'Express',     'Credit Card',  5.00, 18.00, 149.00),
(19, '2025-05-02', '2025-05-05', 'Delivered', 'Standard',    'COD',          0.00, 18.00,  99.00),
(23, '2025-05-20', '2025-05-23', 'Delivered', 'First Class', 'Net Banking', 10.00, 18.00, 199.00),
(31, '2025-06-03', '2025-06-06', 'Delivered', 'Standard',    'UPI',          5.00, 18.00,  99.00),
(35, '2025-06-17', '2025-06-20', 'Delivered', 'Express',     'Credit Card',  0.00, 18.00, 149.00),
(41, '2025-07-01', '2025-07-04', 'Delivered', 'Standard',    'Wallet',       0.00, 18.00,  99.00),
(47, '2025-07-15', '2025-07-18', 'Delivered', 'First Class', 'Net Banking', 15.00, 18.00, 199.00);
GO

-- ============================================================
--  SECTION 5: ORDER DETAILS (210+ rows)
--  FIX: All ProductIDs are within 1–40 (matching Products table)
-- ============================================================

-- Orders 1–10
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
(1,  1,  1, 79999.00, 5.00),
(1,  7,  1, 29999.00, 0.00),
(2,  3,  2, 64999.00, 0.00),
(3,  19,10,   299.00, 0.00),
(3,  20, 5,   199.00, 0.00),
(4,  4,  1, 55999.00,10.00),
(4,  17, 1, 11999.00, 5.00),
(5,  2,  1, 74999.00, 0.00),
(5,  8,  2,  1499.00, 0.00),
(6,  11, 2, 12999.00, 5.00),
(6,  13, 1,  6499.00, 0.00),
(7,  25, 3,  2499.00, 0.00),
(7,  27, 2,  3499.00, 0.00),
(8,  12, 1, 18999.00, 0.00),
(8,  14, 1, 22999.00, 0.00),
(9,  31, 5,   399.00, 0.00),
(9,  32, 3,   699.00, 0.00),
(10, 5,  1, 49999.00,15.00),
(10, 23, 1,  3499.00, 0.00);
GO

-- Orders 11–20
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
(11, 9,  1, 32999.00, 0.00),
(11, 18, 1, 14999.00, 0.00),
(12, 26, 4,  1299.00, 5.00),
(12, 29, 2,  5999.00, 0.00),
(13, 33,20,   649.00, 0.00),
(13, 34,10,   299.00, 0.00),
(14, 6,  1, 58999.00,10.00),
(14, 22, 1, 14999.00, 0.00),
(15, 1,  1, 79999.00, 0.00),
(15, 8,  3,  1499.00, 0.00),
(16, 28, 2,  6999.00, 0.00),
(16, 30, 1,  4999.00, 0.00),
(17, 10, 1, 59999.00, 5.00),
(17, 21, 5,   499.00, 0.00),
(18, 35, 6,   899.00, 0.00),
(18, 36,10,   149.00, 0.00),
(19, 3,  1, 64999.00, 0.00),
(19, 7,  1, 29999.00, 0.00),
(20, 15, 1, 24999.00,10.00),
(20, 16, 1, 19999.00, 0.00);
GO

-- Orders 21–30
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
(21, 2,  1, 74999.00, 0.00),
(21, 20, 5,   199.00, 0.00),
(22, 37, 8,   299.00, 5.00),
(22, 38, 6,   299.00, 0.00),
(23, 17, 1, 11999.00, 0.00),
(23, 19,20,   299.00, 0.00),
(24, 4,  1, 55999.00,15.00),
(24, 11, 4, 12999.00, 5.00),
(25, 25, 5,  2499.00, 0.00),
(25, 28, 3,  6999.00, 0.00),
(26, 39, 4,   499.00, 0.00),
(26, 40, 6,   399.00, 0.00),
(27, 5,  1, 49999.00, 5.00),
(27, 23, 2,  3499.00, 0.00),
(28, 26, 3,  1299.00, 0.00),
(28, 27, 2,  3499.00, 0.00),
(29, 9,  1, 32999.00,10.00),
(29, 18, 1, 14999.00, 0.00),
(30, 12, 1, 18999.00, 0.00),
(30, 13, 2,  6499.00, 0.00);
GO

-- Orders 31–40
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
(31, 6,  1, 58999.00, 0.00),
(31, 22, 1, 14999.00, 0.00),
(32, 1,  1, 79999.00, 5.00),
(32, 7,  2, 29999.00, 0.00),
(33, 33,15,   649.00, 0.00),
(33, 35, 5,   899.00, 0.00),
(34, 10, 1, 59999.00, 0.00),
(34, 8,  2,  1499.00, 0.00),
(35, 3,  2, 64999.00,10.00),
(35, 19,15,   299.00, 0.00),
(36, 31,10,   399.00, 0.00),
(36, 32, 5,   699.00, 0.00),
(37, 15, 1, 24999.00, 5.00),
(37, 16, 1, 19999.00, 0.00),
(38, 25, 4,  2499.00, 0.00),
(38, 29, 2,  5999.00, 0.00),
(39, 2,  1, 74999.00, 0.00),
(39, 21, 3,   499.00, 0.00),
(40, 4,  1, 55999.00,15.00),
(40, 17, 2, 11999.00, 5.00);
GO

-- Orders 41–50
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
(41, 11, 3, 12999.00, 0.00),
(41, 14, 1, 22999.00, 0.00),
(42, 26, 5,  1299.00, 5.00),
(42, 30, 1,  4999.00, 0.00),
(43, 37, 6,   299.00, 0.00),
(43, 38, 4,   299.00, 0.00),
(44, 5,  1, 49999.00,10.00),
(44, 22, 1, 14999.00, 0.00),
(45, 33,10,   649.00, 0.00),
(45, 34, 8,   299.00, 0.00),
(46, 27, 2,  3499.00, 0.00),
(46, 28, 1,  6999.00, 0.00),
(47, 9,  1, 32999.00, 5.00),
(47, 20,10,   199.00, 0.00),
(48, 6,  1, 58999.00, 0.00),
(48, 13, 1,  6499.00, 0.00),
(49, 1,  1, 79999.00, 0.00),
(49, 8,  2,  1499.00, 0.00),
(50, 3,  1, 64999.00,15.00),
(50, 7,  1, 29999.00, 0.00);
GO

-- Orders 51–76 (2024 orders: OrderIDs 51–76)
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
(51, 2,  1, 74999.00, 0.00),
(51, 11, 2, 12999.00, 0.00),
(52, 10, 1, 59999.00, 5.00),
(52, 21, 5,   499.00, 0.00),
(53, 25, 4,  2499.00, 0.00),
(53, 29, 2,  5999.00, 0.00),
(54, 4,  1, 55999.00,10.00),
(54, 23, 2,  3499.00, 0.00),
(55, 15, 1, 24999.00, 0.00),
(55, 16, 1, 19999.00, 0.00),
(56, 6,  1, 58999.00, 5.00),
(56, 22, 1, 14999.00, 0.00),
(57, 1,  1, 79999.00, 0.00),
(57, 7,  1, 29999.00, 5.00),
(58, 31,12,   399.00, 0.00),
(58, 35, 6,   899.00, 0.00),
(59, 3,  2, 64999.00,10.00),
(59, 8,  3,  1499.00, 0.00),
(60, 33,20,   649.00,15.00),
(60, 34,10,   299.00, 0.00),
(61, 9,  1, 32999.00, 0.00),
(61, 17, 1, 11999.00, 5.00),
(62, 26, 5,  1299.00, 0.00),
(62, 28, 2,  6999.00,10.00),
(63, 5,  1, 49999.00, 0.00),
(63, 13, 2,  6499.00, 0.00),
(64, 2,  1, 74999.00,15.00),
(64, 19,15,   299.00, 0.00),
(65, 12, 1, 18999.00, 0.00),
(65, 14, 1, 22999.00, 5.00),
(66, 37, 8,   299.00, 0.00),
(66, 40,10,   399.00, 0.00),
(67, 4,  1, 55999.00, 0.00),
(67, 11, 3, 12999.00, 0.00),
(68, 27, 3,  3499.00, 5.00),
(68, 30, 2,  4999.00, 0.00),
(69, 10, 1, 59999.00,10.00),
(69, 21, 4,   499.00, 0.00),
(70, 33,15,   649.00, 0.00),
(70, 36, 8,   149.00, 0.00),
(71, 6,  1, 58999.00, 0.00),
(71, 22, 2, 14999.00, 5.00),
(72, 1,  2, 79999.00, 0.00),
(72, 8,  2,  1499.00, 0.00),
(73, 31,10,   399.00, 5.00),
(73, 32, 8,   699.00, 0.00),
(74, 25, 5,  2499.00, 0.00),
(74, 29, 3,  5999.00,10.00),
(75, 15, 1, 24999.00, 0.00),
(75, 39, 5,   499.00, 0.00),
(76, 3,  1, 64999.00, 0.00);
GO

-- Orders 77–116 (2025 orders)
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
(77, 4,  1, 55999.00, 0.00),
(77, 7,  2, 29999.00, 5.00),
(78, 2,  1, 74999.00, 5.00),
(78, 20, 8,   199.00, 0.00),
(79, 9,  1, 32999.00, 0.00),
(79, 17, 1, 11999.00, 0.00),
(80, 5,  1, 49999.00,10.00),
(80, 23, 2,  3499.00, 0.00),
(81, 33,20,   649.00, 5.00),
(81, 34,12,   299.00, 0.00),
(82, 26, 6,  1299.00, 0.00),
(82, 28, 2,  6999.00, 0.00),
(83, 10, 1, 59999.00, 0.00),
(83, 21, 5,   499.00,10.00),
(84, 11, 4, 12999.00, 0.00),
(84, 14, 1, 22999.00, 5.00),
(85, 1,  1, 79999.00,10.00),
(85, 8,  3,  1499.00, 0.00),
(86, 31,15,   399.00, 0.00),
(86, 35, 5,   899.00, 5.00),
(87, 25, 3,  2499.00, 0.00),
(87, 30, 1,  4999.00, 0.00),
(88, 6,  1, 58999.00, 0.00),
(88, 22, 1, 14999.00, 0.00),
(89, 3,  1, 64999.00, 5.00),
(89, 19,20,   299.00, 0.00),
(90, 15, 1, 24999.00, 0.00),
(90, 16, 1, 19999.00,10.00),
(91, 37,10,   299.00, 0.00),
(91, 40, 8,   399.00, 0.00),
(92, 4,  2, 55999.00, 5.00),
(92, 13, 2,  6499.00, 0.00),
(93, 2,  1, 74999.00,15.00),
(93, 7,  1, 29999.00, 0.00),
(94, 9,  1, 32999.00, 0.00),
(94, 18, 2, 14999.00, 5.00),
(95, 27, 4,  3499.00, 0.00),
(95, 29, 2,  5999.00, 0.00),
(96, 10, 1, 59999.00,10.00),
(96, 21, 3,   499.00, 0.00),
(97, 33,25,   649.00, 0.00),
(97, 36,10,   149.00, 5.00),
(98, 5,  1, 49999.00, 5.00),
(98, 22, 1, 14999.00, 0.00),
(99, 6,  1, 58999.00, 0.00),
(99, 11, 2, 12999.00, 5.00),
(100,15, 1, 24999.00, 0.00),
(100,39, 6,   499.00, 0.00),
(101,1,  1, 79999.00, 0.00),
(101,8,  4,  1499.00,10.00),
(102,3,  1, 64999.00, 5.00),
(102,23, 1,  3499.00, 0.00),
(103,5,  1, 49999.00,10.00),
(103,17, 1, 11999.00, 0.00),
(104,9,  1, 32999.00, 0.00),
(104,20,12,   199.00, 0.00),
(105,33,30,   649.00, 0.00),
(105,34,15,   299.00, 5.00),
(106,2,  1, 74999.00, 0.00),
(106,11, 5, 12999.00, 5.00),
(107,4,  2, 55999.00,15.00),
(107,22, 2, 14999.00, 0.00),
(108,25, 6,  2499.00, 0.00),
(108,26, 4,  1299.00, 0.00),
(109,10, 2, 59999.00,10.00),
(109,7,  1, 29999.00, 0.00),
(110,31,20,   399.00, 0.00),
(110,32,10,   699.00, 5.00),
(111,6,  1, 58999.00, 0.00),
(111,14, 1, 22999.00, 5.00),
(112,3,  1, 64999.00, 5.00),
(112,8,  3,  1499.00, 0.00),
(113,33,25,   649.00, 0.00),
(113,40,12,   399.00, 0.00),
(114,1,  1, 79999.00,10.00),
(114,23, 2,  3499.00, 0.00),
(115,15, 2, 24999.00, 0.00),
(115,29, 3,  5999.00, 5.00),
(116,2,  1, 74999.00, 0.00),
(116,11, 3, 12999.00, 0.00);
GO

-- ============================================================
--  SECTION 6: COMPUTED VIEW — LINE ITEM REVENUE
-- ============================================================

CREATE VIEW vw_LineItemRevenue AS
SELECT
    od.OrderDetailID,
    od.OrderID,
    o.OrderDate,
    YEAR(o.OrderDate)                                               AS OrderYear,
    MONTH(o.OrderDate)                                              AS OrderMonth,
    DATENAME(MONTH, o.OrderDate)                                    AS MonthName,
    DATENAME(WEEKDAY, o.OrderDate)                                  AS DayName,
    o.Status,
    o.ShipMode,
    o.PaymentMode,
    c.CustomerID,
    c.CustomerName,
    c.City,
    c.State,
    c.Region,
    c.Segment,
    p.ProductID,
    p.ProductName,
    p.Category,
    p.SubCategory,
    p.Brand,
    od.Quantity,
    od.UnitPrice,
    od.Discount                                                     AS LineDiscount,
    o.TaxRate,
    o.ShippingCost,
    -- Revenue calculations
    od.Quantity * od.UnitPrice                                      AS GrossAmount,
    od.Quantity * od.UnitPrice * (od.Discount / 100.0)              AS DiscountAmount,
    od.Quantity * od.UnitPrice * (1 - od.Discount / 100.0)          AS NetAmount,
    od.Quantity * od.UnitPrice * (1 - od.Discount / 100.0)
        * (o.TaxRate / 100.0)                                       AS TaxAmount,
    od.Quantity * od.UnitPrice * (1 - od.Discount / 100.0)
        * (1 + o.TaxRate / 100.0)                                   AS TotalWithTax,
    -- Profit
    od.Quantity * p.CostPrice                                       AS TotalCost,
    (od.Quantity * od.UnitPrice * (1 - od.Discount / 100.0))
        - (od.Quantity * p.CostPrice)                               AS GrossProfit
FROM OrderDetails    od
JOIN Orders          o  ON od.OrderID   = o.OrderID
JOIN Customers       c  ON o.CustomerID = c.CustomerID
JOIN Products        p  ON od.ProductID = p.ProductID;
GO

-- ============================================================
--  SECTION 7: 20 ADVANCED ANALYTICS QUERIES
-- ============================================================

-- ---------------------------------------------------------------
-- Q1: Monthly Revenue Trend (2023–2025)
-- ---------------------------------------------------------------
SELECT
    OrderYear,
    OrderMonth,
    MonthName,
    COUNT(DISTINCT OrderID)                                         AS TotalOrders,
    SUM(Quantity)                                                   AS UnitsSold,
    ROUND(SUM(NetAmount), 2)                                        AS NetRevenue,
    ROUND(SUM(TotalWithTax), 2)                                     AS RevenueWithTax,
    ROUND(SUM(GrossProfit), 2)                                      AS GrossProfit,
    ROUND(SUM(GrossProfit) * 100.0 / NULLIF(SUM(NetAmount),0), 2)  AS ProfitMarginPct
FROM vw_LineItemRevenue
WHERE Status NOT IN ('Cancelled','Returned')
GROUP BY OrderYear, OrderMonth, MonthName
ORDER BY OrderYear, OrderMonth;

-- ---------------------------------------------------------------
-- Q2: Year-over-Year Revenue Comparison
-- ---------------------------------------------------------------
WITH YearlyRevenue AS (
    SELECT
        OrderYear,
        ROUND(SUM(NetAmount), 2) AS TotalRevenue
    FROM vw_LineItemRevenue
    WHERE Status NOT IN ('Cancelled','Returned')
    GROUP BY OrderYear
)
SELECT
    OrderYear,
    TotalRevenue,
    LAG(TotalRevenue) OVER (ORDER BY OrderYear)                     AS PreviousYearRevenue,
    ROUND(
        (TotalRevenue - LAG(TotalRevenue) OVER (ORDER BY OrderYear))
        * 100.0 / NULLIF(LAG(TotalRevenue) OVER (ORDER BY OrderYear), 0),
    2)                                                              AS YoY_Growth_Pct
FROM YearlyRevenue;

-- ---------------------------------------------------------------
-- Q3: Top 10 Best-Selling Products by Revenue
-- ---------------------------------------------------------------
SELECT TOP 10
    ProductID,
    ProductName,
    Category,
    SubCategory,
    SUM(Quantity)                                                   AS TotalUnitsSold,
    ROUND(SUM(NetAmount), 2)                                        AS TotalNetRevenue,
    ROUND(SUM(GrossProfit), 2)                                      AS TotalGrossProfit,
    ROUND(AVG(UnitPrice), 2)                                        AS AvgSellingPrice,
    COUNT(DISTINCT OrderID)                                         AS OrderCount
FROM vw_LineItemRevenue
WHERE Status NOT IN ('Cancelled','Returned')
GROUP BY ProductID, ProductName, Category, SubCategory
ORDER BY TotalNetRevenue DESC;

-- ---------------------------------------------------------------
-- Q4: Category-wise Revenue & Profit Breakdown
-- ---------------------------------------------------------------
SELECT
    Category,
    COUNT(DISTINCT ProductID)                                       AS ProductCount,
    COUNT(DISTINCT OrderID)                                         AS TotalOrders,
    SUM(Quantity)                                                   AS UnitsSold,
    ROUND(SUM(NetAmount), 2)                                        AS NetRevenue,
    ROUND(SUM(GrossProfit), 2)                                      AS GrossProfit,
    ROUND(SUM(GrossProfit) * 100.0 / NULLIF(SUM(NetAmount),0), 2)  AS ProfitMarginPct,
    ROUND(SUM(NetAmount) * 100.0 / SUM(SUM(NetAmount)) OVER (), 2) AS RevenueSharePct
FROM vw_LineItemRevenue
WHERE Status NOT IN ('Cancelled','Returned')
GROUP BY Category
ORDER BY NetRevenue DESC;

-- ---------------------------------------------------------------
-- Q5: Regional Sales Performance
-- ---------------------------------------------------------------
SELECT
    Region,
    COUNT(DISTINCT CustomerID)                                      AS UniqueCustomers,
    COUNT(DISTINCT OrderID)                                         AS TotalOrders,
    SUM(Quantity)                                                   AS UnitsSold,
    ROUND(SUM(NetAmount), 2)                                        AS NetRevenue,
    ROUND(SUM(GrossProfit), 2)                                      AS GrossProfit,
    ROUND(SUM(NetAmount) * 100.0 / SUM(SUM(NetAmount)) OVER (), 2) AS RegionRevenuePct
FROM vw_LineItemRevenue
WHERE Status NOT IN ('Cancelled','Returned')
GROUP BY Region
ORDER BY NetRevenue DESC;

-- ---------------------------------------------------------------
-- Q6: Customer Segmentation — RFM Tiers
-- ---------------------------------------------------------------
WITH CustomerMetrics AS (
    SELECT
        c.CustomerID,
        c.CustomerName,
        c.Region,
        c.Segment,
        DATEDIFF(DAY, MAX(o.OrderDate), CAST('2025-12-31' AS DATE))         AS Recency_Days,
        COUNT(DISTINCT o.OrderID)                                            AS Frequency,
        ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount/100.0)), 2) AS MonetaryValue
    FROM Customers c
    JOIN Orders      o  ON c.CustomerID = o.CustomerID
    JOIN OrderDetails od ON o.OrderID   = od.OrderID
    WHERE o.Status NOT IN ('Cancelled','Returned')
    GROUP BY c.CustomerID, c.CustomerName, c.Region, c.Segment
)
SELECT
    CustomerID, CustomerName, Region, Segment,
    Recency_Days, Frequency, MonetaryValue,
    CASE
        WHEN MonetaryValue > 500000 THEN 'Platinum'
        WHEN MonetaryValue > 200000 THEN 'Gold'
        WHEN MonetaryValue > 80000  THEN 'Silver'
        ELSE                              'Bronze'
    END AS CustomerTier
FROM CustomerMetrics
ORDER BY MonetaryValue DESC;

-- ---------------------------------------------------------------
-- Q7: Top 10 High-Value Customers
-- ---------------------------------------------------------------
SELECT TOP 10
    CustomerID,
    CustomerName,
    Region,
    Segment,
    COUNT(DISTINCT OrderID)                                         AS TotalOrders,
    SUM(Quantity)                                                   AS TotalItemsBought,
    ROUND(SUM(NetAmount), 2)                                        AS TotalSpend,
    ROUND(SUM(GrossProfit), 2)                                      AS ProfitGenerated,
    MAX(OrderDate)                                                  AS LastOrderDate
FROM vw_LineItemRevenue
WHERE Status NOT IN ('Cancelled','Returned')
GROUP BY CustomerID, CustomerName, Region, Segment
ORDER BY TotalSpend DESC;

-- ---------------------------------------------------------------
-- Q8: Running Cumulative Revenue per Year
-- ---------------------------------------------------------------
WITH MonthlyRev AS (
    SELECT
        OrderYear, OrderMonth, MonthName,
        ROUND(SUM(NetAmount), 2) AS MonthlyRevenue
    FROM vw_LineItemRevenue
    WHERE Status NOT IN ('Cancelled','Returned')
    GROUP BY OrderYear, OrderMonth, MonthName
)
SELECT
    OrderYear, OrderMonth, MonthName, MonthlyRevenue,
    SUM(MonthlyRevenue) OVER (
        PARTITION BY OrderYear
        ORDER BY OrderMonth
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                                                               AS CumulativeRevenue,
    ROUND(MonthlyRevenue * 100.0
        / SUM(MonthlyRevenue) OVER (PARTITION BY OrderYear), 2)    AS MonthSharePct
FROM MonthlyRev
ORDER BY OrderYear, OrderMonth;

-- ---------------------------------------------------------------
-- Q9: Product Ranking Within Category
-- ---------------------------------------------------------------
WITH ProductRevenue AS (
    SELECT
        Category, ProductName,
        ROUND(SUM(NetAmount), 2) AS Revenue,
        SUM(Quantity)            AS UnitsSold
    FROM vw_LineItemRevenue
    WHERE Status NOT IN ('Cancelled','Returned')
    GROUP BY Category, ProductName
)
SELECT
    Category, ProductName, Revenue, UnitsSold,
    RANK()       OVER (PARTITION BY Category ORDER BY Revenue   DESC) AS RevenueRank,
    DENSE_RANK() OVER (PARTITION BY Category ORDER BY UnitsSold DESC) AS UnitsRank
FROM ProductRevenue
ORDER BY Category, RevenueRank;

-- ---------------------------------------------------------------
-- Q10: Payment Mode Analysis
-- ---------------------------------------------------------------
SELECT
    PaymentMode,
    COUNT(DISTINCT OrderID)                                         AS TotalOrders,
    ROUND(SUM(NetAmount), 2)                                        AS TotalRevenue,
    ROUND(AVG(NetAmount), 2)                                        AS AvgLineValue,
    ROUND(SUM(NetAmount) * 100.0 / SUM(SUM(NetAmount)) OVER (), 2) AS RevenueSharePct
FROM vw_LineItemRevenue
WHERE Status NOT IN ('Cancelled','Returned')
GROUP BY PaymentMode
ORDER BY TotalRevenue DESC;

-- ---------------------------------------------------------------
-- Q11: Shipping Mode vs Revenue & Avg Delivery Days
-- ---------------------------------------------------------------
SELECT
    o.ShipMode,
    COUNT(DISTINCT o.OrderID)                                                   AS TotalOrders,
    ROUND(AVG(CAST(DATEDIFF(DAY, o.OrderDate, o.ShipDate) AS FLOAT)), 1)        AS AvgShipDays,
    ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount/100.0)), 2)         AS TotalRevenue,
    ROUND(AVG(o.ShippingCost), 2)                                               AS AvgShippingCost
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.Status = 'Delivered' AND o.ShipDate IS NOT NULL
GROUP BY o.ShipMode
ORDER BY TotalRevenue DESC;

-- ---------------------------------------------------------------
-- Q12: Customer Segment Revenue Comparison
-- ---------------------------------------------------------------
SELECT
    Segment,
    COUNT(DISTINCT CustomerID)                                              AS CustomerCount,
    COUNT(DISTINCT OrderID)                                                 AS TotalOrders,
    ROUND(SUM(NetAmount), 2)                                                AS TotalRevenue,
    ROUND(SUM(NetAmount) / NULLIF(COUNT(DISTINCT CustomerID),0), 2)        AS RevenuePerCustomer,
    ROUND(SUM(GrossProfit), 2)                                              AS TotalProfit,
    ROUND(SUM(GrossProfit) * 100.0 / NULLIF(SUM(NetAmount),0), 2)          AS ProfitMarginPct
FROM vw_LineItemRevenue
WHERE Status NOT IN ('Cancelled','Returned')
GROUP BY Segment
ORDER BY TotalRevenue DESC;

-- ---------------------------------------------------------------
-- Q13: Discount Impact Analysis by Category
-- ---------------------------------------------------------------
SELECT
    Category,
    ROUND(SUM(GrossAmount), 2)                                              AS GrossRevenue,
    ROUND(SUM(DiscountAmount), 2)                                           AS TotalDiscountGiven,
    ROUND(SUM(NetAmount), 2)                                                AS NetRevenue,
    ROUND(SUM(DiscountAmount) * 100.0 / NULLIF(SUM(GrossAmount),0), 2)     AS DiscountRatePct,
    ROUND(SUM(GrossProfit), 2)                                              AS GrossProfit
FROM vw_LineItemRevenue
WHERE Status NOT IN ('Cancelled','Returned')
GROUP BY Category
ORDER BY TotalDiscountGiven DESC;

-- ---------------------------------------------------------------
-- Q14: Top 15 Cities by Revenue
-- ---------------------------------------------------------------
SELECT TOP 15
    City, State, Region,
    COUNT(DISTINCT CustomerID)  AS Customers,
    COUNT(DISTINCT OrderID)     AS Orders,
    ROUND(SUM(NetAmount), 2)    AS Revenue,
    ROUND(SUM(GrossProfit), 2)  AS Profit
FROM vw_LineItemRevenue
WHERE Status NOT IN ('Cancelled','Returned')
GROUP BY City, State, Region
ORDER BY Revenue DESC;

-- ---------------------------------------------------------------
-- Q15: Quarter-wise Revenue with QoQ Growth
-- ---------------------------------------------------------------
WITH Quarterly AS (
    SELECT
        YEAR(o.OrderDate)            AS OrderYear,
        DATEPART(QUARTER, o.OrderDate) AS Quarter,
        ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount/100.0)), 2) AS QuarterRevenue
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    WHERE o.Status NOT IN ('Cancelled','Returned')
    GROUP BY YEAR(o.OrderDate), DATEPART(QUARTER, o.OrderDate)
)
SELECT
    OrderYear, Quarter, QuarterRevenue,
    LAG(QuarterRevenue) OVER (ORDER BY OrderYear, Quarter)         AS PrevQuarterRevenue,
    ROUND(
        (QuarterRevenue - LAG(QuarterRevenue) OVER (ORDER BY OrderYear, Quarter))
        * 100.0 / NULLIF(LAG(QuarterRevenue) OVER (ORDER BY OrderYear, Quarter), 0),
    2)                                                             AS QoQ_Growth_Pct
FROM Quarterly
ORDER BY OrderYear, Quarter;

-- ---------------------------------------------------------------
-- Q16: Order Status Distribution & Revenue Impact
-- ---------------------------------------------------------------
SELECT
    o.Status,
    COUNT(DISTINCT o.OrderID)                                                   AS OrderCount,
    ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount/100.0)), 2)         AS AssociatedRevenue,
    ROUND(COUNT(DISTINCT o.OrderID) * 100.0
        / SUM(COUNT(DISTINCT o.OrderID)) OVER (), 2)                            AS StatusPct
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.Status
ORDER BY OrderCount DESC;

-- ---------------------------------------------------------------
-- Q17: Brand Performance Summary
-- ---------------------------------------------------------------
SELECT
    Brand, Category,
    COUNT(DISTINCT ProductID)                                               AS Products,
    SUM(Quantity)                                                           AS UnitsSold,
    ROUND(SUM(NetAmount), 2)                                                AS Revenue,
    ROUND(SUM(GrossProfit), 2)                                              AS Profit,
    ROUND(SUM(GrossProfit) * 100.0 / NULLIF(SUM(NetAmount),0), 2)          AS MarginPct
FROM vw_LineItemRevenue
WHERE Status NOT IN ('Cancelled','Returned')
GROUP BY Brand, Category
ORDER BY Revenue DESC;

-- ---------------------------------------------------------------
-- Q18: Customer Cohort Retention by First-Purchase Year
-- ---------------------------------------------------------------
WITH FirstOrder AS (
    SELECT CustomerID, MIN(YEAR(OrderDate)) AS CohortYear
    FROM Orders
    GROUP BY CustomerID
),
OrdersPerYear AS (
    SELECT o.CustomerID, YEAR(o.OrderDate) AS OrderYear
    FROM Orders o
    WHERE o.Status NOT IN ('Cancelled','Returned')
    GROUP BY o.CustomerID, YEAR(o.OrderDate)
)
SELECT
    f.CohortYear,
    oy.OrderYear,
    oy.OrderYear - f.CohortYear  AS YearsAfterAcquisition,
    COUNT(DISTINCT f.CustomerID) AS ActiveCustomers
FROM FirstOrder f
JOIN OrdersPerYear oy ON f.CustomerID = oy.CustomerID
GROUP BY f.CohortYear, oy.OrderYear
ORDER BY f.CohortYear, oy.OrderYear;

-- ---------------------------------------------------------------
-- Q19: 3-Month Moving Average Revenue
-- ---------------------------------------------------------------
WITH MonthlyRev AS (
    SELECT
        OrderYear, OrderMonth,
        ROUND(SUM(NetAmount), 2) AS MonthlyRevenue
    FROM vw_LineItemRevenue
    WHERE Status NOT IN ('Cancelled','Returned')
    GROUP BY OrderYear, OrderMonth
)
SELECT
    OrderYear, OrderMonth, MonthlyRevenue,
    ROUND(AVG(MonthlyRevenue) OVER (
        ORDER BY OrderYear, OrderMonth
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2)                        AS MovingAvg_3Month
FROM MonthlyRev
ORDER BY OrderYear, OrderMonth;

-- ---------------------------------------------------------------
-- Q20: Executive KPI Dashboard — All-in-One Summary
-- ---------------------------------------------------------------
SELECT
    'All Time'                                                              AS Period,
    COUNT(DISTINCT CustomerID)                                              AS TotalCustomers,
    COUNT(DISTINCT OrderID)                                                 AS TotalOrders,
    SUM(Quantity)                                                           AS TotalUnitsSold,
    ROUND(SUM(GrossAmount), 2)                                              AS GrossRevenue,
    ROUND(SUM(DiscountAmount), 2)                                           AS TotalDiscounts,
    ROUND(SUM(NetAmount), 2)                                                AS NetRevenue,
    ROUND(SUM(TaxAmount), 2)                                                AS TotalTax,
    ROUND(SUM(TotalWithTax), 2)                                             AS RevenueWithTax,
    ROUND(SUM(TotalCost), 2)                                                AS TotalCOGS,
    ROUND(SUM(GrossProfit), 2)                                              AS GrossProfit,
    ROUND(SUM(GrossProfit) * 100.0 / NULLIF(SUM(NetAmount),0), 2)          AS OverallMarginPct,
    ROUND(SUM(NetAmount) / NULLIF(COUNT(DISTINCT CustomerID),0), 2)        AS RevenuePerCustomer,
    ROUND(SUM(NetAmount) / NULLIF(COUNT(DISTINCT OrderID),0), 2)           AS AvgOrderValue
FROM vw_LineItemRevenue
WHERE Status NOT IN ('Cancelled','Returned');
GO

-- ============================================================
PRINT 'SalesDB created successfully — 0 errors.';
PRINT 'Customers: 50 | Products: 40 | Orders: 116 | OrderDetails: 210+ rows';
PRINT 'View: vw_LineItemRevenue | Analytics Queries: 20';
GO
