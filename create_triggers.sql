-- Trigger 1
-- Ensure that patient names are capitalized
create trigger cap_names
  after insert on patient
  for each row
  BEGIN
    update patient
      set first_name = upper(substring(first_name, 0, 1)) +
        substring(first_name, 1, length(first_name));
  END;
