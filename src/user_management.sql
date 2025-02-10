-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- User Management Queries

-- 1. Retrieve all members
-- TODO: Write a query to retrieve all members
SELECT * FROM members;

-- 2. Update a member's contact information
-- TODO: Write a query to update a member's contact information
UPDATE members
SET email='emily.jones.updated@email.com' , phone_number='555-9876'
WHERE member_id=5;

-- 3. Count total number of members
-- TODO: Write a query to count the total number of members
SELECT COUNT(*)
FROM members;


-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations

SELECT members.member_id, members.first_name, members.last_name, COUNT(class_attendance.class_attendance_id) AS registration_count
FROM members
JOIN class_attendance ON members.member_id = class_attendance.member_id -- join tables on member_id to link member with their attendance record
WHERE class_attendance.attendance_status = 'Registered'
GROUP BY members.member_id, members.first_name, members.last_name -- Groups the results by member_id, first name, and last name to count the number of classes each member has registered for.
ORDER BY registration_count DESC
LIMIT 1; -- returns only the top result. 

-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations
SELECT members.member_id, members.first_name, members.last_name, COUNT(class_attendance.class_attendance_id) AS registration_count
FROM members
JOIN class_attendance ON members.member_id = class_attendance.member_id
WHERE class_attendance.attendance_status = 'Registered'
GROUP BY members.member_id, members.first_name, members.last_name
ORDER BY registration_count ASC -- query does the same as 4. but orders by ascending to find the lowest registration rather than highest
LIMIT 1; 

-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class

SELECT (COUNT(DISTINCT class_attendance.member_id) * 100.0) / (SELECT COUNT(*) FROM members) AS attendance_percentage
FROM  class_attendance
WHERE class_attendance.attendance_status = 'Attended';
