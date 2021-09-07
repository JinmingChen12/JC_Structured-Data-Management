-----1. effectiveness_percent vs. disease vs. intensity_value vs medicine
CREATE OR REPLACE VIEW effectiveness AS
SELECT x.effectiveness_percent, n.intensity_value,n.severity_value,  n.disease_type_code,n.diseaseID, n.medicineID
 FROM public.indication x
 LEFT JOIN cases_info3 n
 ON x.medicineID=n.medicineID
 and x.diseaseID=n.diseaseID

---The result and analysis
SELECT effectiveness_percent, intensity_value, disease_type_code, diseaseID,medicineID
FROM effectiveness
ORDER BY effectiveness_percent desc;

SELECT AVG(effectiveness_percent) AS AVG_effectiveness_percent, AVG(intensity_value) as AVG_intensity_value 
FROM effectiveness

----2. How many patients for each disease and what their age group

SELECT Disease.Disease_name,COUNT(diseased_patient.personID) AS Number_Of_Patients,person.age FROM diseased_patient
LEFT JOIN Disease ON Disease.diseaseID = diseased_patient.diseaseID
LEFT JOIN person ON diseased_patient.personID = person.personID
GROUP BY Disease_name,person.age
