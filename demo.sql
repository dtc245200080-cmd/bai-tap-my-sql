-- ===================================================
-- BƯỚC 1 & 2: TẠO CƠ SỞ DỮ LIỆU, BẢNG VÀ CHÈN DỮ LIỆU
-- ===================================================
CREATE DATABASE IF NOT EXISTS demo;
USE demo;

-- Xóa bảng nếu đã tồn tại để tránh lỗi khi chạy lại
DROP TABLE IF EXISTS Products;

-- Tạo bảng Products
CREATE TABLE Products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL UNIQUE,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(10, 2) NOT NULL,
    productAmount INT NOT NULL,
    productDescription TEXT,
    productStatus VARCHAR(20) DEFAULT 'Available'
);

-- Chèn dữ liệu mẫu cho bảng Products
INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus) VALUES
('P001', 'Laptop Dell XPS 13', 1500.00, 10, 'Laptop cao cấp mỏng nhẹ', 'Available'),
('P002', 'iPhone 15 Pro', 1200.00, 25, 'Điện thoại thông minh flagship', 'Available'),
('P003', 'Samsung Galaxy S24', 1000.00, 15, 'Điện thoại màn hình AMOLED', 'Available'),
('P004', 'Bàn phím cơ Keychron', 150.00, 50, 'Bàn phím cơ không dây', 'Available'),
('P005', 'Tai nghe Sony WH-1000XM5', 350.00, 30, 'Tai nghe chống ồn chủ động', 'Out of Stock');


-- ===================================================
-- BƯỚC 3: TẠO CHỈ MỤC (INDEX) & SO SÁNH HIỆU SUẤT
-- ===================================================

-- 1. Kiểm tra truy vấn TRƯỚC khi tạo Unique Index
EXPLAIN SELECT * FROM Products WHERE productCode = 'P002';

-- Tạo Unique Index trên cột productCode
ALTER TABLE Products ADD UNIQUE INDEX idx_productCode(productCode);

-- Kiểm tra lại truy vấn SAU khi tạo Unique Index
EXPLAIN SELECT * FROM Products WHERE productCode = 'P002';


-- 2. Kiểm tra truy vấn TRƯỚC khi tạo Composite Index
EXPLAIN SELECT * FROM Products WHERE productName = 'iPhone 15 Pro' AND productPrice = 1200.00;

-- Tạo Composite Index trên 2 cột productName và productPrice
ALTER TABLE Products ADD INDEX idx_name_price(productName, productPrice);

-- Kiểm tra lại truy vấn SAU khi tạo Composite Index
EXPLAIN SELECT * FROM Products WHERE productName = 'iPhone 15 Pro' AND productPrice = 1200.00;


-- ===================================================
-- BƯỚC 4: TẠO, SỬA VÀ XÓA VIEW
-- ===================================================

-- Tạo View lấy thông tin: productCode, productName, productPrice, productStatus
CREATE VIEW view_products AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

-- Xem dữ liệu từ View vừa tạo
SELECT * FROM view_products;

-- Tiến hành sửa đổi View (thêm cột productAmount)
CREATE OR REPLACE VIEW view_products AS
SELECT productCode, productName, productPrice, productAmount, productStatus
FROM Products;

-- Kiểm tra lại View sau khi cập nhật
SELECT * FROM view_products;

-- Tiến hành xóa View
DROP VIEW view_products;


-- ===================================================
-- BƯỚC 5: TẠO VÀ THAO TÁC VỚI STORED PROCEDURE
-- ===================================================

DELIMITER //

-- 1. Stored Procedure lấy tất cả thông tin sản phẩm
CREATE PROCEDURE getAllProducts()
BEGIN
    SELECT * FROM Products;
END //

-- 2. Stored Procedure thêm một sản phẩm mới
CREATE PROCEDURE addProduct(
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10, 2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status VARCHAR(20)
)
BEGIN
    INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES (p_code, p_name, p_price, p_amount, p_desc, p_status);
END //

-- 3. Stored Procedure chỉnh sửa thông tin sản phẩm theo id
CREATE PROCEDURE updateProductById(
    IN p_id INT,
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10, 2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE Products
    SET productCode = p_code,
        productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_desc,
        productStatus = p_status
    WHERE id = p_id;
END //

-- 4. Stored Procedure xóa sản phẩm theo id
CREATE PROCEDURE deleteProductById(
    IN p_id INT
)
BEGIN
    DELETE FROM Products WHERE id = p_id;
END //

DELIMITER ;


-- --- CHẠY THỬ CÁC STORED PROCEDURE ---

-- Gọi thủ tục lấy tất cả sản phẩm
CALL getAllProducts();

-- Gọi thủ tục thêm sản phẩm mới
CALL addProduct('P006', 'Chuột Logitech MX Master 3S', 100.00, 20, 'Chuột không dây công sở', 'Available');

-- Gọi thủ tục sửa thông tin sản phẩm có id = 1
CALL updateProductById(1, 'P001', 'Laptop Dell XPS 13 Plus', 1600.00, 8, 'Phiên bản nâng cấp', 'Available');

-- Gọi thủ tục xóa sản phẩm có id = 5
CALL deleteProductById(5);

-- Kiểm tra lại danh sách sản phẩm sau các thao tác
CALL getAllProducts();