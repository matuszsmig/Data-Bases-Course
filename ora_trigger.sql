create or replace trigger tr_update_log
    after insert or update
    on reservation
    for each row
begin
    insert into log (reservation_id, log_date, status)
    values (:new.reservation_id, current_date, :new.status);
end;

create or replace trigger tr_on_delete
    after delete
    on reservation
    for each row
begin
    raise_application_error(-20001, 'you cant delete it');
end;

CREATE OR REPLACE TRIGGER reservation_trigger
BEFORE INSERT ON RESERVATION
FOR EACH ROW
DECLARE
  trip_id_exists NUMBER;
  person_id_exists NUMBER;
BEGIN
  SELECT 1 INTO trip_id_exists FROM AVAILABLETRIPS WHERE TRIP_ID = :NEW.TRIP_ID;
  SELECT 1 INTO person_id_exists FROM PERSON WHERE PERSON_ID = :NEW.PERSON_ID;

  IF (trip_id_exists IS NULL OR person_id_exists IS NULL) THEN
    RAISE_APPLICATION_ERROR(-20001, 'Cannot add reservation');
  END IF;
END;


create or replace trigger update_trigger
before update on RESERVATION
for each row
declare
    num_of_places NUMBER;
begin
    select NO_AVAILABLE_PLACES into num_of_places from
                                    TRIP
                                        where TRIP_ID = :old.TRIP_ID;

    if not :new.STATUS = :old.STATUS and (:new.STATUS = 'N'
                          or :new.STATUS = 'P' or :new.STATUS = 'C') then
        if (:old.STATUS = 'C' and (:new.STATUS = 'N' or :new.STATUS = 'P')
               and num_of_places > 0)
               or (not :old.STATUS = 'C') then
            null;
        ELSE
            raise_application_error(-20002, 'cant change');
        end if;
    ELSE
        raise_application_error(-20001, 'same status');
    END IF;
end;


CREATE OR REPLACE TRIGGER reservation_trigger2
BEFORE INSERT ON RESERVATION
FOR EACH ROW
DECLARE
  trip_id_exists NUMBER;
  person_id_exists NUMBER;
  num_of_places int;
BEGIN
  SELECT 1 INTO trip_id_exists FROM TRIP WHERE TRIP_ID = :NEW.TRIP_ID;
  SELECT 1 INTO person_id_exists FROM PERSON WHERE PERSON_ID = :NEW.PERSON_ID;
  SELECT NO_AVAILABLE_PLACES INTO num_of_places FROM TRIP WHERE TRIP_ID = :NEW.TRIP_ID;

  IF (trip_id_exists IS NULL OR person_id_exists IS NULL and num_of_places>0) THEN
    RAISE_APPLICATION_ERROR(-20001, 'Cannot add reservation');
  END IF;
END;

create or replace trigger update_trigger2
before update on RESERVATION
for each row
declare
    num_of_places NUMBER;
begin
    select NO_AVAILABLE_PLACES into num_of_places from
                                    TRIP where TRIP_ID = :old.TRIP_ID;

    if not :new.STATUS = :old.STATUS and (:new.STATUS = 'N'
                          or :new.STATUS = 'P' or :new.STATUS = 'C') then
        if (:old.STATUS = 'C' and (:new.STATUS = 'N' or :new.STATUS = 'P')
               and num_of_places > 0)
               or (not :old.STATUS = 'C') then
            null;
        ELSE
            raise_application_error(-20002, 'cant change');
        end if;
    ELSE
        raise_application_error(-20001, 'same status');
    END IF;
end;

create or replace trigger trigger_change
before update on TRIP
for each row
begin

    if (:new.MAX_NO_PLACES >= :old.MAX_NO_PLACES - :old.NO_AVAILABLE_PLACES) then
        null;
    ELSE
        raise_application_error(-20001, 'cant change number of places');
    END IF;
end;
