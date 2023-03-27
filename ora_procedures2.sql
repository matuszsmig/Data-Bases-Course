create or replace procedure AddReservation2(p_trip_id int, p_person_id int)
as
  trip_id_exists int;
  person_id_exists int;
begin
    select 1 into trip_id_exists from AVAILABLETRIPS where TRIP_ID = p_trip_id;
    select 1 into person_id_exists from PERSON where PERSON_ID = p_person_id;

    if person_id_exists > 0 and person_id_exists > 0 then
        insert into RESERVATION(trip_id, person_id, STATUS)
        values (p_trip_id, p_person_id, 'N');
    ELSE
        raise_application_error(-20001, 'cant add reservation');
    END IF;
end;


create or replace procedure ModifyReservationStatus2(p_reservation_id int, p_status char)
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
        ELSE
            raise_application_error(-20002, 'cant change');
        end if;
    ELSE
        raise_application_error(-20001, 'same status');
    END IF;
end;


create or replace procedure AddReservation3(p_trip_id int, p_person_id int)
as
begin
    insert into RESERVATION(trip_id, person_id, STATUS)
    values (p_trip_id, p_person_id, 'N');
end;

create or replace procedure ModifyReservationStatus3(p_reservation_id int, p_status char)
as
begin
    UPDATE RESERVATION
    SET STATUS = p_status
    WHERE RESERVATION_ID = p_reservation_id;
end;



ALTER TABLE TRIP ADD no_available_places INT;

create or replace procedure przelicz(p_trip_id int)
as
  trip_id_exists int;
  num_of_places int;
  max_places int;
begin
    select 1, MAX_NO_PLACES into trip_id_exists, max_places
                            from TRIP where TRIP_ID = p_trip_id;
    select min(count(*)) into num_of_places
    from RESERVATION r
    group by r.STATUS, r.TRIP_ID
        having r.STATUS not like 'C' and r.TRIP_ID = p_trip_id;
    if trip_id_exists > 0 then
        UPDATE TRIP
        SET no_available_places = max_places - nvl(num_of_places,0)
        WHERE TRIP_ID = p_trip_id;
    end if;
end;

create or replace procedure ModifyNoPlaces4(p_trip_id int, p_no_places int)
as
  trip_id_exists int;
  current_places int;
  places_left int;
begin
    select 1 into trip_id_exists from TRIP where TRIP_ID = p_trip_id;
    select NO_AVAILABLE_PLACES, MAX_NO_PLACES into places_left, current_places from TRIP
                                                where TRIP_ID = p_trip_id;

    if (p_no_places >= current_places - places_left) and trip_id_exists > 0 then
        UPDATE_TRIP(p_trip_id);
        commit;
        UPDATE TRIP
        SET MAX_NO_PLACES = p_no_places
        WHERE TRIP_ID = p_trip_id;
    ELSE
        raise_application_error(-20001, 'cant change number of places');
    END IF;
end;

create or replace procedure ModifyNoPlaces5(p_trip_id int, p_no_places int)
as
begin
    UPDATE_TRIP(p_trip_id);
    commit;
    UPDATE TRIP
    SET MAX_NO_PLACES = p_no_places
    WHERE TRIP_ID = p_trip_id;
end;

begin
    ModifyNoPlaces4(95, 22);
end;