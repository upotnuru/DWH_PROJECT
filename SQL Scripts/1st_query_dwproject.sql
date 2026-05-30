/* 
Script use :
It's check the is there any existing database with this name, If it's there it'll drop
It'll create the database with the name "DWH_PROJECT"
And it'll create 3schemas With names "bronze", "silver", "gold" 

Headsup : 
If run this script will drop the entire DWH_PROJECT database with whole data if it's exist
*/


/* Drop the previous dase and create new one if old one is exist */

IF EXISTS ( SELECT 1 FROM sys.databases WHERE NAME = 'DWH_PROJECT')
  BEGIN
    ALTER DATABASE DWH_PROJECT SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DWH_PROJECT;
END
  
GO --> query separater
-- Create Database "DWH_PROJECT"

CREATE DATABASE DWH_PROJECT 

USE DWH_PROJECT

-- Creating schemas

CREATE SCHEMA bronze

GO --> query separater

CREATE SCHEMA silver

GO --> query separater

CREATE SCHEMA gold

