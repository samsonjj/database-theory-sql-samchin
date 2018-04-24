-- This file creates tables for the health_insurance_database
use health_insurance_database;

SET FOREIGN_KEY_CHECKS = 0;
drop table if exists contract;
drop table if exists covers;
drop table if exists diagnosis;
drop table if exists diagnosis_code;
drop table if exists fill;
drop table if exists liquid;
drop table if exists medication;
drop table if exists patient;
drop table if exists physician;
drop table if exists prescription;
drop table if exists tablet;
drop table if exists treatment;
SET FOREIGN_KEY_CHECKS = 1;

drop table if exists physician;
create table physician (
  physician_id decimal(10, 0),
  first_name varchar(255) not null,
  middle_name varchar(255),
  last_name varchar(255) not null,
  work_location varchar(255),
  phone_number decimal(13, 0),
  primary key (physician_id)
);

drop table if exists contract;
create table contract (
  contract_id varchar(12),
  deducatible decimal(10, 2),
  copayment   decimal(10, 2),
  primary key (contract_id)
);

drop table if exists patient;
create table patient (
  ssn             decimal(9, 0),
  first_name      varchar(255) not null,
  middle_name     varchar(255),
  last_name       varchar(255) not null,
  date_of_birth   date not null,
  phone_number    decimal(13),
  stree_addr      varchar(255),
  zip_addr        varchar(10),
  city_addr       varchar(255),
  state_addr      varchar(2),
  occupation      varchar(255),
  primary_physician decimal(10, 0),
  contract        varchar(12),
  primary key (ssn),
  foreign key (primary_physician) references physician(physician_id),
  foreign key (contract) references contract(contract_id)
);

drop table if exists medication;
create table medication (
  brand_name      varchar(255),
  generic_name    varchar(255),
  type            varchar(255),
  primary key (brand_name)
);

drop table if exists tablet;
create table tablet (
  medication      varchar(255),
  dose_weight     decimal(10, 3),
  primary key (medication),
  foreign key (medication) references medication(brand_name)
);

drop table if exists liquid;
create table liquid(
  medication      varchar(255),
  dose_volume     decimal(10, 3),
  primary key (medication),
  foreign key (medication) references medication(brand_name)
);

drop table if exists diagnosis_code;
create table diagnosis_code (
  code            varchar(10),
  description     varchar(2000),
  primary key (code)
);

drop table if exists diagnosis;
create table diagnosis (
  diagnosis_code  varchar(10),
  patient         decimal(9, 0),
  diagnosis_date  date,
  comments        varchar(2000),
  primary key (diagnosis_code,patient),
  foreign key (diagnosis_code) references diagnosis_code(code),
  foreign key (patient) references patient(ssn)
);

drop table if exists covers;
create table covers (
  contract varchar(12),
  diagnosis_code varchar(10),
  primary key (contract),
  foreign key (contract) references contract(contract_id),
  foreign key (diagnosis_code) references diagnosis_code(code)
);

drop table if exists prescription;
create table prescription (
  prescription_id decimal(10, 0),
  date_prescribed date,
  total_doses     decimal(7),
  refill_date     date,
  end_date        date,
  prescribed_for  varchar(255),
  prescribed_to   decimal(9, 0),
  prescribed_by   decimal(10, 0),
  primary key (prescription_id),
  foreign key (prescribed_for) references medication(brand_name),
  foreign key (prescribed_to) references patient(ssn),
  foreign key (prescribed_by) references physician(physician_id)
);
alter table prescription add constraint
    check(datediff(end_date, date_prescribed) >= 0);

drop table if exists fill;
create table fill (
  transaction_id  decimal(10, 0),
  transaction_date  date,
  prescription    decimal(10, 0),
  primary key (transaction_id),
  foreign key (prescription) references prescription(prescription_id)
);

drop table if exists treatment;
create table treatment (
  medication varchar(255),
  diagnosis_code varchar(10),
  primary key (medication,diagnosis_code),
  foreign key (medication) references medication(brand_name),
  foreign key (diagnosis_code) references diagnosis_code(code)
);

-- Views

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


-- Triggers

-- Trigger 1
-- Ensure that patient names are lowercase
drop trigger if exists cap_names;
create trigger cap_names
  before insert on patient
  for each row
  BEGIN
      set new.first_name = lower(new.first_name),
        new.middle_name = lower(new.middle_name),
        new.last_name = lower(new.last_name);
  END;

-- Stored Procedures

-- Stored Procedure 1
-- return average age of patients
drop procedure if exists average_age;
create procedure average_age()
begin
  select avg(datediff(now(), date_of_birth) / 365)
  from patient;
end;

-- Insertions

-- 1 Insert contract
insert into contract values
(043184291321, 243504.34, 103243.54),(043184243927, 204381.34, 169327.54);

-- 2 Insert diagnosis_code
insert into diagnosis_code values
('S72.309A', 'Broken Femur'), ('314.1', 'ADHD'), ('I97.3', 'Postprocedural Hypertension'),
('83.28FA4', 'Broken Arm'), ('S482.3293', '3rd Degree burn');

-- 3 Insert covers
insert into covers values
(043184291321, "S72.309A"),(043184243927, "314.1");


-- 4 Insert physician
insert into physician values
(0000000432, 'Silvesto', 'Ramos', 'De Merci', 'Henrico Hospital', 8045552323),
(0000000532, 'Michael', 'Ryan', 'Yakovich', 'Henrico Hospital', 8045549320),
(0000000632, 'Renovich', null, 'Smithson', 'Henrico Hospital', 8045520193),
(0000000633, 'Samuel', null, 'Day', 'St. Marys Hospital', 8045530201),
(0000000433, 'Krishna', null, 'Patel', 'St. Marys Hospital', 8045532930),
(0000005343, 'Laura', 'Samantha', 'Crawford', 'St. Marys Hospital', 8045523043);

