
-- =====================================================
-- Insert Initial Data
-- =====================================================

-- Insert default roles
INSERT INTO Roles (RoleName, Description) VALUES 
('Super Admin', 'Full system access'),
('Principal', 'School administration access'),
('Teacher', 'Academic and student management'),
('Student', 'Student portal access'),
('Parent', 'Parent portal access'),
('Accountant', 'Financial management access'),
('Librarian', 'Library management access');

-- Insert default academic year
INSERT INTO AcademicYears (YearName, StartDate, EndDate, IsActive) VALUES 
('2024-25', '2024-04-01', '2025-03-31', 1);

-- Insert exam types
INSERT INTO ExamTypes (TypeName, Description, WeightPercentage) VALUES 
('Unit Test', 'Monthly unit tests', 20.00),
('Mid Term', 'Mid-term examinations', 30.00),
('Final Exam', 'Final examinations', 50.00);

-- Insert fee types
INSERT INTO FeeTypes (TypeName, Description, IsOptional) VALUES 
('Tuition Fee', 'Monthly tuition fee', 0),
('Transport Fee', 'Bus transportation fee', 1),
('Activity Fee', 'Extra-curricular activities fee', 1),
('Library Fee', 'Library usage fee', 0),
('Exam Fee', 'Examination fee', 0);

-- Insert system settings
INSERT INTO SystemSettings (SettingName, SettingValue, Description, ModifiedBy) VALUES 
('School Name', 'ABC International School', 'Name of the school', 1),
('Academic Year', '2024-25', 'Current academic year', 1),
('Default Language', 'English', 'Default system language', 1),
('Max Class Capacity', '35', 'Maximum students per class', 1),
('Attendance Required %', '75', 'Minimum attendance percentage required', 1);

GO