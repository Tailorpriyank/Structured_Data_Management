# 🩺 Disease Tracking & Treatment Outcomes – SQL Data Warehouse Project

This project was developed as the final assignment for the **Structured Data Management (DAV‑5200)** course at Katz School. It focuses on building a robust SQL-based data warehouse to track the spread of infectious diseases, assess treatment effectiveness, and enable regional health analytics.

---

## 👥 Team Members

- Aradhana Panchal  
- Priyank Tailor  
- Shruthi Kolluru  

---

## 📌 Business Problem

Tracking infectious diseases and evaluating treatment outcomes at a regional level is essential for public health planning. This project aims to:
- Model real-world healthcare scenarios with normalized relational schema
- Enable analytical queries across diagnoses, treatments, and outcomes
- Support public policy and healthcare providers with meaningful insights

---

## 🧱 OLTP Schema Design

We built a normalized schema including:

**Entities:**
- `Disease` – ID, name, type, symptoms  
- `Patient` – demographics and contact  
- `Location` – city, state, country, lat/lon  
- `Diagnosis` – disease-patient-location linkage  
- `Treatment` – name, type, description  
- `TreatmentOutcome` – treatment start/end dates and results  
- `HealthcareProvider` – name, address, type  
- `ProviderTreatment` – treatment cost by provider

**Relationships:**
- One-to-many: Patient → Diagnosis  
- Many-to-many: Treatment ↔ HealthcareProvider  
- One-to-many: Diagnosis → TreatmentOutcome

---

## 📊 Sample Queries

- Retrieve all patients diagnosed with **Malaria**  
- List all healthcare providers offering **Hepatitis A Vaccine**  
- Get average cost of **Insulin Therapy**  
- Find top 5 providers by **number of treatments**  
- Count diagnoses by **disease and region**  
- Analyze **treatment success rates** per disease

---

## 🏗️ Data Warehouse Design

A **dimensional model** was created with:

**Fact Table:**  
- `FactDiagnosisTreatment` – stores event-level data linking diagnosis, treatment, provider, cost, and outcomes

**Dimension Tables:**  
- `DimDisease`, `DimPatient`, `DimLocation`, `DimTreatment`, `DimHealthcareProvider`

**ETL Approach:**  
- Used `INSERT INTO ... SELECT` to load OLTP data into dimensional tables  
- Joined `diagnosis`, `treatment_outcome`, and `provider_treatment` to populate fact table

---

## 📈 Analytical Use Cases

- Diagnoses per disease  
- Average treatment cost by disease  
- Outcome breakdown by disease  
- Top healthcare providers by treatment volume

---

## 🧪 NoSQL Comparison

**MongoDB:**  
- Flexible, nested structure using JSON documents  
- Ideal for storing entire patient records with embedded diagnosis & treatment history

**Neo4j:**  
- Graph-based model representing entities as nodes and relationships  
- Great for querying deep connections, like disease outbreaks by location

---

## ☁️ AWS Architecture (Proposed)

- **Amazon RDS**: PostgreSQL for relational storage  
- **Amazon EC2**: App server for ETL jobs  
- **Amazon S3**: Storage for scripts and backups  
- **AWS Lambda**: Batch & real-time ETL  
- **Amazon VPC, IAM**: Secure network and access control  
- **API Gateway**: REST APIs for querying reports  

---

## 🔁 Snowflake vs PostgreSQL

| Feature          | Snowflake                          | PostgreSQL                 |
|------------------|------------------------------------|----------------------------|
| Scalability      | Virtually unlimited                | Moderate                   |
| Performance      | Optimized for analytics            | Best for transactional use |
| Data Types       | Structured & semi-structured (JSON)| Mostly structured          |
| Pricing          | Consumption-based                  | Instance-based             |
| Management       | Fully managed                      | Requires admin work        |

---

## 🚀 How to Run

1. Clone the repository  
```bash
git clone https://github.com/Tailorpriyank/Structured_Data_Management.git
