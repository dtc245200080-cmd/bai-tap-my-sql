USE classicmodels;

-- ===================================================
-- 1. THAM SỐ LOẠI IN (Tham số đầu vào)
-- ===================================================

DELIMITER //

-- Tạo Stored Procedure lấy thông tin khách hàng theo customerNumber
CREATE PROCEDURE getCusById(IN cusNum INT(11))
BEGIN
    SELECT * FROM customers WHERE customerNumber = cusNum;
END //

DELIMITER ;

-- Gọi Stored Procedure với tham số IN = 175
CALL getCusById(175);


-- ===================================================
-- 2. THAM SỐ LOẠI OUT (Tham số đầu ra)
-- ===================================================

DELIMITER //

-- Tạo Stored Procedure đếm số lượng khách hàng ở một thành phố
CREATE PROCEDURE GetCustomersCountByCity(
    IN in_city VARCHAR(50),
    OUT total INT
)
BEGIN
    SELECT COUNT(customerNumber)
    INTO total
    FROM customers
    WHERE city = in_city;
END //

DELIMITER ;

-- Gọi Stored Procedure truyền tham số thành phố và nhận kết quả qua biến @total
CALL GetCustomersCountByCity('Lyon', @total);

-- Hiển thị kết quả trả về
SELECT @total;


-- ===================================================
-- 3. THAM SỐ LOẠI INOUT (Tham số kết hợp cả IN và OUT)
-- ===================================================

DELIMITER //

-- Tạo Stored Procedure tăng giá trị của biến truyền vào theo số lượng chỉ định
CREATE PROCEDURE SetCounter(
    INOUT counter INT,
    IN inc INT
)
BEGIN
    SET counter = counter + inc;
END //

DELIMITER ;

-- Khởi tạo biến @counter = 10
SET @counter = 1;

-- Gọi Stored Procedure tăng @counter thêm 1
CALL SetCounter(@counter, 1); -- @counter thành 2
CALL SetCounter(@counter, 1); -- @counter thành 3
CALL SetCounter(@counter, 5); -- @counter thành 8

-- Hiển thị giá trị cuối cùng của biến @counter
SELECT @counter;