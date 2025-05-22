-- =====================================================
-- 10 SIMPLE CASE SCENARIOS WITH BASIC SELECT QUERIES
-- School Management System Database
-- =====================================================

-- CASE SCENARIOS OVERVIEW:
-- 1. View All Active Users - Admin needs to see all active system users
-- 2. Find Students by Blood Group - Medical emergency requires specific blood group students
-- 3. List Core Subjects - Academic planner needs all mandatory subjects
-- 4. Check High Performing Students - Principal wants students with A+ grades
-- 5. Find Overdue Fee Payments - Finance team needs overdue payment tracking
-- 6. View Recent Login Activities - Security audit of recent user logins
-- 7. List Emergency Contacts - Office needs guardian emergency contact numbers
-- 8. Find Classes with Low Capacity - Infrastructure planning for classroom optimization
-- 9. View System Configuration - IT admin needs current system settings
-- 10. Check Exam Schedule for Specific Date - Students need exam information

USE SchoolManagementSystem;
GO

-- =====================================================
-- CASE 1: View All Active Users
-- Scenario: System admin needs to see all active users in the system
-- =====================================================

PRINT '=== CASE 1: View All Active Users ===';

SELECT 
    UserID,
    Username,
    RoleID,
    IsActive,
    LastLogin,
    CreatedDate,
    ModifiedDate
FROM Users
WHERE IsActive = 1
ORDER BY CreatedDate DESC;

-- =====================================================
-- CASE 2: Find Students by Blood Group
-- Scenario: Medical emergency - need all students with O+ blood group
-- =====================================================

PRINT '=== CASE 2: Find Students by Blood Group O+ ===';

SELECT 
    StudentID,
    UserID,
    AdmissionNumber,
    AdmissionDate,
    ClassID,
    RollNumber,
    BloodGroup,
    MedicalInfo
FROM Students
WHERE BloodGroup = 'O+'
ORDER BY AdmissionNumber;

-- =====================================================
-- CASE 3: List All Core Subjects
-- Scenario: Academic planner needs list of all mandatory/core subjects
-- =====================================================

PRINT '=== CASE 3: List All Core Subjects ===';

SELECT 
    SubjectID,
    SubjectName,
    SubjectCode,
    Credits,
    Department,
    IsCore
FROM Subjects
WHERE IsCore = 1
ORDER BY Department, SubjectName;

-- =====================================================
-- CASE 4: Find High Performing Students
-- Scenario: Principal wants to see all students who scored A+ grades
-- =====================================================

PRINT '=== CASE 4: High Performing Students with A+ Grades ===';

SELECT 
    MarkID,
    ExamID,
    StudentID,
    MarksObtained,
    Grade,
    Remarks,
    EnteredBy,
    EnteredDate
FROM StudentMarks
WHERE Grade = 'A+'
ORDER BY MarksObtained DESC;

-- =====================================================
-- CASE 5: Find Recent Fee Payments
-- Scenario: Finance team needs to see all payments made in the last 30 days
-- =====================================================

PRINT '=== CASE 5: Recent Fee Payments (Last 30 Days) ===';

SELECT 
    PaymentID,
    StudentID,
    StructureID,
    AmountPaid,
    PaymentDate,
    PaymentMethod,
    ReceiptNumber
FROM FeePayments
WHERE PaymentDate >= DATEADD(DAY, -30, GETDATE())
ORDER BY PaymentDate DESC;

-- =====================================================
-- CASE 6: View Recent Login Activities
-- Scenario: Security audit - check all logins from the last 7 days
-- =====================================================

PRINT '=== CASE 6: Recent Login Activities (Last 7 Days) ===';

SELECT 
    SessionID,
    UserID,
    LoginTime,
    LogoutTime,
    IPAddress,
    DeviceInfo
FROM UserSessions
WHERE LoginTime >= DATEADD(DAY, -7, GETDATE())
ORDER BY LoginTime DESC;

-- =====================================================
-- CASE 7: List Emergency Contact Guardians
-- Scenario: Office needs all guardians marked as emergency contacts
-- =====================================================

PRINT '=== CASE 7: Emergency Contact Guardians ===';

SELECT 
    StudentID,
    GuardianID,
    IsPrimary,
    EmergencyContact
FROM StudentGuardians
WHERE EmergencyContact = 1
ORDER BY StudentID;

-- =====================================================
-- CASE 8: Find Classes with Low Capacity
-- Scenario: Infrastructure planning - find classes with capacity less than 30
-- =====================================================

PRINT '=== CASE 8: Classes with Low Capacity (Less than 30) ===';

SELECT 
    ClassID,
    ClassName,
    Section,
    YearID,
    Capacity,
    ClassTeacherID,
    Room
FROM Classes
WHERE Capacity < 30
ORDER BY Capacity ASC;

-- =====================================================
-- CASE 9: View Current System Settings
-- Scenario: IT admin needs to check current system configuration
-- =====================================================

PRINT '=== CASE 9: Current System Settings ===';

SELECT 
    SettingID,
    SettingName,
    SettingValue,
    Description,
    ModifiedBy,
    ModifiedDate
FROM SystemSettings
ORDER BY ModifiedDate DESC;

-- =====================================================
-- CASE 10: Check Exams for Specific Date
-- Scenario: Students want to see all exams scheduled for a specific date
-- =====================================================

PRINT '=== CASE 10: Exams Scheduled for May 15, 2024 ===';

SELECT 
    ExamID,
    ExamName,
    ExamTypeID,
    ClassID,
    SubjectID,
    ExamDate,
    Duration,
    TotalMarks,
    YearID
FROM Exams
WHERE ExamDate = '2024-05-15'
ORDER BY ExamDate, ExamName;

-- =====================================================
-- BONUS QUERIES: Additional Simple Cases
-- =====================================================

PRINT '=== BONUS: Additional Simple Queries ===';

-- Find all teachers (Role ID 3)
PRINT '--- All Teachers ---';
SELECT UserID, Username, RoleID, IsActive, LastLogin
FROM Users
WHERE RoleID = 3 AND IsActive = 1;

-- Find students admitted this year
PRINT '--- Students Admitted in 2024 ---';
SELECT StudentID, AdmissionNumber, AdmissionDate, ClassID
FROM Students
WHERE YEAR(AdmissionDate) = 2024;

-- Find optional subjects
PRINT '--- Optional/Elective Subjects ---';
SELECT SubjectID, SubjectName, SubjectCode, Department
FROM Subjects
WHERE IsCore = 0;

-- Find cash payments
PRINT '--- Cash Payments Only ---';
SELECT PaymentID, StudentID, AmountPaid, PaymentDate, PaymentMethod
FROM FeePayments
WHERE PaymentMethod = 'Cash';

-- Find unread notifications
PRINT '--- Unread Notifications ---';
SELECT NotificationID, SenderID, RecipientID, Title, SentDate
FROM Notifications
WHERE ReadDate IS NULL;

PRINT '';
PRINT '=== END OF 10 SIMPLE CASE SCENARIOS ===';
PRINT 'All basic SELECT queries executed successfully!';
PRINT 'These cases use only SELECT and WHERE clauses without JOINs.';
GO