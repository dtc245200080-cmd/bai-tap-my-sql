-- =================================================================
-- PHẦN BÀI TẬP: ĐÁNH INDEX VÀ PHÂN TÍCH HIỆU SUẤT TRUY VẤN
-- =================================================================

USE classicmodels;

-- -----------------------------------------------------------------
-- 1. TRUY VẤN EXPLAIN TRƯỚC VÀ SAU KHI TẠO INDEX CHO customerName
-- -----------------------------------------------------------------

-- Bước 1.1: Sử dụng lệnh EXPLAIN trước khi tạo chỉ mục
-- Phân tích: type = 'ALL' (Full Table Scan), duyệt qua toàn bộ các hàng trong bảng.
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';

-- Bước 1.2: Tạo chỉ mục đơn cho trường customerName
ALTER TABLE customers ADD INDEX idx_customerName(customerName);

-- Bước 1.3: Sử dụng lệnh EXPLAIN sau khi tạo chỉ mục
-- Phân tích: type chuyển thành 'ref', key = 'idx_customerName', số rows duyệt giảm xuống còn 1.
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';


-- -----------------------------------------------------------------
-- 2. TẠO VÀ ĐÁNH GIÁ CHỈ MỤC KÉP (COMPOSITE INDEX)
-- -----------------------------------------------------------------

-- Bước 2.1: Sử dụng lệnh EXPLAIN trước khi tạo chỉ mục kép
EXPLAIN SELECT * FROM customers WHERE contactFirstName = 'Jean' AND contactLastName = 'King';

-- Bước 2.2: Tạo chỉ mục kép cho contactFirstName và contactLastName
ALTER TABLE customers ADD INDEX idx_full_name(contactFirstName, contactLastName);

-- Bước 2.3: Sử dụng lệnh EXPLAIN sau khi tạo chỉ mục kép
-- Phân tích: type = 'ref', key = 'idx_full_name', tối ưu hóa tìm kiếm kết hợp cả 2 cột.
EXPLAIN SELECT * FROM customers WHERE contactFirstName = 'Jean' AND contactLastName = 'King';


-- -----------------------------------------------------------------
-- 3. HƯỚNG DẪN XÓA CHỈ MỤC
-- -----------------------------------------------------------------

-- Xóa chỉ mục đơn idx_customerName
ALTER TABLE customers DROP INDEX idx_customerName;

-- Xóa chỉ mục kép idx_full_name
ALTER TABLE customers DROP INDEX idx_full_name;