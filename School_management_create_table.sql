USE SchoolManagementSystem;
GO

-- =====================================================
-- Step 2: Create Tables with Filegroup Specifications
-- =====================================================

-- USERS & AUTHENTICATION TABLES (UserData_FG)
-- =====================================================

-- Roles Table
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME2 NOT NULL DEFAULT GETDATE()
) ON UserData_FG;

-- Users Table
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Salt NVARCHAR(255) NOT NULL,
    RoleID INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    LastLogin DATETIME2,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
) ON UserData_FG;

-- User Profiles Table
CREATE TABLE UserProfiles (
    ProfileID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Phone NVARCHAR(20),
    Address NVARCHAR(500),
    DOB DATE,
    Gender NVARCHAR(10) CHECK (Gender IN ('Male', 'Female', 'Other')),
    ProfilePicture NVARCHAR(255),
    CONSTRAINT FK_UserProfiles_Users FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
) ON UserData_FG;

-- User Sessions Table  
CREATE TABLE UserSessions (
    SessionID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    LoginTime DATETIME2 NOT NULL DEFAULT GETDATE(),
    LogoutTime DATETIME2,
    IPAddress NVARCHAR(45),
    DeviceInfo NVARCHAR(255),
    CONSTRAINT FK_UserSessions_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
) ON UserData_FG;

-- ACADEMIC STRUCTURE TABLES (UserData_FG)
-- =====================================================

-- Academic Years Table
CREATE TABLE AcademicYears (
    YearID INT IDENTITY(1,1) PRIMARY KEY,
    YearName NVARCHAR(20) NOT NULL UNIQUE,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT CHK_AcademicYear_Dates CHECK (EndDate > StartDate)
) ON UserData_FG;

-- Classes Table
CREATE TABLE Classes (
    ClassID INT IDENTITY(1,1) PRIMARY KEY,
    ClassName NVARCHAR(50) NOT NULL,
    Section NVARCHAR(10) NOT NULL,
    YearID INT NOT NULL,
    Capacity INT NOT NULL DEFAULT 30,
    ClassTeacherID INT,
    Room NVARCHAR(20),
    CONSTRAINT FK_Classes_AcademicYears FOREIGN KEY (YearID) REFERENCES AcademicYears(YearID),
    CONSTRAINT FK_Classes_ClassTeacher FOREIGN KEY (ClassTeacherID) REFERENCES Users(UserID),
    CONSTRAINT UQ_Classes_Year_Section UNIQUE (ClassName, Section, YearID)
) ON UserData_FG;

-- Subjects Table
CREATE TABLE Subjects (
    SubjectID INT IDENTITY(1,1) PRIMARY KEY,
    SubjectName NVARCHAR(100) NOT NULL,
    SubjectCode NVARCHAR(20) NOT NULL UNIQUE,
    Credits INT NOT NULL DEFAULT 1,
    Department NVARCHAR(50),
    IsCore BIT NOT NULL DEFAULT 1
) ON UserData_FG;

-- Class Routine Table
CREATE TABLE ClassRoutine (
    RoutineID INT IDENTITY(1,1) PRIMARY KEY,
    ClassID INT NOT NULL,
    SubjectID INT NOT NULL,
    TeacherID INT NOT NULL,
    DayOfWeek TINYINT NOT NULL CHECK (DayOfWeek BETWEEN 1 AND 7),
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Room NVARCHAR(20),
    YearID INT NOT NULL,
    CONSTRAINT FK_ClassRoutine_Classes FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    CONSTRAINT FK_ClassRoutine_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID),
    CONSTRAINT FK_ClassRoutine_Teachers FOREIGN KEY (TeacherID) REFERENCES Users(UserID),
    CONSTRAINT FK_ClassRoutine_AcademicYears FOREIGN KEY (YearID) REFERENCES AcademicYears(YearID),
    CONSTRAINT CHK_ClassRoutine_Time CHECK (EndTime > StartTime)
) ON UserData_FG;

-- STUDENT MANAGEMENT TABLES (UserData_FG)
-- =====================================================

-- Guardians Table
CREATE TABLE Guardians (
    GuardianID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Relationship NVARCHAR(20) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100),
    Address NVARCHAR(500),
    Occupation NVARCHAR(100),
    Income DECIMAL(10,2)
) ON UserData_FG;

