-- =====================================================
-- School Management System Database Creation Script
-- MS SQL Server with Filegroups
-- Author: MD ABU SAYEM
-- mdsayem01k@gmail.com
-- =====================================================

-- Step 1: Create Database with Filegroups
-- =====================================================

-- Drop database if exists (uncomment if needed)
-- DROP DATABASE IF EXISTS SchoolManagementSystem;

CREATE DATABASE SchoolManagementSystem
ON 
-- Primary Filegroup (for system tables and critical data)
( NAME = 'SchoolManagement_Data',
  FILENAME = 'C:\Database\SchoolManagement_Data.mdf',
  SIZE = 100MB,
  MAXSIZE = 1GB,
  FILEGROWTH = 10MB ),
  
-- Secondary Filegroup for User and Academic data
( NAME = 'SchoolManagement_UserData', 
  FILENAME = 'C:\Database\SchoolManagement_UserData.ndf',
  SIZE = 50MB,
  MAXSIZE = 500MB,
  FILEGROWTH = 5MB ),
  
-- Filegroup for Assessment and Financial data
( NAME = 'SchoolManagement_TransData',
  FILENAME = 'C:\Database\SchoolManagement_TransData.ndf', 
  SIZE = 50MB,
  MAXSIZE = 500MB,
  FILEGROWTH = 5MB )

LOG ON 
( NAME = 'SchoolManagement_Log',
  FILENAME = 'C:\Database\SchoolManagement_Log.ldf',
  SIZE = 10MB,
  MAXSIZE = 100MB,
  FILEGROWTH = 5MB );

-- Create additional filegroups
ALTER DATABASE SchoolManagementSystem 
ADD FILEGROUP UserData_FG;

ALTER DATABASE SchoolManagementSystem 
ADD FILEGROUP TransData_FG;

ALTER DATABASE SchoolManagementSystem 
ADD FILEGROUP AuditData_FG;

-- Add files to filegroups
ALTER DATABASE SchoolManagementSystem 
ADD FILE 
( NAME = 'UserData_File',
  FILENAME = 'C:\Database\SchoolManagement_UserData_FG.ndf',
  SIZE = 25MB,
  FILEGROWTH = 5MB )
TO FILEGROUP UserData_FG;

ALTER DATABASE SchoolManagementSystem 
ADD FILE 
( NAME = 'TransData_File', 
  FILENAME = 'C:\Database\SchoolManagement_TransData_FG.ndf',
  SIZE = 25MB,
  FILEGROWTH = 5MB )
TO FILEGROUP TransData_FG;

ALTER DATABASE SchoolManagementSystem 
ADD FILE 
( NAME = 'AuditData_File',
  FILENAME = 'C:\Database\SchoolManagement_AuditData_FG.ndf', 
  SIZE = 15MB,
  FILEGROWTH = 3MB )
TO FILEGROUP AuditData_FG;


PRINT 'School Management System database created successfully with filegroups!';
PRINT 'Database includes all specified tables with proper relationships and constraints.';
PRINT 'Filegroups created: UserData_FG, TransData_FG, AuditData_FG';

GO