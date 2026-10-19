USE classicmodels;

-- ===================================================
-- 1. TẠO VIEW (CREATE VIEW)
-- ===================================================

-- Tạo bảng ảo customer_views lấy thông tin customerNumber, customerName, phone
CREATE VIEW customer_views AS
SELECT customerNumber, customerName, phone
FROM customers;

-- Truy vấn dữ liệu từ bảng ảo vừa tạo
SELECT * FROM customer_views;


-- ===================================================
-- 2. CẬP NHẬT VIEW (UPDATE VIEW / CREATE OR REPLACE)
-- ===================================================

-- Tiến hành sửa đổi View để bổ sung thêm cột contactFirstName và contactLastName
CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, contactFirstName, contactLastName, phone
FROM customers
WHERE city = 'Nantes';

-- Truy vấn lại để kiểm tra View sau khi đã cập nhật
SELECT * FROM customer_views;


-- ===================================================
-- 3. XÓA VIEW (DROP VIEW)
-- ===================================================

-- Xóa bảng ảo customer_views
DROP VIEW customer_views;