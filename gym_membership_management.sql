-- GYM MEMBERSHIP MANAGEMENT SYSTEM
-- Student: Muskan Gupta | UID: 25BCD10069
-- Department: BCA Data Science
-- Submitted to: Ms. Harkamal Kaur

CREATE DATABASE gym_management;
USE gym_management;

CREATE TABLE membership_plans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(30) NOT NULL,
    duration_months INT NOT NULL,
    fee DECIMAL(8,2) NOT NULL
);

CREATE TABLE trainers (
    trainer_id INT PRIMARY KEY AUTO_INCREMENT,
    trainer_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(40),
    phone VARCHAR(15)
);

CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    member_name VARCHAR(50) NOT NULL,
    age INT,
    phone VARCHAR(15),
    join_date DATE,
    plan_id INT,
    trainer_id INT,
    FOREIGN KEY (plan_id) REFERENCES membership_plans(plan_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    amount DECIMAL(8,2) NOT NULL,
    payment_date DATE,
    payment_status VARCHAR(20) DEFAULT 'Paid',
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    check_in TIME,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Sample records
INSERT INTO membership_plans (plan_name, duration_months, fee) VALUES
('Monthly', 1, 1200.00),
('Quarterly', 3, 3200.00),
('Yearly', 12, 10000.00);

INSERT INTO trainers (trainer_name, specialization, phone) VALUES
('Aman Sharma', 'Strength Training', '9876501234'),
('Neha Verma', 'Yoga and Fitness', '9876505678');

INSERT INTO members (member_name, age, phone, join_date, plan_id, trainer_id) VALUES
('Muskan Gupta', 21, '9876511111', '2026-10-01', 2, 1),
('Riya Singh', 22, '9876522222', '2026-10-05', 1, 2),
('Aarav Mehta', 23, '9876533333', '2026-10-10', 3, 1);

INSERT INTO payments (member_id, amount, payment_date, payment_status) VALUES
(1, 3200.00, '2026-10-01', 'Paid'),
(2, 1200.00, '2026-10-05', 'Paid'),
(3, 10000.00, '2026-10-10', 'Pending');

INSERT INTO attendance (member_id, attendance_date, check_in) VALUES
(1, '2026-10-20', '07:15:00'),
(2, '2026-10-20', '08:00:00'),
(1, '2026-10-21', '07:20:00');

-- 1. Display all members with their plan and trainer
SELECT m.member_id, m.member_name, p.plan_name, t.trainer_name
FROM members m
JOIN membership_plans p ON m.plan_id = p.plan_id
JOIN trainers t ON m.trainer_id = t.trainer_id;

-- 2. Display payments that are pending
SELECT payment_id, member_id, amount, payment_status
FROM payments
WHERE payment_status = 'Pending';

-- 3. Count members in each membership plan
SELECT p.plan_name, COUNT(m.member_id) AS total_members
FROM membership_plans p
LEFT JOIN members m ON p.plan_id = m.plan_id
GROUP BY p.plan_id, p.plan_name;

-- 4. Calculate total revenue received (only Paid payments)
SELECT SUM(amount) AS total_revenue
FROM payments
WHERE payment_status = 'Paid';

-- 5. Create a view for a quick member summary
CREATE VIEW member_summary AS
SELECT m.member_id, m.member_name, p.plan_name, p.fee, t.trainer_name
FROM members m
JOIN membership_plans p ON m.plan_id = p.plan_id
JOIN trainers t ON m.trainer_id = t.trainer_id;

SELECT * FROM member_summary;

-- 6. Update a payment after receiving the fee
UPDATE payments
SET payment_status = 'Paid'
WHERE payment_id = 3;

SELECT payment_id, amount, payment_status FROM payments;

-- 7. Example delete (run only if you want to remove this attendance row)
-- DELETE FROM attendance WHERE attendance_id = 3;
