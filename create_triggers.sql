-- Trigger 1
-- Ensure that patient names are lowercase
create trigger cap_names
  after insert on patient
  for each row
  BEGIN
    update patient
      set first_name = lower(first_name)
    where first_name = 'Jonathan';
  END;