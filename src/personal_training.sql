-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
-- TODO: Write a query to list all personal training sessions for a specific trainer
SELECT 
    p.session_id, 
    m.first_name || ' ' || m.last_name AS member_name, -- concatenates first and last name. 
    p.session_date, 
    p.start_time, 
    p.end_time
FROM personal_training_sessions p
JOIN staff s ON p.staff_id = s.staff_id -- joins staff and personal_training_sessions by staff_id to return the details of the session for each staff member
JOIN members m ON p.member_id = m.member_id -- joins member and personal_training_sessions by member_id to return the details of the session for each member
WHERE s.first_name = 'Ivy' AND s.last_name = 'Irwin' -- filters by Ivy Irwin
ORDER BY p.session_date, p.start_time;
