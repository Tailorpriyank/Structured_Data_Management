-- Create the dimension tables in the data_warehouse schema:

-- Create 'DimDisease' table

CREATE TABLE data_warehouse.dimdisease (
    DiseaseID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Type VARCHAR(255) NOT NULL,
    Description TEXT
);

-- Create 'DimPatient' table

CREATE TABLE data_warehouse.dimpatient (
    PatientID SERIAL PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    BirthDate DATE NOT NULL,
    Gender VARCHAR(50) NOT NULL
);

-- Create 'DimLocation' table

CREATE TABLE data_warehouse.dimlocation (
    LocationID SERIAL PRIMARY KEY,
    City VARCHAR(255) NOT NULL,
    State VARCHAR(255) NOT NULL,
    Country VARCHAR(255) NOT NULL,
    Latitude DECIMAL(9,6),
    Longitude DECIMAL(9,6)
);

-- Create 'DimTreatment' table

CREATE TABLE data_warehouse.dimtreatment (
    TreatmentID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Type VARCHAR(255) NOT NULL
);

-- Create 'DimHealthcareProvider' table

CREATE TABLE data_warehouse.dimhealthcareprovider (
    ProviderID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Type VARCHAR(255) NOT NULL,
    Address TEXT,
    ContactNumber VARCHAR(50)
);

-- 3. Create the fact table in the data_warehouse schema:

-- Create 'FactDiagnosisTreatment' table
CREATE TABLE data_warehouse.factdiagnosistreatment (
    FactID SERIAL PRIMARY KEY,
    DiagnosisID INTEGER NOT NULL,
    DiseaseID INTEGER NOT NULL,
    PatientID INTEGER NOT NULL,
    LocationID INTEGER NOT NULL,
    TreatmentID INTEGER NOT NULL,
    ProviderID INTEGER NOT NULL,
    DiagnosisDate DATE NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE,
    Result VARCHAR(255) NOT NULL,
    Cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (DiseaseID) REFERENCES data_warehouse.dimdisease (DiseaseID),
    FOREIGN KEY (PatientID) REFERENCES data_warehouse.dimpatient (PatientID),
    FOREIGN KEY (LocationID) REFERENCES data_warehouse.dimlocation (LocationID),
    FOREIGN KEY (TreatmentID) REFERENCES data_warehouse.dimtreatment (TreatmentID),
    FOREIGN KEY (ProviderID) REFERENCES data_warehouse.dimhealthcareprovider (ProviderID)
);

-- Load data from the OLTP tables to the corresponding dimension tables in your data warehouse with the following INSERT statements:


INSERT INTO data_warehouse.dimdisease SELECT * FROM disease;
INSERT INTO data_warehouse.dimpatient SELECT * FROM patient;
INSERT INTO data_warehouse.dimlocation SELECT * FROM location;
INSERT INTO data_warehouse.dimtreatment SELECT * FROM treatment;
INSERT INTO data_warehouse.dimhealthcareprovider SELECT * FROM healthcare_provider;


-- 5. Load data from OLTP tables to the data warehouse fact table.
-- This query joins diagnosis, treatment_outcome, and provider_treatment tables to combine the relevant information:

INSERT INTO data_warehouse.factdiagnosistreatment (
    DiagnosisID, DiseaseID, PatientID, LocationID, TreatmentID, ProviderID, DiagnosisDate, StartDate, EndDate, Result, Cost)
SELECT d.DiagnosisID, d.DiseaseID, d.PatientID, d.LocationID, t.TreatmentID, p.ProviderID, d.DiagnosisDate, t.StartDate, t.EndDate, t.Result, p.Cost
FROM diagnosis d
JOIN treatment_outcome t ON d.DiagnosisID = t.DiagnosisID
JOIN provider_treatment p ON t.TreatmentID = p.TreatmentID;


-- 3.Queries or dashboard for business analytics:
-- * Run analytical queries to showcase insights from the data warehouse.


-- Here are three analytical queries that can provide insights from the data warehouse:

-- 1. Number of diagnoses per disease:

SELECT d.Name as Disease, COUNT(f.DiagnosisID) as Diagnoses_Count
FROM data_warehouse.factdiagnosistreatment f
JOIN data_warehouse.dimdisease d ON f.DiseaseID = d.DiseaseID
GROUP BY d.Name
ORDER BY Diagnoses_Count DESC;

-- 2. Average cost of treatments per disease:

SELECT d.Name as Disease, AVG(f.Cost) as Average_Cost
FROM data_warehouse.factdiagnosistreatment f
JOIN data_warehouse.dimdisease d ON f.DiseaseID = d.DiseaseID
GROUP BY d.Name
ORDER BY Average_Cost DESC;

-- 3. Treatment outcomes per disease:

SELECT d.Name as Disease, f.Result as Outcome, COUNT(f.DiagnosisID) as Outcome_Count
FROM data_warehouse.factdiagnosistreatment f
JOIN data_warehouse.dimdisease d ON f.DiseaseID = d.DiseaseID
GROUP BY d.Name, f.Result
ORDER BY Disease, Outcome_Count DESC;

-- These analytical queries can provide valuable insights into the disease diagnoses, 
-- costs of treatments, and treatment outcomes. You can use these queries as a basis to 
-- create visualizations or dashboards in business intelligence tools like Tableau, Power BI, 
-- or Looker to make it easier for stakeholders to understand and interpret the data.


-- 4. Top healthcare providers by the number of treatments performed:

SELECT p.Name as Provider, COUNT(f.DiagnosisID) as Treatments_Count
FROM data_warehouse.factdiagnosistreatment f
JOIN data_warehouse.dimhealthcareprovider p ON f.ProviderID = p.ProviderID
GROUP BY p.Name
ORDER BY Treatments_Count DESC
LIMIT 5;