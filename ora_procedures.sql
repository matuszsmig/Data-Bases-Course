create or replace procedure AddReservation(p_trip_id int, p_person_id int)
as
  trip_id_exists int;
  person_id_exists int;
  my_date date;
  my_reservation_id int;
begin
    select 1 into trip_id_exists from AVAILABLETRIPS where TRIP_ID = p_trip_id;
    select 1 into person_id_exists from PERSON where PERSON_ID = p_person_id;
    select tid.TRIP_DATE into my_date from AVAILABLETRIPS TID where
                                                      TID.TRIP_ID = p_trip_id;
    select r.RESERVATION_ID into my_reservation_id from RESERVATION r
                           where r.TRIP_ID = p_trip_id and r.PERSON_ID=p_person_id
                             and ROWNUM = 1;

    if (my_date > CURRENT_DATE) and person_id_exists > 0 then
        insert into RESERVATION(trip_id, person_id, STATUS)
        values (p_trip_id, p_person_id, 'N');
        insert into log(reservation_id, log_date, STATUS)
        values (my_reservation_id, to_date(current_date), 'N');
    ELSE
        raise_application_error(-20001, 'cant add reservation');
    END IF;
end;


create or replace procedure ModifyReservationStatus(p_reservation_id int, p_status char)
as
  trip_id_to_find int;
  current_status char;
  num_of_places int;
begin
    select TRIP_ID into trip_id_to_find from RESERVATION
                                        where RESERVATION_ID = p_reservation_id;
    select STATUS into current_status from RESERVATION
                                      where RESERVATION_ID = p_reservation_id;
    select NO_AVAILABLE_PLACES into num_of_places from
                                  AVAILABLETRIPS where TRIP_ID = trip_id_to_find;

    if not p_status = current_status and (p_status = 'N'
                          or p_status = 'P' or p_status = 'C') then
        if (current_status = 'C' and (p_status = 'N' or p_status = 'P')
               and num_of_places > 0)
               or (not current_status = 'C') then
            UPDATE RESERVATION
            SET STATUS = p_status
            WHERE RESERVATION_ID = p_reservation_id;
            insert into log(reservation_id, log_date, STATUS)
            values (p_reservation_id, to_date(current_date), p_status);
        ELSE
            raise_application_error(-20002, 'cant change');
        end if;
    ELSE
        raise_application_error(-20001, 'same status');
    END IF;
end;

create or replace procedure ModifyNoPlaces(p_trip_id int, p_no_places int)
as
  trip_id_exists int;
  current_places int;
  places_left int;
begin
    select 1 into trip_id_exists from TRIP where TRIP_ID = p_trip_id;
    select NO_AVAILABLE_PLACES into places_left from AVAILABLETRIPS
                                                where TRIP_ID = p_trip_id;
    select MAX_NO_PLACES into current_places from TRIP where TRIP_ID = p_trip_id;

    if (p_no_places >= current_places - places_left) and trip_id_exists > 0 then
        UPDATE TRIP
        SET MAX_NO_PLACES = p_no_places
        WHERE TRIP_ID = p_trip_id;
    ELSE
        raise_application_error(-20001, 'cant change number of places');
    END IF;
end;

