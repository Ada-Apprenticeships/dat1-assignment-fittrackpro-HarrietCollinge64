-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Staff Management Queries

-- 1. List all staff members by role
-- TODO: Write a query to list all staff members by role
SELECT staff_id, first_name, last_name, position AS role
FROM staff
ORDER BY role;


-- 2. Find trainers with one or more personal training session in the next 30 days
-- TODO: Write a query to find trainers with one or more personal training session in the next 30 days

SELECT s.staff_id AS trainer_id, s.first_name || ' ' || s.last_name AS trainer_name, COUNT(p.session_id) AS session_count 
FROM staff s
JOIN personal_training_sessions p ON s.staff_id = p.staff_id -- joins tables on staff_id to get details for the sessions based on staff member
WHERE p.session_date BETWEEN DATE('now') AND DATE('now', '+30 days') -- filters for the next 30 days 
GROUP BY s.staff_id
HAVING session_count > 0 -- Filters out trainers who don't have any sessions in the specified date range, ensuring only those with sessions are included.
ORDER BY session_count DESC;
