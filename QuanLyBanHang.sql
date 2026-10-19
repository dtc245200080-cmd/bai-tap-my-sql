CREATE DATABASE QuanLyBanHang;
USE QuanLyBanHang;
CREATE TABLE Customer (
    cID INT AUTO_INCREMENT PRIMARY KEY,
    cName VARCHAR(100) NOT NULL,
    cAge INT
);
CREATE TABLE Product (
    pID INT AUTO_INCREMENT PRIMARY KEY,
    pName VARCHAR(100) NOT NULL,
    pPrice DECIMAL(12,2) NOT NULL CHECK (pPrice >= 0)
);
CREATE TABLE `Order` (
    oID INT AUTO_INCREMENT PRIMARY KEY,
    cID INT NOT NULL,
    oDate DATE NOT NULL,
    oTotalPrice DECIMAL(12,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (cID) REFERENCES Customer(cID)
);
CREATE TABLE OrderDetail (
    oID INT NOT NULL,
    pID INT NOT NULL,
    odQTY INT NOT NULL CHECK (odQTY > 0),

    PRIMARY KEY (oID, pID),

    FOREIGN KEY (oID) REFERENCES `Order`(oID),
    FOREIGN KEY (pID) REFERENCES Product(pID)
);
SHOW TABLES;
DESCRIBE Customer;
DESCRIBE Product;
DESCRIBE `Order`;
DESCRIBE OrderDetail;
USE QuanLyBanHang;

-- =============================================
-- 1. THÊM DỮ LIỆU VÀO CÁC BẢNG (INSERT DATA)
-- =============================================

-- Thêm dữ liệu vào bảng Customer
INSERT INTO Customer (cID, cName, cAge) VALUES
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);

-- Thêm dữ liệu vào bảng Order
INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL);

-- Thêm dữ liệu vào bảng Product
INSERT INTO Product (pID, pName, pPrice) VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

-- Thêm dữ liệu vào bảng OrderDetail
INSERT INTO OrderDetail (oID, pID, odQTY) VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);


-- =============================================
-- 2. TRUY VẤN DỮ LIỆU (SELECT QUERIES)
-- =============================================

-- Yêu cầu 1: Hiển thị các thông tin gồm oID, oDate, oTotalPrice của tất cả các hóa đơn trong bảng Order
SELECT oID, oDate, oTotalPrice 
FROM `Order`;

-- Yêu cầu 2: Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách
SELECT 
    C.cName AS CustomerName, 
    P.pName AS ProductName
FROM Customer C
JOIN `Order` O ON C.cID = O.cID
JOIN OrderDetail OD ON O.oID = OD.oID
JOIN Product P ON OD.pID = P.pID;

-- Yêu cầu 3: Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
SELECT cName 
FROM Customer 
WHERE cID NOT IN (SELECT DISTINCT cID FROM `Order`);

-- Yêu cầu 4: Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn
SELECT 
    O.oID, 
    O.oDate, 
    SUM(OD.odQTY * P.pPrice) AS oTotalPrice
FROM `Order` O
JOIN OrderDetail OD ON O.oID = OD.oID
JOIN Product P ON OD.pID = P.pID
GROUP BY O.oID, O.oDate;