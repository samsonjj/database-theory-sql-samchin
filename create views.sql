-- View 1
-- Listing current medications of patients
drop view if exists patient_medications;
create view patient_medications as (
  select distinct first_name, middle_name, last_name, prescribed_for
  from patient join prescription p ON patient.ssn = p.prescribed_to
  where p.end_date < now()
);

-- View 2
-- List patients with hidden social security number and other information
drop view if exists get_patients;
create view get_patients as (
  select p.first_name, p.middle_name, p.last_name, datediff(now(), date_of_birth) / 365 as age,
    p.occupation, p.city_addr, p.contract, p.primary_physician
  from patient p
);