-- Students Table
CREATE TABLE Students (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    AdmissionNumber NVARCHAR(20) NOT NULL UNIQUE,
    AdmissionDate DATE NOT NULL,
    ClassID INT NOT NULL,
    RollNumber NVARCHAR(20),
    BloodGroup NVARCHAR(5) CHECK (BloodGroup IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    MedicalInfo NVARCHAR(1000),
    CONSTRAINT FK_Students_Users FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    CONSTRAINT FK_Students_Classes FOREIGN KEY (ClassID) REFERENCES Classes(ClassID)
) ON UserData_FG;

-- Student Guardians Table
CREATE TABLE StudentGuardians (
    StudentID INT NOT NULL,
    GuardianID INT NOT NULL,
    IsPrimary BIT NOT NULL DEFAULT 0,
    EmergencyContact BIT NOT NULL DEFAULT 0,
    PRIMARY KEY (StudentID, GuardianID),
    CONSTRAINT FK_StudentGuardians_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE,
    CONSTRAINT FK_StudentGuardians_Guardians FOREIGN KEY (GuardianID) REFERENCES Guardians(GuardianID)
) ON UserData_FG;

-- ASSESSMENT SYSTEM TABLES (TransData_FG)
-- =====================================================

-- Exam Types Table
CREATE TABLE ExamTypes (
    ExamTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    WeightPercentage DECIMAL(5,2) NOT NULL DEFAULT 0,
    CONSTRAINT CHK_ExamTypes_Weight CHECK (WeightPercentage BETWEEN 0 AND 100)
) ON TransData_FG;

-- Exams Table
CREATE TABLE Exams (
    ExamID INT IDENTITY(1,1) PRIMARY KEY,
    ExamName NVARCHAR(100) NOT NULL,
    ExamTypeID INT NOT NULL,
    ClassID INT NOT NULL,
    SubjectID INT NOT NULL,
    ExamDate DATE NOT NULL,
    Duration INT NOT NULL, -- in minutes
    TotalMarks INT NOT NULL,
    YearID INT NOT NULL,
    CONSTRAINT FK_Exams_ExamTypes FOREIGN KEY (ExamTypeID) REFERENCES ExamTypes(ExamTypeID),
    CONSTRAINT FK_Exams_Classes FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    CONSTRAINT FK_Exams_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID),
    CONSTRAINT FK_Exams_AcademicYears FOREIGN KEY (YearID) REFERENCES AcademicYears(YearID)
) ON TransData_FG;

-- Student Marks Table
CREATE TABLE StudentMarks (
    MarkID INT IDENTITY(1,1) PRIMARY KEY,
    ExamID INT NOT NULL,
    StudentID INT NOT NULL,
    MarksObtained DECIMAL(5,2) NOT NULL,
    Grade NVARCHAR(5),
    Remarks NVARCHAR(255),
    EnteredBy INT NOT NULL,
    EnteredDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_StudentMarks_Exams FOREIGN KEY (ExamID) REFERENCES Exams(ExamID),
    CONSTRAINT FK_StudentMarks_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_StudentMarks_EnteredBy FOREIGN KEY (EnteredBy) REFERENCES Users(UserID),
    CONSTRAINT UQ_StudentMarks_Exam_Student UNIQUE (ExamID, StudentID)
) ON TransData_FG;

-- FINANCIAL MANAGEMENT TABLES (TransData_FG)
-- =====================================================

-- Fee Types Table
CREATE TABLE FeeTypes (
    FeeTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    IsOptional BIT NOT NULL DEFAULT 0
) ON TransData_FG;

-- Fee Structure Table
CREATE TABLE FeeStructure (
    StructureID INT IDENTITY(1,1) PRIMARY KEY,
    ClassID INT NOT NULL,
    FeeTypeID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    DueDate DATE NOT NULL,
    YearID INT NOT NULL,
    CONSTRAINT FK_FeeStructure_Classes FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    CONSTRAINT FK_FeeStructure_FeeTypes FOREIGN KEY (FeeTypeID) REFERENCES FeeTypes(FeeTypeID),
    CONSTRAINT FK_FeeStructure_AcademicYears FOREIGN KEY (YearID) REFERENCES AcademicYears(YearID),
    CONSTRAINT UQ_FeeStructure_Class_Type_Year UNIQUE (ClassID, FeeTypeID, YearID)
) ON TransData_FG;

-- Fee Payments Table
CREATE TABLE FeePayments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    StructureID INT NOT NULL,
    AmountPaid DECIMAL(10,2) NOT NULL,
    PaymentDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    PaymentMethod NVARCHAR(20) NOT NULL CHECK (PaymentMethod IN ('Cash', 'Card', 'Bank Transfer', 'Cheque', 'Online')),
    ReceiptNumber NVARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT FK_FeePayments_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_FeePayments_FeeStructure FOREIGN KEY (StructureID) REFERENCES FeeStructure(StructureID)
) ON TransData_FG;

-- ADDITIONAL SUPPORTING TABLES
-- =====================================================

