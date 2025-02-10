-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Create your tables here
-- Example:
-- CREATE TABLE table_name (
--     column1 datatype,
--     column2 datatype,
--     ...
-- );
DROP TABLE locations;
DROP TABLE members;
DROP TABLE staff;
DROP TABLE equipment;
DROP TABLE classes;
DROP TABLE class_schedule;
DROP TABLE memberships;
DROP TABLE attendance;
DROP TABLE class_attendance;
DROP TABLE payments;
DROP TABLE personal_training_sessions;
DROP TABLE member_health_metrics;
DROP TABLE equipment_maintenance_log;



CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY, 
    name VARCHAR(50), 
    address TEXT, 
    phone_number VARCHAR(20),
    email VARCHAR(100), 
    opening_hours varchar(15)
);

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY,               
    first_name VARCHAR(50),
    last_name VARCHAR(50),             
    email VARCHAR(100),                  
    phone_number VARCHAR(20),           
    date_of_birth DATETIME,
    join_date DATETIME,
    emergency_contact_name VARCHAR(50),
    emergency_contact_phone 
); 

CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    position CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date DATETIME,
    location_id INTEGER, 
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    type CHECK (type IN ('Cardio', 'Strength')),
    purchase_date DATETIME,
    last_maintenance_date DATETIME,
    next_maintenance_date DATETIME,
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE classes ( 
    class_id INTEGER PRIMARY KEY , 
    name varchar(50), 
    description TEXT, 
    capacity INTEGER, 
    duration INTEGER, 
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)

);

CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY, 
    class_id INTEGER, 
    staff_id INTEGER, 
    start_time DATETIME, 
    end_time DATETIME, 
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)

);

CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY, 
    member_id INTEGER, 
    type VARCHAR(50), 
    start_date DATETIME, 
    end_date DATETIME, 
    status CHECK (status IN ('Active', 'Inactive')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY, 
    member_id INTEGER,
    location_id INTEGER,
    check_in_time DATETIME, 
    check_out_time DATETIME, 
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY, 
    schedule_id INTEGER,
    member_id INTEGER, 
    attendance_status CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id)
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    amount DECIMAL(10, 2),
    payment_date DATETIME,
    payment_method CHECK( payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type CHECK( payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    staff_id INTEGER,
    session_date DATETIME,
    start_time DATETIME,
    end_time DATETIME,
    notes TEXT,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    measurement_date DATETIME,
    weight DECIMAL(5, 1),            
    body_fat_percentage DECIMAL(5, 1),  
    muscle_mass DECIMAL(5, 1),       
    bmi DECIMAL(5, 1),
    FOREIGN KEY (member_id) REFERENCES members(member_id) 
);

CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY,
    equipment_id INTEGER,
    maintenance_date DATETIME,
    description TEXT,
    staff_id INTEGER,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
);
-- TODO: Create the following :
-- 1. locations D
-- 2. members D
-- 3. staff D
-- 4. equipment D
-- 5. classes D
-- 6. class_schedule D
-- 7. memberships D
-- 8. attendance D
-- 9. class_attendance D
-- 10. payments D
-- 11. personal_training_sessions
-- 12. member_health_metrics
-- 13. equipment_maintenance_log

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminaltables