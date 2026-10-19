-- =========================================================
-- HEALTHSYNC: TOI UU CO SO DU LIEU QUAN LY KHAM BENH
-- File: healthsync_db.sql
-- Luu y: Script nay tao lai cac bang HealthSync de kiem thu.
-- Neu dang co du lieu can giu lai, hay sao luu truoc khi chay.
-- =========================================================

CREATE DATABASE IF NOT EXISTS healthsync_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE healthsync_db;

-- Tao cac bang nen neu chua ton tai
CREATE TABLE IF NOT EXISTS Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
) ENGINE=InnoDB;

-- Xoa bang phu truoc de co the chay lai script trong moi truong bai tap.
-- Chi dung cac lenh DROP nay neu day la CSDL thuc hanh, khong co du lieu can giu.
DROP TABLE IF EXISTS Prescriptions;
DROP TABLE IF EXISTS Appointments;

CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM(
        'PENDING',
        'CONFIRMED',
        'CHECKED_IN',
        'COMPLETED',
        'CANCELLED'
    ) NOT NULL DEFAULT 'PENDING',
    deposit_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    penalty_fee DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    cancel_reason VARCHAR(255) NULL,
    CONSTRAINT chk_appointment_deposit
        CHECK (deposit_amount >= 0),
    CONSTRAINT chk_appointment_penalty
        CHECK (penalty_fee >= 0),
    CONSTRAINT chk_penalty_not_over_deposit
        CHECK (penalty_fee <= deposit_amount),
    CONSTRAINT fk_appointment_patient
        FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_appointment_doctor
        FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    medication_details TEXT NOT NULL,
    issued_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_prescription_appointment UNIQUE (appointment_id),
    CONSTRAINT fk_prescription_appointment
        FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Du lieu mau
INSERT INTO Patients (full_name, phone) VALUES
('Nguyen Van An', '0900000001'),
('Tran Thi Binh', '0900000002');

INSERT INTO Doctors (full_name, specialty) VALUES
('Dr. Le Minh', 'Noi tong quat'),
('Dr. Pham Hoa', 'Da lieu');

-- =========================================================
-- KICH BAN 1: DAT LICH, DEN KHAM, HOAN TAT VA KE DON
-- =========================================================

-- Tao lich hen PENDING, coc 500.000 dong
INSERT INTO Appointments
    (patient_id, doctor_id, appointment_date, status, deposit_amount, penalty_fee)
VALUES
    (1, 1, '2026-10-20 09:00:00', 'PENDING', 500000.00, 0.00);

SET @successful_appointment_id = LAST_INSERT_ID();

-- Xac nhan da nhan tien coc
UPDATE Appointments
SET status = 'CONFIRMED'
WHERE appointment_id = @successful_appointment_id
  AND status = 'PENDING';

-- Benh nhan da den phong kham
UPDATE Appointments
SET status = 'CHECKED_IN'
WHERE appointment_id = @successful_appointment_id
  AND status = 'CONFIRMED';

-- Bac si hoan tat kham
UPDATE Appointments
SET status = 'COMPLETED'
WHERE appointment_id = @successful_appointment_id
  AND status = 'CHECKED_IN';

-- Tao don thuoc cho lich hen da hoan tat
INSERT INTO Prescriptions (appointment_id, medication_details, issued_date)
SELECT appointment_id,
       'Vi du minh hoa: thuoc A theo chi dinh bac si; can xac nhan don thuc te.',
       NOW()
FROM Appointments
WHERE appointment_id = @successful_appointment_id
  AND status = 'COMPLETED';

-- =========================================================
-- KICH BAN 2: HUY LICH VA TINH PHAT
-- =========================================================

-- Tao lich hen da xac nhan, coc 300.000 dong
INSERT INTO Appointments
    (patient_id, doctor_id, appointment_date, status, deposit_amount, penalty_fee)
VALUES
    (2, 2, '2026-10-21 14:00:00', 'CONFIRMED', 300000.00, 0.00);

SET @cancelled_appointment_id = LAST_INSERT_ID();

-- Huy lich, ghi ly do va phi phat 150.000 dong
UPDATE Appointments
SET status = 'CANCELLED',
    cancel_reason = 'Ban viec dot xuat',
    penalty_fee = 150000.00
WHERE appointment_id = @cancelled_appointment_id
  AND status = 'CONFIRMED'
  AND penalty_fee <= deposit_amount;

-- =========================================================
-- TRUY VAN KIEM TRA
-- =========================================================

-- 1. Kiem tra trang thai, tien coc, phi phat va tien coc con lai
SELECT
    appointment_id,
    status,
    deposit_amount,
    penalty_fee,
    (deposit_amount - penalty_fee) AS remaining_deposit,
    cancel_reason
FROM Appointments
ORDER BY appointment_id;

-- 2. Danh sach benh nhan da hoan tat kham va don thuoc
SELECT
    p.patient_id,
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    a.appointment_id,
    a.appointment_date,
    a.status,
    rx.prescription_id,
    rx.medication_details,
    rx.issued_date
FROM Appointments AS a
JOIN Patients AS p ON p.patient_id = a.patient_id
JOIN Doctors AS d ON d.doctor_id = a.doctor_id
JOIN Prescriptions AS rx ON rx.appointment_id = a.appointment_id
WHERE a.status = 'COMPLETED';

-- 3. Kiem tra cac lich da huy
SELECT
    appointment_id,
    deposit_amount,
    penalty_fee,
    deposit_amount - penalty_fee AS remaining_deposit,
    cancel_reason
FROM Appointments
WHERE status = 'CANCELLED';

-- GHI CHU THIET KE:
-- UNIQUE(appointment_id) trong Prescriptions quy dinh moi lich hen
-- co toi da mot don thuoc.
-- FK RESTRICT tranh xoa lich hen khi van con don thuoc.
-- CHECK constraint duoc MySQL thuc thi tu MySQL 8.0.16 tro len.
-- De chan don thuoc cho lich chua COMPLETED mot cach truc tiep tai DB,
-- can bo sung TRIGGER (khong duoc thuc hien trong script co ban nay).
