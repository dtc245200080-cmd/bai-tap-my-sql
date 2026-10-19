USE classicmodels;

-- ===================================================
-- 1. TẠO STORED PROCEDURE
-- ===================================================

-- Đổi Delimiter để MySQL phân biệt câu lệnh trong Procedure
DELIMITER //

-- Tạo Stored Procedure findAllCustomers lấy ra danh sách khách hàng
CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers;
END //

-- Khôi phục lại Delimiter mặc định
DELIMITER ;


-- ===================================================
-- 2. GỌI STORED PROCEDURE
-- ===================================================

-- Thực thi Stored Procedure vừa tạo
CALL findAllCustomers();


-- ===================================================
-- 3. XÓA VÀ TẠO LẠI STORED PROCEDURE (DROP & RE-CREATE)
-- ===================================================

DELIMITER //

-- Xóa Procedure nếu đã tồn tại trước khi tạo lại
DROP PROCEDURE IF EXISTS `findAllCustomers` //

-- Tạo lại Procedure với điều kiện lọc cụ thể (ví dụ: customerNumber = 175)
CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers WHERE customerNumber = 175;
END //

DELIMITER ;

-- Gọi lại Procedure sau khi đã cập nhật
CALL findAllCustomers();