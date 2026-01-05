CREATE DATABASE FloodAid360;
USE FloodAid360;
CREATE TABLE Area (
  AreaID INT PRIMARY KEY AUTO_INCREMENT,
  District VARCHAR(100),
  Village VARCHAR(100),
  SeverityLevel VARCHAR(20),
  GPSCoordinates VARCHAR(50)
);
CREATE TABLE Victim (
  VictimID INT PRIMARY KEY AUTO_INCREMENT,
  Name VARCHAR(100),
  Age INT,
  FamilySize INT,
  MedicalNeeds TEXT,
  ShelterStatus VARCHAR(50),
  PriorityLevel VARCHAR(20),
  AreaID INT,
  FOREIGN KEY (AreaID) REFERENCES Area(AreaID)
);
CREATE TABLE Resource (
  ResourceID INT PRIMARY KEY AUTO_INCREMENT,
  Type VARCHAR(100),
  Quantity INT,
  ExpiryDate DATE,
  Source VARCHAR(100)
);
CREATE TABLE Distribution (
  DistributionID INT PRIMARY KEY AUTO_INCREMENT,
  VictimID INT,
  ResourceID INT,
  Date DATE,
  Quantity INT,
  FOREIGN KEY (VictimID) REFERENCES Victim(VictimID),
  FOREIGN KEY (ResourceID) REFERENCES Resource(ResourceID)
);
CREATE TABLE Volunteer (
  VolunteerID INT PRIMARY KEY AUTO_INCREMENT,
  Name VARCHAR(100),
  Skill VARCHAR(100),
  Location VARCHAR(100),
  Availability BOOLEAN
);
CREATE TABLE Donor (
  DonorID INT PRIMARY KEY AUTO_INCREMENT,
  Name VARCHAR(100),
  Contact VARCHAR(100),
  DonationType VARCHAR(50)
);
CREATE TABLE Donation (
  DonationID INT PRIMARY KEY AUTO_INCREMENT,
  DonorID INT,
  ResourceID INT,
  Amount INT,
  Date DATE,
  FOREIGN KEY (DonorID) REFERENCES Donor(DonorID),
  FOREIGN KEY (ResourceID) REFERENCES Resource(ResourceID)
);
DELIMITER //
CREATE TRIGGER UpdateStockAfterDistribution
AFTER INSERT ON Distribution
FOR EACH ROW
BEGIN
    UPDATE Resource
    SET Quantity = Quantity - NEW.Quantity
    WHERE ResourceID = NEW.ResourceID;
END;
//
DELIMITER ;
CREATE VIEW HighPriorityRescueBoard AS
SELECT 
    V.Name AS Victim_Name,
    A.District,
    A.SeverityLevel AS Area_Severity,
    V.MedicalNeeds,
    V.PriorityLevel AS Victim_Priority
