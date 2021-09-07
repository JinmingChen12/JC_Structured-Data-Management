---DISEASE TABLE
CREATE TABLE disease(
diseaseID serial primary key,
disease_name varchar(50),
intensity_level_qty int,
disease_type_code int,
sourceID int,
CONSTRAINT fk_disease_type_code FOREIGN KEY (disease_type_code)
REFERENCES disease_type (disease_type_code),
CONSTRAINT fk_person FOREIGN KEY (sourceID)
REFERENCES person (personID)
ON DELETE SET NULL
ON UPDATE SET NULL);

---DISEASE TYPE TABLE
CREATE TABLE disease_type(
disease_type_code SERIAL PRIMARY KEY NOT NULL,
disease_type_description varchar(100));

------DISEASE_SYMPTOM TABLE
CREATE TABLE disease_symptom(
diseaseID int NOT NULL,
symptomID int NOT NULL,
intensity_value int,
PRIMARY KEY (diseaseID,symptomID),
CONSTRAINT fk_diseaseID FOREIGN KEY (diseaseID)
REFERENCES disease (diseaseID),
CONSTRAINT fk_symptoms FOREIGN KEY (symptomID)
REFERENCES symptoms (symptomID)
ON DELETE SET NULL
ON UPDATE SET NULL);

---SYMPTOMS TABLE
CREATE TABLE symptoms(
symptomID serial primary key,
symptom_name varchar(50));

---DISEASED PATIENT TABLE
CREATE TABLE diseased_patient(
personID INT NOT NULL,
diseaseID INT NOT NULL,
severity_value INT,
start_date DATE,
end_date DATE,
days_disease_number INT,
recoveres_indicator BOOLEAN not null,
PRIMARY KEY (diseaseID,personID),
CONSTRAINT fk_diseaseID FOREIGN KEY (diseaseID)
REFERENCES disease (diseaseID),
CONSTRAINT fk_person FOREIGN KEY (personID)
REFERENCES person (personID)
ON DELETE SET NULL
ON UPDATE SET NULL);

---PERSON TABLE
CREATE TABLE person(
personID SERIAL PRIMARY KEY,
first_name varchar(50),
last_name varchar(50),
gender varchar(2),
primary_locationID int,
age int,
CONSTRAINT fk_person_location FOREIGN KEY (primary_locationID)
REFERENCES locations (locationID));


---LOCATION TABLE
CREATE TABLE locations(
locationID SERIAL PRIMARY KEY NOT NULL,
city_name varchar(50),
state_name varchar(50),
country_name varchar(50));

---INDICATION TABLE
CREATE TABLE indication(
medicineID INT NOT NULL,
diseaseID INT NOT NULL,
effectiveness_percent DOUBLE PRECISION,
PRIMARY KEY (diseaseID,medicineID),
CONSTRAINT fk_diseaseID FOREIGN KEY (diseaseID)
REFERENCES disease (diseaseID),
CONSTRAINT fk_medicine FOREIGN KEY (medicineID)
REFERENCES medicine (medicineID)
On update CASCADE 
On delete CASCADE );

update disease set diseaseid = '6' where diseaseid = '5' 

select * from indication 

---MEDICINE TABLE
CREATE TABLE medicine(
medicineID SERIAL PRIMARY KEY,
standard_industry_name varchar(70),
med_name varchar(50),
company_name varchar(50),
active_ingredient_name varchar(50));

---SECONDARY EFFECT TABLE
CREATE TABLE secondary_effect(
medicineID int,
symptomID int,
contradiction_details varchar(100),
PRIMARY KEY (medicineID, symptomID),
CONSTRAINT fk_symptom FOREIGN KEY (symptomID)
REFERENCES symptoms (symptomID),
CONSTRAINT fk_medicine FOREIGN KEY (medicineID)
REFERENCES medicine (medicineID));


---DATA
INSERT INTO disease
VALUES (1,'ear pain',5,2,4),(2,'urinary track infection',4,2,6),(3,'skin infection',2,2,7),
(4,'bronchitis',5,2,3),(5,'Celiac Disease',2,1,8)

SELECT * FROM disease

---DATA
INSERT INTO disease_type
VALUES(1, 'genetic'),(2,'infectious'),(3,'deficiency'),(4,'psychological')

SELECT * FROM disease_type

---DATA
INSERT INTO disease_symptom
VALUES (1,9,2),(1,1,5),(1,2,3),(2,2,3),(2,6,1),(3,13,3),(3,12,2),(4,3,5),(4,8,2),(4,2,4),(5,12,3),(5,10,2),(5,4,3)

SELECT * FROM disease_symptom

---DATA
INSERT INTO symptoms
VALUES(1,'headache'),(2,'fever'),(3,'respiratory problem'),(4,'diarrhea'),
(5,'body aches'),(6,'severe pain'),(7,'hair loss'),(8,'sore throat'),(9,'dizziness'),
(10,'vomit'),(11,'Constipation'),(12,'Skin rash'), (13,'dermatitis'),
(14,'Drowsiness'),(15,'Dry mouth'),(16,'Insomnia')

SELECT * FROM symptoms

