-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Class Scheduling Queries

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors

SELECT c.class_id, c.name AS class_name, s.first_name || ' ' || s.last_name AS instructor_name -- selects the classes and instructor name using first and last name
FROM class_schedule cs
LEFT JOIN classes c ON cs.class_id = c.class_id -- left joins the classes table on class_id to get the class name and staff id
LEFT JOIN staff s ON cs.staff_id = s.staff_id; -- left joins the staff table to get the staff name based on staff_id



-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date

SELECT c.class_id, c.name, cs.start_time, cs.end_time, c.capacity - COUNT(ca.member_id) AS available_spots -- selects id, name, timings and the capacity minus the number of members to get the avaliable spots
FROM classes c
JOIN class_schedule cs ON c.class_id = cs.class_id -- joins classes and class_schedule to get relevant details. 
LEFT JOIN class_attendance ca ON cs.schedule_id = ca.schedule_id -- left joins class_attendance and class_schedule to get the number of attendees per class. 
WHERE cs.start_time <= '2025-02-01 23:59:59' AND cs.end_time >= '2025-02-01 00:00:00' --filters for the specified date. 
GROUP BY c.class_id, c.name, cs.start_time, cs.end_time, c.capacity;


-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class

INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES ((SELECT schedule_id
FROM class_schedule
WHERE class_id = 3
  AND STRFTIME('%Y-%m-%d', start_time) = '2025-02-01'), 11, 'Registered');

-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration
DELETE FROM class_attendance
WHERE schedule_id = 7
  AND member_id = 2;

  
-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes

SELECT c.class_id, 
       c.name AS class_name, 
       COUNT(ca.member_id) AS registration_count -- counts number of members registered per class
FROM classes c
JOIN class_schedule cs ON c.class_id = cs.class_id -- joins classes on class_schedule to return details 
JOIN class_attendance ca ON cs.schedule_id = ca.schedule_id -- joins class_attendance on class_schedule to count members per class
GROUP BY c.class_id, c.name
ORDER BY registration_count DESC
LIMIT 3;


-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member

SELECT AVG(class_count) AS average_classes_per_member -- Calculates the average number of classes attended per member by averaging the class_count from the subquery.
FROM (
    SELECT COUNT(ca.schedule_id) AS class_count -- Counts the number of classes attended by each member based on schedule_id for each member_id.
    FROM class_attendance ca
    GROUP BY ca.member_id-- Groups the result by member_id to get the class count for each individual member.
) AS member_class_counts;
-- The subquery generates a list of class counts for each member, which is then averaged in the outer query.