FROM Victim V
JOIN Area A ON V.AreaID = A.AreaID
WHERE V.PriorityLevel = 'High' OR A.SeverityLevel = 'High';
SHOW TABLES;
INSERT INTO Area (District, Village, SeverityLevel, GPSCoordinates) VALUES
('Swat', 'Kalam', 'High', '35.4902,72.5796'),
('Charsadda', 'Tangi', 'Medium', '34.1490,71.7420'),
('Nowshera', 'Pabbi', 'High', '34.0113,71.7960'),
('Dera Ismail Khan', 'Kulachi', 'Low', '31.8315,70.4590'),
('Chitral', 'Booni', 'Medium', '36.3210,72.8780'),
('Mansehra', 'Balakot', 'High', '34.5471,73.3510'),
('Muzaffargarh', 'Kot Addu', 'High', '30.4697,70.9670'),
('Thatta', 'Makli', 'Medium', '24.7470,67.9230'),
('Badin', 'Talhar', 'High', '24.8845,68.8140'),
('Rajpur', 'Jampur', 'Low', '29.6424,70.5950');
INSERT INTO Victim (Name, Age, FamilySize, MedicalNeeds, ShelterStatus, PriorityLevel, AreaID) VALUES
('Ayesha Khan', 35, 5, 'Diabetic', 'Camp', 'High', 1),
('Ahmed Ali', 60, 4, 'Blood Pressure', 'Camp', 'High', 2),
('Fatima Noor', 28, 3, 'Pregnant', 'Shelter Home', 'High', 3),
('Bilal Hussain', 45, 6, 'Asthma', 'Camp', 'Medium', 4),
('Sana Malik', 19, 2, 'None', 'Relative Home', 'Low', 5),
('Zain Abbas', 7, 5, 'Child Nutrition', 'Camp', 'High', 6),
('Hina Raza', 50, 4, 'Heart Patient', 'Camp', 'High', 7),
('Usman Tariq', 33, 3, 'Injury', 'Shelter Home', 'Medium', 8),
('Nida Farooq', 41, 6, 'Diabetic', 'Camp', 'High', 9),
('Imran Khan', 27, 2, 'None', 'Relative Home', 'Low', 10);
INSERT INTO Resource (Type, Quantity, ExpiryDate, Source) VALUES
('Food Pack', 500, '2026-01-01', 'NGO'),
('Clean Water Bottles', 1000, '2025-12-01', 'Government'),
('Medical Kit', 200, '2026-03-15', 'NGO'),
('Blankets', 300, NULL, 'Donation'),
('Baby Food', 150, '2025-10-10', 'UNICEF'),
('Tents', 100, NULL, 'Government'),
('Clothes', 400, NULL, 'Public'),
('Sanitation Kits', 250, '2025-11-20', 'WHO'),
('Mosquito Nets', 350, NULL, 'NGO'),
('Cooking Utensils', 180, NULL, 'Donation');
INSERT INTO Volunteer (Name, Skill, Location, Availability) VALUES
('Ali Ahmed', 'Medical Aid', 'Swat', TRUE),
('Sara Khan', 'Food Distribution', 'Charsadda', TRUE),
('Usman Riaz', 'Rescue', 'Nowshera', FALSE),
('Hassan Ali', 'Logistics', 'DI Khan', TRUE),
('Areeba Noor', 'Child Care', 'Chitral', TRUE),
('Bilal Shah', 'Medical Aid', 'Mansehra', FALSE),
('Zoya Malik', 'Shelter Management', 'Muzaffargarh', TRUE),
('Fahad Iqbal', 'Transport', 'Thatta', TRUE),
('Noor Fatima', 'Health Support', 'Badin', TRUE),
('Kamran Akbar', 'Supply Handling', 'Rajpur', FALSE);
INSERT INTO Donor (Name, Contact, DonationType) VALUES
('Edhi Foundation', '042-111-111', 'Food'),
('Saylani Welfare', '021-111-222', 'Medical'),
('Al-Khidmat', '051-111-333', 'Shelter'),
('Red Crescent', '051-222-444', 'Relief Goods'),
('UNICEF', '021-333-555', 'Child Care'),
('WHO', '021-444-666', 'Medical'),
('Private Donor A', '0300-1234567', 'Cash'),
('Private Donor B', '0301-7654321', 'Food'),
('NGO Care', '042-555-777', 'Sanitation'),
('Local Community', '0302-9998888', 'Clothes');
INSERT INTO Distribution (VictimID, ResourceID, Date, Quantity) VALUES
(1, 1, CURDATE(), 2),
(2, 2, CURDATE(), 5),
(3, 3, CURDATE(), 1),
(4, 4, CURDATE(), 3),
(5, 5, CURDATE(), 1),
(6, 6, CURDATE(), 1),
(7, 7, CURDATE(), 4),
(8, 8, CURDATE(), 2),
(9, 9, CURDATE(), 3),
(10, 10, CURDATE(), 1);
INSERT INTO Donation (DonorID, ResourceID, Amount, Date) VALUES
(1, 1, 200, CURDATE()),
(2, 3, 150, CURDATE()),
(3, 6, 50, CURDATE()),
(4, 2, 300, CURDATE()),
(5, 5, 100, CURDATE()),
(6, 3, 180, CURDATE()),
(7, 1, 250, CURDATE()),
(8, 4, 120, CURDATE()),
(9, 8, 160, CURDATE()),
(10, 7, 90, CURDATE());
SELECT * FROM HighPriorityRescueBoard;
SELECT 
    D.Name AS Donor_Name,
    SUM(Don.Amount) AS Total_Items_Donated,
    ROUND((SUM(Don.Amount) / (SELECT SUM(Amount) FROM Donation) * 100), 2) AS Share_Percentage