INSERT INTO diseased_patient
VALUES (1,2,5,'2020-06-25','2020-06-28',3,TRUE)
,(2,1,5,'2020-06-01','2020-06-05',4,TRUE),
(3,4,5,'2020-06-01',NULL,29,FALSE),(4,1,3,'2020-06-12','2020-06-15',3,TRUE),
(5,2,2,'2020-06-08','2020-06-11',3,TRUE),(6,2,5,'2020-06-13','2020-06-16',3,TRUE),
(7,3,4,'2020-06-21','2020-06-26',5,TRUE),(8,5,2,'2020-06-04',NULL,26,FALSE),
(9,4,5,'2020-06-20',NULL,10,FALSE),(10,5,2,'2020-06-03',NULL,27,FALSE)

SELECT * FROM diseased_patient

---DATA
INSERT INTO person
VALUES (1,'Jane','Doe','F',2,8),(2,'Lei','Li','F',3,7),(3,'Wei','Li','M',4,8),(4,'Dong','Fang','M',5,6),
(5,'Mary','Lu','F',10,5),(6,'Sara','Smith','M',1,5),(7,'Andrea','Johnson','F',6,8),(8,'Louis','Armstrong','M',7,9),(9,'Sujia', 'Tong','M',4,8),
(10,'Larry','Durand','M',8,7)

SELECT * FROM person

---DATA
INSERT INTO locations
VALUES (1,'New York','NY','United States'),(2,'Los Angeles','CA','United States'),
(3, 'Beijing','Beijing','China'),(4,'Qingdao','Shandong','China'),(5,'Wuhan','Hubei','China')
,(6,'San Francisco','CA','United States'),(7,'Atlanta','GA','United States'),(8,'Orlando','FL','United States'),
(9,'Albany','NY','United States'),(10,'Newark','NJ','United States')

SELECT * FROM locations

---DATA
INSERT INTO indication
VALUES (1,2,75.7),(2,1,80.4),(3,3,98.6),(4,4,84.5),(5,5,66.7)

SELECT * FROM indication

---DATA
INSERT INTO medicine
VALUES (1,'Urinary Pain Relief','AZO UTI','i-Health','Phenazopyridine Hydrochloride'),
(2,'Earache Relief Children','SoothEar','Mommys Bliss','Isomalt'),(3,'Antibiotic','NA','dicloxacillin','Roche'),
(4,'Bronchial Asthma Relief Tablets','NA','Walgreens',' Ephedrine HCI'),(5,'Digestive Health','Probiotic','Lactobacillus rhamnosus GG','Mommys Bliss')

SELECT * FROM medicine

---DATA
INSERT INTO secondary_effect
VALUES(1,4,'stomach upsetness may occur'),(3,4,'diarrhea may occur'),(4,14,'drowziness may occur'),
(2,12,'rash may appear'),(5,11,'constipation may occur')

SELECT * FROM secondary_effect

-----CREATE VIEWS TO ADD DATA TO FACT TABLE
CREATE OR REPLACE VIEW cases_info AS
SELECT DISTINCT a.diseaseID, a.symptomID, b.disease_type_code, c.personID, d.medicineID, e.primary_locationID
FROM  public.disease_symptom a, public.disease b, public.diseased_patient c, public.indication d, public.person e
where a.diseaseID=b.diseaseID
AND a.diseaseID=c.diseaseID
AND a.diseaseID=d.diseaseID
AND c.personID=e.personID
order by c.personID

 SELECT * FROM cases_info

 -----CREATE VIEWS TO ADD DATA TO FACT TABLE
CREATE OR REPLACE VIEW cases_info2 AS
SELECT o.start_date,o.end_date, o.recoveres_indicator,o.severity_value, n.personID, n.diseaseID, n.symptomID, n.medicineID, n.primary_locationID, n.disease_type_code
 FROM public.diseased_patient o
 LEFT JOIN cases_info n
 ON o.personID=n.personID
 and o.diseaseID=n.diseaseID
  SELECT * FROM cases_info2
 
  -----CREATE VIEWS TO ADD DATA TO FACT TABLE
 CREATE OR REPLACE VIEW cases_info3 AS
SELECT y.intensity_value, n.start_date,n.end_date, n.recoveres_indicator,n.severity_value, n.personID, n.diseaseID, n.symptomID, n.medicineID, n.primary_locationID, n.disease_type_code
 FROM public.disease_symptom y
 LEFT JOIN cases_info2 n
 ON y.symptomID=n.symptomID
 and y.diseaseID=n.diseaseID
 
  SELECT * FROM cases_info3
 
  -----CREATE VIEWS TO ADD DATA TO FACT TABLE
 CREATE OR REPLACE VIEW cases_info4 AS
SELECT x.effectiveness_percent, n.intensity_value, n.start_date,n.end_date, n.recoveres_indicator,n.severity_value, n.personID, n.diseaseID, n.symptomID, n.medicineID, n.primary_locationID, n.disease_type_code
 FROM public.indication x
 LEFT JOIN cases_info3 n
 ON x.medicineID=n.medicineID
 and x.diseaseID=n.diseaseID
  
 SELECT * FROM cases_info4
 
  
 


