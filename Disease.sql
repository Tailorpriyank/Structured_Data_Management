-- Create 'disease' table
CREATE TABLE disease (
    DiseaseID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Type VARCHAR(255) NOT NULL,
    Description TEXT
);

-- Create 'patient' table
CREATE TABLE patient (
    PatientID SERIAL PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    BirthDate DATE NOT NULL,
    Gender VARCHAR(50) NOT NULL
);

-- Create 'location' table
CREATE TABLE location (
    LocationID SERIAL PRIMARY KEY,
    City VARCHAR(255) NOT NULL,
    State VARCHAR(255) NOT NULL,
    Country VARCHAR(255) NOT NULL,
    Latitude DECIMAL(9,6),
    Longitude DECIMAL(9,6)
);

-- Create 'treatment' table
CREATE TABLE treatment (
    TreatmentID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Type VARCHAR(255) NOT NULL
);

-- Create 'diagnosis' table
CREATE TABLE diagnosis (
    DiagnosisID SERIAL PRIMARY KEY,
    DiseaseID INTEGER NOT NULL,
    PatientID INTEGER NOT NULL,
    LocationID INTEGER NOT NULL,
    DiagnosisDate DATE NOT NULL,
    FOREIGN KEY (DiseaseID) REFERENCES disease (DiseaseID),
    FOREIGN KEY (PatientID) REFERENCES patient (PatientID),
    FOREIGN KEY (LocationID) REFERENCES location (LocationID)
);

-- Create 'treatment_outcome' table
CREATE TABLE treatment_outcome (
    OutcomeID SERIAL PRIMARY KEY,
    TreatmentID INTEGER NOT NULL,
    DiagnosisID INTEGER NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE,
    Result VARCHAR(255) NOT NULL,
    FOREIGN KEY (TreatmentID) REFERENCES treatment (TreatmentID),
    FOREIGN KEY (DiagnosisID) REFERENCES diagnosis (DiagnosisID)
);

-- Create 'healthcare_provider' table
CREATE TABLE healthcare_provider (
    ProviderID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Type VARCHAR(255) NOT NULL,
    Address TEXT,
    ContactNumber VARCHAR(50)
);

-- Create 'provider_treatment' table
CREATE TABLE provider_treatment (
    ProviderTreatmentID SERIAL PRIMARY KEY,
    ProviderID INTEGER NOT NULL,
    TreatmentID INTEGER NOT NULL,
    Cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ProviderID) REFERENCES healthcare_provider (ProviderID),
    FOREIGN KEY (TreatmentID) REFERENCES treatment (TreatmentID)
);

-- Insert data into 'disease' table
INSERT INTO disease (Name, Type, Description)
VALUES ('Malaria', 'Parasitic', 'A life-threatening disease caused by mosquitoes.'),
       ('Hepatitis A', 'Viral', 'A highly contagious liver infection.'),
       ('Asthma', 'Non-infectious', 'A chronic lung condition.'),
       ('Diabetes', 'Non-infectious', 'A metabolic disorder characterized by high blood sugar levels.');

-- Insert data into 'patient' table
INSERT INTO patient (FirstName, LastName, BirthDate, Gender)
VALUES ('Susan', 'Green', '1989-08-15', 'Female'),
       ('Mike', 'Taylor', '1997-12-18', 'Male'),
       ('Emma', 'Jackson', '2000-05-28', 'Female'),
       ('Steven', 'Harris', '1965-10-10', 'Male');

-- Insert more data into 'location' table
INSERT INTO location (City, State, Country, Latitude, Longitude)
VALUES ('Los Angeles', 'California', 'USA', 34.0522, -118.2437),
       ('Chicago', 'Illinois', 'USA', 41.8781, -87.6298),
       ('Houston', 'Texas', 'USA', 29.7604, -95.3698),
       ('Phoenix', 'Arizona', 'USA', 33.4484, -112.0740);


-- Insert more data into 'treatment' table
INSERT INTO treatment (Name, Description, Type)
VALUES ('Antimalarial Medication', 'Medications to treat Malaria', 'Pharmacological'),
       ('Hepatitis A Vaccine', 'Vaccine to prevent Hepatitis A', 'Immunization'),
       ('Inhalers', 'Medications for Asthma', 'Pharmacological'),
       ('Insulin Therapy', 'Treatment to regulate blood sugar levels', 'Pharmacological');
	   
-- Insert more data into 'diagnosis' table
INSERT INTO diagnosis (DiseaseID, PatientID, LocationID, DiagnosisDate)
VALUES (1, 2, 4, '2023-03-20'),
       (3, 3, 3, '2023-02-15'),
       (3, 4, 4, '2023-01-10'),
       (1, 4, 1, '2023-03-05');
	   
-- Insert more data into 'treatment_outcome' table
INSERT INTO treatment_outcome (TreatmentID, DiagnosisID, StartDate, EndDate, Result)
VALUES (1, 5, '2023-03-21', '2023-03-30', 'Recovered'),
       (3, 7, '2023-02-16', '2023-02-25', 'Stable'),
       (4, 6, '2023-01-11', '2023-01-20', 'Improved'),
       (1, 8, '2023-03-06', '2023-03-15', 'Recovered');

-- Insert more data into 'healthcare_provider' table
INSERT INTO healthcare_provider (Name, Type, Address, ContactNumber)
VALUES ('Community Clinic', 'Clinic', '789 Main St, Los Angeles, CA', '(555) 987-6543'),
       ('Downtown Medical Center', 'Hospital', '456 Grand Ave, Chicago, IL', '(555) 456-7890'),
       ('Health First', 'Primary Care', '321 Elm St, Houston, TX', '(555) 654-3210'),
       ('Phoenix Health', 'Specialty Care', '1010 Oak St, Phoenix, AZ', '(555) 222-3333');
	   
	   

