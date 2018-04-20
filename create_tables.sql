-- This file creates tables for the health_insurance_database

drop table if exists physician;
create table physician (
  physician_id decimal(10, 0),
  first_name varchar(255),
  middle_name varchar(255),
  last_name varchar(255),
  work_location varchar(255),
  phone_number decimal(13, 0),
  primary key (physician_id)
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
  foreign key (primary_physician) references physician(physician_id)
);