-- Attendance Table (TransData_FG)
CREATE TABLE Attendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    ClassSubjectID INT NOT NULL, -- References ClassRoutine
    Date DATE NOT NULL,
    Status NVARCHAR(10) NOT NULL CHECK (Status IN ('Present', 'Absent', 'Late', 'Excused')),
    Remarks NVARCHAR(255),
    MarkedBy INT NOT NULL,
    CONSTRAINT FK_Attendance_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Attendance_ClassRoutine FOREIGN KEY (ClassSubjectID) REFERENCES ClassRoutine(RoutineID),
    CONSTRAINT FK_Attendance_MarkedBy FOREIGN KEY (MarkedBy) REFERENCES Users(UserID),
    CONSTRAINT UQ_Attendance_Student_ClassSubject_Date UNIQUE (StudentID, ClassSubjectID, Date)
) ON TransData_FG;

-- Teacher Attendance Table (TransData_FG)
CREATE TABLE TeacherAttendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    TeacherID INT NOT NULL,
    Date DATE NOT NULL,
    Status NVARCHAR(10) NOT NULL CHECK (Status IN ('Present', 'Absent', 'Half Day', 'Late')),
    CheckInTime TIME,
    CheckOutTime TIME,
    CONSTRAINT FK_TeacherAttendance_Teachers FOREIGN KEY (TeacherID) REFERENCES Users(UserID),
    CONSTRAINT UQ_TeacherAttendance_Teacher_Date UNIQUE (TeacherID, Date)
) ON TransData_FG;

-- Notifications Table (UserData_FG)
CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    SenderID INT NOT NULL,
    RecipientID INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Message NVARCHAR(1000) NOT NULL,
    Type NVARCHAR(20) NOT NULL CHECK (Type IN ('General', 'Academic', 'Financial', 'Emergency', 'System')),
    SentDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    ReadDate DATETIME2,
    CONSTRAINT FK_Notifications_Sender FOREIGN KEY (SenderID) REFERENCES Users(UserID),
    CONSTRAINT FK_Notifications_Recipient FOREIGN KEY (RecipientID) REFERENCES Users(UserID)
) ON UserData_FG;

-- System Settings Table (PRIMARY)
CREATE TABLE SystemSettings (
    SettingID INT IDENTITY(1,1) PRIMARY KEY,
    SettingName NVARCHAR(50) NOT NULL UNIQUE,
    SettingValue NVARCHAR(1000) NOT NULL,
    Description NVARCHAR(255),
    ModifiedBy INT NOT NULL,
    ModifiedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_SystemSettings_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
) ON [PRIMARY];

-- Audit Log Table (AuditData_FG)
CREATE TABLE AuditLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    Action NVARCHAR(50) NOT NULL,
    TableName NVARCHAR(50) NOT NULL,
    RecordID INT,
    OldValues NVARCHAR(MAX),
    NewValues NVARCHAR(MAX),
    Timestamp DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_AuditLog_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
) ON AuditData_FG;

-- =====================================================
-- Create Indexes for Performance
-- =====================================================

-- Users table indexes
CREATE INDEX IX_Users_Username ON Users(Username);
CREATE INDEX IX_Users_RoleID ON Users(RoleID);
CREATE INDEX IX_Users_IsActive ON Users(IsActive);

-- Students table indexes  
CREATE INDEX IX_Students_AdmissionNumber ON Students(AdmissionNumber);
CREATE INDEX IX_Students_ClassID ON Students(ClassID);
CREATE INDEX IX_Students_UserID ON Students(UserID);

-- Classes table indexes
CREATE INDEX IX_Classes_YearID ON Classes(YearID);
CREATE INDEX IX_Classes_ClassTeacherID ON Classes(ClassTeacherID);

-- Attendance indexes
CREATE INDEX IX_Attendance_StudentID_Date ON Attendance(StudentID, Date);
CREATE INDEX IX_Attendance_Date ON Attendance(Date);

-- Fee Payments indexes
CREATE INDEX IX_FeePayments_StudentID ON FeePayments(StudentID);
CREATE INDEX IX_FeePayments_PaymentDate ON FeePayments(PaymentDate);

-- Student Marks indexes
CREATE INDEX IX_StudentMarks_StudentID ON StudentMarks(StudentID);
CREATE INDEX IX_StudentMarks_ExamID ON StudentMarks(ExamID);

-- Audit Log indexes
CREATE INDEX IX_AuditLog_TableName_Timestamp ON AuditLog(TableName, Timestamp);
CREATE INDEX IX_AuditLog_UserID_Timestamp ON AuditLog(UserID, Timestamp);
GO