FROM Donor D
JOIN Donation Don ON D.DonorID = Don.DonorID
GROUP BY D.Name
ORDER BY Share_Percentage DESC;
SELECT * FROM Area;
SELECT * FROM Victim;
SELECT * FROM Resource;
SELECT * FROM Volunteer;
SELECT * FROM Donor;
SELECT * FROM Distribution;
SELECT * FROM Donation;
SELECT ResourceID, Type, Quantity, ExpiryDate, Source
FROM Resource;
SELECT Type, ExpiryDate
FROM Resource
WHERE ExpiryDate IS NOT NULL;
SELECT 
    Victim.Name AS Victim_Name,
    Resource.Type AS Resource_Type,
    Distribution.Quantity,
    Distribution.Date
FROM Distribution
JOIN Victim ON Distribution.VictimID = Victim.VictimID
JOIN Resource ON Distribution.ResourceID = Resource.ResourceID;
SELECT Name, Skill, Location
FROM Volunteer
WHERE Availability = TRUE;
SELECT Name
FROM Volunteer
WHERE Skill LIKE '%Medical%'
AND Location = 'Swat';

SELECT 
    Donor.Name AS Donor_Name,
    Resource.Type AS Resource_Type,
    Donation.Amount,
    Donation.Date
FROM Donation
JOIN Donor ON Donation.DonorID = Donor.DonorID
JOIN Resource ON Donation.ResourceID = Resource.ResourceID;
SELECT Name, PriorityLevel
FROM Victim
WHERE PriorityLevel = 'High';
SELECT Victim.Name, Area.District
FROM Victim
JOIN Area ON Victim.AreaID = Area.AreaID
WHERE Area.District = 'Swat';
SELECT Name, MedicalNeeds
FROM Victim
WHERE MedicalNeeds LIKE '%Diabetic%';
SELECT Name, MedicalNeeds, ShelterStatus
FROM Victim
WHERE PriorityLevel = 'High';
SELECT Type, Quantity
FROM Resource
WHERE Quantity < 200;
SELECT Name, Skill
FROM Volunteer
WHERE Availability = TRUE;


-- -----------------------------
-- AREA CRUD
-- -----------------------------
-- CREATE (Insert new area)
INSERT INTO Area (District, Village, SeverityLevel, GPSCoordinates)
VALUES ('New District', 'New Village', 'Medium', '0.0000,0.0000');

-- READ (View all areas)
SELECT * FROM Area;

-- UPDATE (Change severity level of an area)
UPDATE Area
SET SeverityLevel = 'Low'
WHERE AreaID = 1;

-- DELETE (Remove an area)
DELETE FROM Area
WHERE AreaID = 11;

-- -----------------------------
-- VICTIM CRUD
-- -----------------------------
-- CREATE (Add new victim)
INSERT INTO Victim (Name, Age, FamilySize, MedicalNeeds, ShelterStatus, PriorityLevel, AreaID)
VALUES ('Rabia Shaikh', 40, 6, 'Pregnant', 'Camp', 'High', 1);

-- READ (View all victims)
SELECT * FROM Victim;

-- READ with JOIN to show victim's area
SELECT Victim.Name, Victim.PriorityLevel, Area.District, Area.Village
FROM Victim
JOIN Area ON Victim.AreaID = Area.AreaID;

-- UPDATE (Change victim shelter)
UPDATE Victim
SET ShelterStatus = 'Hospital'
WHERE VictimID = 1;

-- DELETE (Remove victim)
DELETE FROM Victim
WHERE VictimID = 11;

-- -----------------------------
-- RESOURCE CRUD
-- -----------------------------
-- CREATE (Add new resource)
INSERT INTO Resource (Type, Quantity, ExpiryDate, Source)
VALUES ('Sanitation Kits', 100, '2026-05-01', 'NGO');

-- READ (View all resources)
SELECT * FROM Resource;

-- UPDATE (Update resource quantity)
UPDATE Resource
SET Quantity = Quantity + 50
WHERE ResourceID = 1;

-- DELETE (Remove resource)
DELETE FROM Resource
WHERE ResourceID = 11;

