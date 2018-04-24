-- Stored Procedure 1
-- return average age of patients
drop procedure if exists average_age;
create procedure average_age()
begin
  select avg(datediff(now(), date_of_birth) / 365)
  from patient;
end;