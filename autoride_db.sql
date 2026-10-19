-- =========================================================
-- AUTORIDE: TOI UU CO SO DU LIEU QUAN LY THUE XE
-- File: autoride_db.sql
-- Script danh cho moi truong thuc hanh.
-- Neu da co du lieu can giu, hay sao luu truoc khi chay.
-- =========================================================

CREATE DATABASE IF NOT EXISTS autoride_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE autoride_db;

CREATE TABLE IF NOT EXISTS Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Tao bang Rentals moi cho bai thuc hanh.
-- Neu nang cap CSDL dang co du lieu, xem phan ALTER TABLE o cuoi file.
DROP TABLE IF EXISTS Inspections;
DROP TABLE IF EXISTS Rentals;

CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME NULL,
    status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED')
        NOT NULL DEFAULT 'BOOKED',
    security_deposit DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    late_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    damage_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT chk_security_deposit CHECK (security_deposit >= 0),
    CONSTRAINT chk_late_fee CHECK (late_fee >= 0),
    CONSTRAINT chk_damage_fee CHECK (damage_fee >= 0),
    CONSTRAINT chk_fees_not_over_deposit
        CHECK (late_fee + damage_fee <= security_deposit),
    CONSTRAINT fk_rentals_cars
        FOREIGN KEY (car_id) REFERENCES Cars(car_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT NOT NULL,
    inspector_name VARCHAR(100) NOT NULL,
    CONSTRAINT fk_inspections_rentals
        FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================================
-- DU LIEU KIEM THU
-- =========================================================
INSERT INTO Cars (model_name, license_plate)
VALUES ('Toyota Vios', '30A-12345');

SET @car_id = LAST_INSERT_ID();

-- Khach Nguyen Van A thue xe, dat coc 10.000.000 VND.
INSERT INTO Rentals
    (car_id, customer_name, rent_date, status,
     security_deposit, late_fee, damage_fee)
VALUES
    (@car_id, 'Nguyen Van A', NOW(), 'ACTIVE',
     10000000.00, 0.00, 0.00);

SET @rental_id = LAST_INSERT_ID();

-- Khi khach tra xe, nhan vien kiem tra va ghi nhan loi.
INSERT INTO Inspections
    (rental_id, inspection_date, damage_description, inspector_name)
VALUES
    (@rental_id, NOW(), 'Vo den pha trai', 'Tran Thi B');

-- Cap nhat ket qua tra xe: khong phat tre, phi sua chua 2 trieu.
UPDATE Rentals
SET status = 'COMPLETED',
    return_date = NOW(),
    late_fee = 0.00,
    damage_fee = 2000000.00
WHERE rental_id = @rental_id
  AND status = 'ACTIVE';

-- Tinh tien hoan lai. COALESCE phong truong hop cot tien la NULL
-- neu du lieu cu khong co gia tri.
SELECT
    r.rental_id,
    r.customer_name,
    r.status,
    r.security_deposit,
    r.late_fee,
    r.damage_fee,
    (COALESCE(r.security_deposit, 0)
     - COALESCE(r.late_fee, 0)
     - COALESCE(r.damage_fee, 0)) AS refund_amount,
    i.damage_description,
    i.inspector_name,
    i.inspection_date
FROM Rentals AS r
LEFT JOIN Inspections AS i ON i.rental_id = r.rental_id
WHERE r.rental_id = @rental_id;

-- =========================================================
-- PHU LUC: CAC LENH ALTER TABLE KHI NANG CAP BANG CU
-- KHONG CHAY PHAN NAY SAU KHI DA TAO BANG Rentals MOI O TREN.
-- Neu muon bao toan du lieu cu, hay dung ALTER thay cho DROP/CREATE.
-- Kiem tra du lieu va ten rang buoc truoc khi ap dung.
-- =========================================================
-- ALTER TABLE Rentals
--   MODIFY COLUMN status ENUM('BOOKED','ACTIVE','COMPLETED','CANCELLED')
--   NOT NULL DEFAULT 'BOOKED';
--
-- ALTER TABLE Rentals
--   ADD COLUMN security_deposit DECIMAL(10,2) NOT NULL DEFAULT 0.00,
--   ADD COLUMN late_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
--   ADD COLUMN damage_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00;
--
-- CREATE TABLE Inspections (
--   inspection_id INT AUTO_INCREMENT PRIMARY KEY,
--   rental_id INT NOT NULL,
--   inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
--   damage_description TEXT NOT NULL,
--   inspector_name VARCHAR(100) NOT NULL,
--   CONSTRAINT fk_inspections_rentals
--     FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id)
--     ON UPDATE CASCADE ON DELETE RESTRICT
-- ) ENGINE=InnoDB;

-- GHI CHU:
-- CHECK constraints duoc thuc thi tu MySQL 8.0.16 tro len.
-- Muon ngan inspection khi rental chua ACTIVE, can dung TRIGGER.
-- Script co ban nay chua tao trigger; can bo sung neu bai yeu cau.