-- Insert more data into 'provider_treatment' table
INSERT INTO provider_treatment (ProviderID, TreatmentID, Cost)
VALUES (2, 2, 120.00),
        (3, 3, 75.00),
         (4, 4, 100.00),
        (1, 1, 150.00);	   
		
		

--Retrieve all patients diagnosed with Malaria:

SELECT patient.FirstName, patient.LastName
FROM patient
JOIN diagnosis ON patient.PatientID = diagnosis.PatientID
JOIN disease ON diagnosis.DiseaseID = disease.DiseaseID
WHERE disease.Name = 'Malaria';



--List all healthcare providers offering Hepatitis A Vaccine:

SELECT healthcare_provider.Name, healthcare_provider.Type, treatment.Name AS Treatment_Name
FROM healthcare_provider
JOIN provider_treatment ON healthcare_provider.ProviderID = provider_treatment.ProviderID
JOIN treatment ON provider_treatment.TreatmentID = treatment.TreatmentID
WHERE treatment.Name = 'Hepatitis A Vaccine';


--Count the number of patients diagnosed with non-infectious diseases:

SELECT disease.Type, COUNT(diagnosis.DiagnosisID) AS Number_of_Patients
FROM disease
JOIN diagnosis ON disease.DiseaseID = diagnosis.DiseaseID
WHERE disease.Type = 'Non-infectious'
GROUP BY disease.Type;


--Retrieve the most recent diagnosis date for each patient:

SELECT patient.FirstName, patient.LastName, MAX(diagnosis.DiagnosisDate) AS Most_Recent_Diagnosis_Date
FROM patient
JOIN diagnosis ON patient.PatientID = diagnosis.PatientID
GROUP BY patient.FirstName, patient.LastName;


--Find the total cost of treatments provided by each healthcare provider:

SELECT healthcare_provider.Name, SUM(provider_treatment.Cost) AS Total_Treatment_Cost
FROM healthcare_provider
JOIN provider_treatment ON healthcare_provider.ProviderID = provider_treatment.ProviderID
GROUP BY healthcare_provider.Name;


--Retrieve the patient details and diagnosis information for patients diagnosed in Los Angeles:

SELECT patient.FirstName, patient.LastName, disease.Name AS Disease_Name, diagnosis.DiagnosisDate, location.City
FROM patient
JOIN diagnosis ON patient.PatientID = diagnosis.PatientID
JOIN disease ON diagnosis.DiseaseID = disease.DiseaseID
JOIN location ON diagnosis.LocationID = location.LocationID
WHERE location.City = 'Los Angeles';


--Find the average cost of Insulin Therapy across all healthcare providers:

SELECT treatment.Name, AVG(provider_treatment.Cost) AS Average_Cost
FROM treatment
JOIN provider_treatment ON treatment.TreatmentID = provider_treatment.TreatmentID
WHERE treatment.Name = 'Insulin Therapy'
GROUP BY treatment.Name;



-- 1. A new patient, Jessica El, is added to the database.
-- 2. John Doe is diagnosed with Malaria in Los Angeles on May 1st, 2023.
-- 3. A new treatment, "Malaria Prevention Vaccine", is added to the treatments list.
-- 4. Community Clinic starts offering the new Malaria Prevention Vaccine at a cost of $90.
-- 5. John Doe starts the Malaria Prevention Vaccine treatment and recovers after 10 days.
-- 6. Cost of the Malaria Prevention Vaccine at Community Clinic increases by $10.

-- Add new patient
INSERT INTO patient (FirstName, LastName, BirthDate, Gender)
VALUES ('Jessica', 'El', '1990-01-01', 'Female');

-- Add new diagnosis for Jessica El
INSERT INTO diagnosis (DiseaseID, PatientID, LocationID, DiagnosisDate)
VALUES ((SELECT DiseaseID FROM disease WHERE Name = 'Malaria'),
(SELECT PatientID FROM patient WHERE FirstName = 'Jessica' AND LastName = 'El'),
(SELECT LocationID FROM location WHERE City = 'Los Angeles'),
'2023-05-01');

-- Add new treatment
INSERT INTO treatment (Name, Description, Type)
VALUES ('Malaria Prevention Vaccine', 'A vaccine to prevent Malaria', 'Immunization');

-- Add new provider treatment
INSERT INTO provider_treatment (ProviderID, TreatmentID, Cost)
VALUES ((SELECT ProviderID FROM healthcare_provider WHERE Name = 'Community Clinic'),
(SELECT TreatmentID FROM treatment WHERE Name = 'Malaria Prevention Vaccine'),
90);

-- Add new treatment outcome for John Doe
INSERT INTO treatment_outcome (TreatmentID, DiagnosisID, StartDate, EndDate, Result)
VALUES ((SELECT TreatmentID FROM treatment WHERE Name = 'Malaria Prevention Vaccine'),
(SELECT DiagnosisID FROM diagnosis WHERE PatientID = (SELECT PatientID FROM patient WHERE FirstName = 'Jessica' AND LastName = 'El')),
'2023-05-02', '2023-05-12', 'Recovered');

select* 
from patient

select* 
from diagnosis 

select* 
from treatment

select* 
from provider_treatment 

select* 
from treatment_outcome

-- let's assume the cost of the Malaria Prevention Vaccine at Community Clinic increases by $10.

-- Update provider treatment cost
UPDATE provider_treatment
SET Cost = Cost + 10
WHERE ProviderID IN (SELECT ProviderID FROM healthcare_provider WHERE Name = 'Community Clinic')
AND TreatmentID IN (SELECT TreatmentID FROM treatment WHERE Name = 'Malaria Prevention Vaccine');

select* 
from provider_treatment 

