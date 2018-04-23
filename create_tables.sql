-- This file creates tables for the health_insurance_database

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
  primary key (diagnosis_code),
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
  primary key (medication),
  foreign key (medication) references medication(brand_name),
  foreign key (diagnosis_code) references diagnosis_code(code)
);

show tables;
use health_insurance_database;
select * from patient;
