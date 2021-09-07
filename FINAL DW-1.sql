CREATE TABLE disease_dw.disease(
diseaseID serial primary key,
disease_name varchar(50),
intensity_level_qty int,
disease_type_code int,
sourceID int);

INSERT INTO disease_dw.disease 
(SELECT * FROM public.disease);

SELECT * FROM disease_dw.disease

CREATE TABLE disease_dw.disease_type(
disease_type_code SERIAL PRIMARY KEY NOT NULL,
disease_type_description varchar(100));

INSERT INTO disease_dw.disease_type
(SELECT * FROM public.disease_type);

SELECT * FROM disease_dw.disease_type;

CREATE TABLE disease_dw.symptoms(
symptomID serial primary key,
symptom_name varchar(50));

INSERT INTO disease_dw.symptoms
(SELECT * FROM public.symptoms);

SELECT * FROM disease_dw.symptoms;

CREATE TABLE disease_dw.person(
personID SERIAL PRIMARY KEY,
first_name varchar(50),
last_name varchar(50),
gender varchar(2),
primary_locationID int,
age int);

INSERT INTO disease_dw.person
(SELECT * FROM public.person);

SELECT * FROM disease_dw.symptoms;

CREATE TABLE disease_dw.locations(
locationID SERIAL PRIMARY KEY NOT NULL,
city_name varchar(50),
state_name varchar(50),
country_name varchar(50));

INSERT INTO disease_dw.locations
(SELECT * FROM public.locations);

SELECT * FROM disease_dw.locations;

CREATE TABLE disease_dw.medicine(
medicineID SERIAL PRIMARY KEY,
standard_industry_name varchar(70),
med_name varchar(50),
company_name varchar(50),
active_ingredient_name varchar(50));

INSERT INTO disease_dw.medicine
(SELECT * FROM public.medicine);

SELECT * FROM disease_dw.medicine;

CREATE TABLE disease_dw.cases_dis_fact
(caseID SERIAL PRIMARY KEY,
 start_date date, 
end_date date, 
recovered_indicator boolean,
symptoms_intensity_value int,
indication_effectiveness int,
severity int,
diseaseID int references disease_dw.disease (diseaseID),
disease_type_code  int references disease_dw.disease_type (disease_type_code ),
medicineID int references disease_dw.medicine (medicineID),
symptomID int references disease_dw.symptoms (symptomID),
personID int references disease_dw.person (personID),
locationID int references disease_dw.locations (locationID)
  ON delete cascade 
    ON update cascade 
);



INSERT INTO disease_dw.cases_dis_fact (start_date,end_date, recovered_indicator, symptoms_intensity_value,indication_effectiveness, severity, diseaseID , disease_type_code, medicineID,symptomID, personID, locationID)
(SELECT DISTINCT  f.start_date,f.end_date, f.recoveres_indicator,f.intensity_value,f.effectiveness_percent, f.severity_value, 
 a.diseaseID, d.disease_type_code,c.medicineID, b.symptomID,  e.personID, e.primary_locationID 
FROM disease_dw.disease a, disease_dw.symptoms b,  disease_dw.person e, disease_dw.medicine c,disease_dw.disease_type d,public.cases_info4 f
WHERE a.diseaseID=f.diseaseID  
AND b.symptomID=f.symptomID 
AND c.medicineID=f.medicineID
AND d.disease_type_code=f.disease_type_code
AND e.personID=f.personID
AND e.primary_locationID=f.primary_locationID);

 
SELECT * FROM disease_dw.cases_dis_fact

delete from disease where diseaseid = '5';


drop table disease_dw.cases_dis_fact
 


