use health_insurance_database;

-- Query 1
-- List Jonathan Samson's current and past prescriptions
select pr.prescribed_for
from patient pa join prescription pr on pa.ssn = pr.prescribed_to
and pa.first_name = 'Jonathan' and pa.last_name = 'Samson';

-- Query 2
-- How many of Jonathan Samson's current prescriptions end before 1/1/2019?
select count(*)
from patient pa join prescription pr on pa.ssn = pr.prescribed_to
where pa.first_name = 'Jonathan' and pa.last_name = 'Samson'
  and pr.end_date < '2019-1-1';

-- Query 3
-- List Jonathan Samson's medications that need to be refilled before the end of the month
select count(*)
from patient join prescription
  on patient.ssn = prescription.prescribed_to
where patient.first_name = 'Jonathan'
  and patient.last_name = 'Samson'
  and prescription.end_date < last_day(now());

-- Query 4
-- List Jonathan Samson's past diagnoses, and the suggested medications for those diagnoses.
select treatment.medication, diagnosis_code.description, diagnosis_code.code
from patient join diagnosis
  on patient.ssn = diagnosis.patient
  join diagnosis_code on diagnosis.diagnosis_code = diagnosis_code.code
  left outer join treatment on diagnosis.diagnosis_code = treatment.diagnosis_code
where patient.first_name = 'Jonathan'
  and patient.last_name = 'Samson';

-- Query 5
-- List the counts for each occupation that patients have
select patient.occupation, count(*)
from patient
group by patient.occupation;

-- Query 6
-- How many times has Codine been refilled?
select count(*)
from fill join prescription on fill.prescription = prescription.prescription_id
  join medication on medication.brand_name = prescription.prescribed_for
where medication.brand_name = 'Codeine';

-- Query 7
-- How many patients take Eliquis and refill more than monthly?
select count(*)
from patient join prescription p
    on patient.ssn = p.prescribed_to
where prescribed_for = 'Eliquis'
  and refill_interval < 32;
describe prescription;

-- Query 8
-- How many medications are prescribed by 2 or more physicians?
select prescribed_for, c from
  (select prescribed_for, count(*) as c
  from (select distinct prescribed_for, prescribed_by
        from prescription) as B
  group by prescribed_for) as A
where c >= 2;

-- Query 9
-- What is the average prescription length?
select avg(length)
from (select datediff(end_date, date_prescribed) as length
      from prescription) as A;

-- Query 10
-- What percentage of patients with ADHD take Viagra
select count(*)
from patient join prescription ON patient.ssn = prescription.prescribed_to
  join diagnosis ON patient.ssn = diagnosis.patient
  join diagnosis_code ON diagnosis.diagnosis_code = diagnosis_code.code
where diagnosis_code.description like 'ADHD'
  and prescription.prescribed_for like 'Adderall';

-- Query 11
-- List liquid medications prescribed to patients with ADHD
select count(distinct prescribed_for)
from patient join prescription p ON patient.ssn = p.prescribed_to
  join liquid on liquid.medication = p.prescribed_for
  join diagnosis d ON patient.ssn = d.patient
  join diagnosis_code code2 ON d.diagnosis_code = code2.code
where code2.description = 'ADHD';

-- Query 12
-- Calculate the average number of doses per day required
select avg(30 / refill_interval)
from prescription join tablet on prescribed_for = medication;

-- Query 13
-- How many patients have a primary physician who has prescribed Amaryl?
select count(distinct ssn)
from patient join physician p ON patient.primary_physician = p.physician_id
  join prescription p2 ON p.physician_id = p2.prescribed_by
where prescribed_for = 'Codeine';

-- Query 14
-- What is the average age of patients who take Z-Pak?
select avg(datediff(now(), date_of_birth) / 365)
from patient join prescription p ON patient.ssn = p.prescribed_to
where prescribed_for = 'Z-Pak';

-- Query 15
-- How many times was Z-Pak prescribed by physicians at St. Mary's Hospital?
select count(*)
from prescription join physician p ON prescription.prescribed_by = p.physician_id
where prescribed_for = 'Z-Pak'
  and work_location like 'St. Mary%';

-- Query 16
-- What number of medications does Jonathan Samson take that treat
select count(distinct prescribed_for)
from patient join prescription p ON patient.ssn = p.prescribed_to
  join treatment on p.prescribed_for = treatment.medication
  join diagnosis_code code2 ON treatment.diagnosis_code = code2.code
where first_name = 'Jonathan' and last_name = 'Samson'
  and code2.description = 'Postprocedural Hypertension';

-- Query 17
-- How many prescriptions are for Codeine?
select count(*)
from prescription
where prescribed_for = 'Codeine';

-- Query 18
-- How many patients work as Database Admins?
select count(*)
from patient
where occupation like 'Database A%';

-- Query 19
-- How many times has Jonathan Samson been prescribed Amoxicillin?
select count(*)
from prescription join patient p ON prescription.prescribed_to = p.ssn
where prescribed_for = 'Amoxicillin'
  and first_name = 'Jonathan' and last_name = 'Samson';

-- Query 20
-- Show names of physicians that are the primary physician of 2 or more patients
select first_name, last_name
from (select physician_id, count(distinct ssn) as c
from physician join patient on physician.physician_id = patient.primary_physician
group by physician.physician_id) as A
  join physician on A.physician_id = physician.physician_id
where A.c >= 2;