-- -----------------------------
-- DISTRIBUTION CRUD
-- -----------------------------
-- CREATE (Distribute resource to a victim)
INSERT INTO Distribution (VictimID, ResourceID, Date, Quantity)
VALUES (1, 1, CURDATE(), 2);

-- READ (View distributions with victim & resource)
SELECT Victim.Name AS Victim, Resource.Type AS Resource, Distribution.Quantity, Distribution.Date
FROM Distribution
JOIN Victim ON Distribution.VictimID = Victim.VictimID
JOIN Resource ON Distribution.ResourceID = Resource.ResourceID;

-- UPDATE (Update distribution quantity)
UPDATE Distribution
SET Quantity = 5
WHERE DistributionID = 1;

-- DELETE (Remove a distribution record)
DELETE FROM Distribution
WHERE DistributionID = 11;

-- -----------------------------
-- VOLUNTEER CRUD
-- -----------------------------
-- CREATE (Add volunteer)
INSERT INTO Volunteer (Name, Skill, Location, Availability)
VALUES ('Adeel Khan', 'Medical Aid', 'Swat', TRUE);

-- READ (View available volunteers)
SELECT Name, Skill, Location
FROM Volunteer
WHERE Availability = TRUE;

-- UPDATE (Update volunteer availability)
UPDATE Volunteer
SET Availability = FALSE
WHERE VolunteerID = 1;

-- DELETE (Remove volunteer)
DELETE FROM Volunteer
WHERE VolunteerID = 11;

-- -----------------------------
-- DONOR CRUD
-- -----------------------------
-- CREATE (Add donor)
INSERT INTO Donor (Name, Contact, DonationType)
VALUES ('Global Fund', '0300-1112222', 'Medical');

-- READ (View all donors)
SELECT * FROM Donor;

-- UPDATE (Update donor contact)
UPDATE Donor
SET Contact = '0300-9998888'
WHERE DonorID = 1;

-- DELETE (Remove donor)
DELETE FROM Donor
WHERE DonorID = 11;

-- -----------------------------
-- DONATION CRUD
-- -----------------------------
-- CREATE (Record donation)
INSERT INTO Donation (DonorID, ResourceID, Amount, Date)
VALUES (1, 1, 300, CURDATE());

-- READ (View donations with donor & resource details)
SELECT Donor.Name AS Donor, Resource.Type AS Resource, Donation.Amount, Donation.Date
FROM Donation
JOIN Donor ON Donation.DonorID = Donor.DonorID
JOIN Resource ON Donation.ResourceID = Resource.ResourceID;

-- UPDATE (Update donation amount)
UPDATE Donation
SET Amount = 500
WHERE DonationID = 1;

-- DELETE (Remove donation)
DELETE FROM Donation
WHERE DonationID = 11;

-- =========================================
-- BUSINESS RULE QUERIES
-- =========================================

-- 1. High-priority victims
SELECT Name, PriorityLevel
FROM Victim
WHERE PriorityLevel = 'High';

-- 2. Resources about to expire
SELECT Type, ExpiryDate
FROM Resource
WHERE ExpiryDate IS NOT NULL
ORDER BY ExpiryDate ASC;

-- 3. Volunteers by skill and location
SELECT Name, Skill
FROM Volunteer
WHERE Skill LIKE '%Medical%'
AND Location = 'Swat';


-- 4. Donations summary by donor
SELECT Donor.Name, SUM(Donation.Amount) AS TotalAmount
FROM Donation
JOIN Donor ON Donation.DonorID = Donor.DonorID
GROUP BY Donor.Name;

-- 5. Resources distributed per victim
SELECT Victim.Name AS Victim, Resource.Type AS Resource, SUM(Distribution.Quantity) AS TotalGiven
FROM Distribution
JOIN Victim ON Distribution.VictimID = Victim.VictimID
JOIN Resource ON Distribution.ResourceID = Resource.ResourceID
GROUP BY Victim.Name, Resource.Type;

-- 6. Dashboard: victims per area
SELECT Area.District, COUNT(Victim.VictimID) AS TotalVictims
FROM Victim
JOIN Area ON Victim.AreaID = Area.AreaID
GROUP BY Area.District;

-- 7. Dashboard: available volunteers per skill
SELECT Skill, COUNT(*) AS AvailableVolunteers
FROM Volunteer
WHERE Availability = TRUE
GROUP BY Skill;