-- 5 Insert patient
insert into patient values
  (123456789, 'Jonathan', 'Justino', 'Samson', '1996-08-07', 8045551234, 'Something St.', 23333, 'Richmond', 'VA', 'Database Admin', 0000000432, 043184291321),
  (123452357, 'Renny', 'Young', 'Wremington', '1993-10-05', 8045930134, 'Yosemnite St.', 23333, 'El Paso', 'TX', 'Teacher', 0000000433, 043184243927),
  (123204357, 'Kirk', null, 'Angelo', '1992-05-10', 8041020134, 'Bergeron St.', 23333, 'Albany', 'NY', 'Police Officer', 0000000433, 043184243927),
  (923416789, 'Sivesto', 'Theon', 'Pike', '1993-06-07', 8049214234, 'Pie St.', 23333, 'Seattle', 'WA', 'Cashier', 0000000633, 043184291321),
  (923413219, 'Harry', 'Winifreed', 'Wanker', '1970-10-05', 8043910234, 'Wellington St.', 23333, 'Fairfax', 'VA', 'Soccer Player', 0000005343, 043184243927),
  (123829359, 'Mariazinha', 'Simonetta', 'Neville', '1949-05-01', 8045948534, 'Elder St.', 10394, 'San Jose', 'CA', 'Nurse', 0000000532, 043184291321),
  (123413548, 'Elfriede', 'Clotho', 'Otten', '2007-08-20', 8043842134, 'Prussian St.', 32932, 'Annapolis', 'MD', 'Student', 0000000433, 043184243927),
  (19302357, 'Artemis', 'Minakshi', 'Holst', '1956-12-22', 8041023029, 'Deedington St.', 03921, 'St. Louis', 'MI', 'Architect', 0000000433, 043184243927),
  (967483789, 'Shabnam', 'Magdalena', 'Logan', '1984-02-04', 8043827234, 'Delhi St.', 30291, 'Columbus', 'OH', 'Economist', 0000000633, 043184291321),
  (932847219, 'Annamaria', 'Eva', 'Barbieri', '1969-09-30', 8049328234, 'Maine St.', 47283, 'Queens', 'NY', 'Unemployyed', 0000005343, 043184243927);

-- 6 Insert medication
insert into medication values
('Adderall', 'Adderall', 'Stimulant'),('Viagra', 'Sildenafil', 'Vasodilator'),
('Codeine', 'Codeine', 'Pain Killer'), ('Prinivil', 'Lisinopril', 'Blood Pressure Drug'),
('Z-Pak', 'Azithromycin', 'Antibiotics'), ('Amoxicillin', 'Amoxicillin', 'Antibiotics'),
('Metformin', 'Generic Glucophage', 'Diabetes'),
('Hydrochlorothiazide', 'Hydrochlorothiazide', 'water pill used to lower blood pressure');

-- 7 Insert diagnosis
insert into diagnosis values
('S72.309A', 123456789, '2018-03-04', null), ('314.1', 123452357, '2018-02-03', null),
('I97.3', 123204357, '2018-01-04', 'Hypertension after open heart surgery'), ('314.1',123456789, '1997-11-07','Signs of ADHD'),
('83.28FA4',123456789,'2008-11-02','Several breaks in arm.');

-- 8 Insert prescription
insert into prescription values
(0392857191, '2018-03-01', 45, '2018-03-31', '2018-04-15','Amoxicillin', 123456789, 0000000432),
(0392852845, '2018-03-01', 30, '2018-03-16', '2018-03-31','Viagra', 123456789, 0000000432),
(0392820384, '2018-02-05', 15, null, '2018-02-20','Z-Pak', 123204357, 0000000433),
(0357483845, '2018-01-15', 15, null, '2018-01-30','Z-Pak', 932847219, 0000005343),
(0392832954, '2017-11-01', 45, '2017-11-20', '2017-12-15','Codeine', 967483789, 0000000633),
(0392958425, '2018-08-01', 20, '2018-08-10', '2017-08-30','Adderall', 19302357, 0000000433),
(0954832384, '2017-09-05', 30, '2017-09-20', '2017-10-05','Metformin', 923416789, 0000000633),
(0940343845, '2018-04-10', 20, '2018-04-20', '2018-04-30','Codeine', 123413548, 0000000433),
(0493029384, '2018-04-15', 15, null, '2018-04-30','Hydrochlorothiazide', 123204357, 0000000433),
(0349239214, '2018-01-15', 25, null, '2018-02-09','Z-Pak', 932847219, 0000005343);

-- 9 Insert fill
insert into fill values
(0493845603, '2018-03-31', 0392857191),
(0584159323, '2018-03-16', 0392852845),
(0293158294, '2017-11-20', 0392832954),
(0019849216, '2017-08-10', 0392958425),
(0192384932, '2017-09-20', 0954832384),
(0902142931, '2018-04-20', 0940343845);

-- 10 Insert liquid
insert into liquid values
('Codeine', 300.03),('Prinivil', 200.32),('Amoxicillin', 250.842);

-- 11 Insert tablet
insert into tablet values
('Adderall', 800.009),('Viagra', 500.122),('Metformin', 304.40),('Hydrochlorothiazide', 293.398);

-- 12 Insert treatment
insert into treatment values
('Codeine','S72.309A'), ('Adderall','314.1'), ('Amoxicillin', 'I97.3'),
('Z-Pak','83.28FA4'), ('Codeine','S482.3293');

