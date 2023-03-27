create table person
(
  person_id int generated always as identity not null,
  firstname varchar(50),
  lastname varchar(50),
  constraint person_pk primary key ( person_id ) enable
);

create table trip
(
  trip_id int generated always as identity not null,
  trip_name varchar(100),
  country int,
  trip_date date,
  max_no_places int,
  constraint trip_pk primary key ( trip_id ) enable
);

create table countries
(
    country int generated always as identity not null,
    country_name varchar(50),
    constraint country_pk primary key ( country ) enable
);

create table reservation
(
  reservation_id int generated always as identity not null,
  trip_id int,
  person_id int,
  status char(1),
  constraint reservation_pk primary key ( reservation_id ) enable
);


alter table reservation
add constraint reservation_fk1 foreign key
( person_id ) references person ( person_id ) enable;

alter table reservation
add constraint reservation_fk2 foreign key
( trip_id ) references trip ( trip_id ) enable;

alter table reservation
add constraint reservation_chk1 check
(status in ('N','P','C')) enable;

alter table COUNTRIES
add constraint country_fk foreign key
( country ) references trip ( country ) enable;

alter table log
add constraint log_chk1 check
(status in ('N','P','C')) enable;

alter table log
add constraint log_fk1 foreign key
( reservation_id ) references reservation ( reservation_id ) enable;

create table log
(
	log_id int generated always as identity not null,
	reservation_id int not null,
	log_date date  not null,
	status char(1),
	constraint log_pk primary key ( log_id ) enable
);


-- trip

insert into trip(trip_name, country, trip_date, max_no_places)
values ('Wycieczka do Paryza', 2, to_date('2022-09-12','YYYY-MM-DD'), 3);
insert into trip(trip_name, country, trip_date, max_no_places)
values ('XXXX', 2, to_date('2022-09-12','YYYY-MM-DD'), 3);
insert into trip(trip_name, country, trip_date,  max_no_places)
values ('Piękny Kraków', 1, to_date('2023-07-03','YYYY-MM-DD'), 2);
insert into trip(trip_name, country, trip_date,  max_no_places)
values ('Znów do Francji', 2, to_date('2023-05-01','YYYY-MM-DD'), 2);
insert into trip(trip_name, country, trip_date,  max_no_places)
values ('Hel', 1, to_date('2023-05-01','YYYY-MM-DD'), 2);
insert into trip(trip_name, country, trip_date,  max_no_places)
values ('Wycieczka do Sandomierza', 1, to_date('2022-09-05','YYYY-MM-DD'), 4);

insert into COUNTRIES(COUNTRY_NAME)
values ('Polska');
insert into COUNTRIES(COUNTRY_NAME)
values ('Francja');
insert into COUNTRIES(COUNTRY_NAME)
values ('Niemcy');

-- person

insert into person(firstname, lastname)
values ('Jan', 'Nowak');
insert into person(firstname, lastname)
values ('Jan', 'Kowalski');
insert into person(firstname, lastname)
values ('Jan', 'Nowakowski');
insert into person(firstname, lastname)
values ('Adam', 'Kowalski');
insert into person(firstname, lastname)
values  ('Novak', 'Nowak');
insert into person(firstname, lastname)
values ('Piotr', 'Piotrowski');
insert into person(firstname, lastname)
values ('Mariano', 'Piotowski');
insert into person(firstname, lastname)
values ('Robret', 'Lewandowski');
insert into person(firstname, lastname)
values ('Anna', 'Curie');
insert into person(firstname, lastname)
values ('Piotr', 'Cebula');

-- reservation
-- trip 1
insert into reservation(trip_id, person_id, status)
values (94, 88, 'P');
insert into reservation(trip_id, person_id, status)
values (94, 89, 'N');
-- trip 2
insert into reservation(trip_id, person_id, status)
values (95, 96, 'P');
insert into reservation(trip_id, person_id, status)
values (95, 93, 'C');
-- trip 3
insert into reservation(trip_id, person_id, status)
values (96, 92, 'N');
insert into reservation(trip_id, person_id, status)
values (96, 90, 'N');
--trip 4
insert into reservation(trip_id, person_id, status)
values (97, 95, 'P');
insert into reservation(trip_id, person_id, status)
values (97, 89, 'C');
--trip 5
insert into reservation(trip_id, person_id, status)
values (98, 92, 'C');
insert into reservation(trip_id, person_id, status)
values (98, 94, 'N');

commit;


create or replace view COUNTRY_OF_TRIP as
SELECT t.TRIP_ID, c.COUNTRY_NAME
        from TRIP t join COUNTRIES c
            on c.COUNTRY = t.COUNTRY;

create or replace view trip_reservations
as
    select COT.COUNTRY_NAME, t.TRIP_DATE, t.TRIP_NAME, p.FIRSTNAME,
           p.LASTNAME, r.RESERVATION_ID, r.STATUS, t.TRIP_ID
    from reservation r join person p
        on r.person_id = p.person_id
    join trip t
        on r.TRIP_ID = t.TRIP_ID
    join COUNTRY_OF_TRIP COT on t.TRIP_ID = COT.TRIP_ID;

create or replace view num_of_trips
as
    select distinct tr.COUNTRY_NAME, t.TRIP_ID, count(*) reserved
    from trip_reservations tr
    join TRIP t on t.TRIP_ID = tr.TRIP_ID
    group by t.TRIP_ID, tr.COUNTRY_NAME, tr.STATUS
        having tr.STATUS not like 'C';

create or replace view trips
as
    select t. TRIP_NAME, ct.COUNTRY_NAME, t.TRIP_DATE, t.MAX_NO_PLACES,
           t.MAX_NO_PLACES - nvl(nt.reserved,0) no_available_places, t.TRIP_ID
    from trip t join COUNTRY_OF_TRIP ct on t.TRIP_ID = ct.TRIP_ID
        left join num_of_trips nt on nt.TRIP_ID = t.TRIP_ID;

create or replace view AvailableTrips
as
    select distinct tr.COUNTRY_NAME, tr.TRIP_DATE, tr.TRIP_NAME, tr.MAX_NO_PLACES,
        tr.no_available_places, tr.TRIP_ID
    from trips tr
    where tr.no_available_places > 0 and tr.TRIP_DATE > CURRENT_DATE;

create or replace view trips4
as
    select t. TRIP_NAME, ct.COUNTRY_NAME, t.TRIP_DATE, t.MAX_NO_PLACES,
           t.NO_AVAILABLE_PLACES, t.TRIP_ID
    from trip t join COUNTRY_OF_TRIP ct on t.TRIP_ID = ct.TRIP_ID;

create or replace view AvailableTrips4
as
    select distinct tr.COUNTRY_NAME, tr.TRIP_DATE, tr.TRIP_NAME, tr.MAX_NO_PLACES,
        tr.no_available_places, tr.TRIP_ID
    from trips4 tr
    where tr.no_available_places > 0 and tr.TRIP_DATE > CURRENT_DATE;


create or replace type trip_participant as OBJECT
(
    COUNTRY_NAME varchar2(50),
    trip_date date,
    trip_name varchar(100),
    firstname varchar(50),
    lastname varchar(50),
    reservation_id int,
    status char(1)
);
create or replace type trip_participant_table is table of trip_participant;

create or replace function TripParticipants(trip_id int)
    return trip_participant_table
as
    result trip_participant_table;
begin
    select trip_participant(COT.COUNTRY_NAME, t.TRIP_DATE,
        t.TRIP_NAME, p.FIRSTNAME,
           p.LASTNAME, r.RESERVATION_ID, r.STATUS) bulk collect
    into result
    from reservation r join person p
        on r.person_id = p.person_id
    join trip t
        on r.TRIP_ID = t.TRIP_ID
    join COUNTRY_OF_TRIP COT on t.TRIP_ID = COT.TRIP_ID
    where r.TRIP_ID = TripParticipants.trip_id;

    return result;
end;


create or replace function PersonReservations(person_id int)
    return trip_participant_table
as
    result trip_participant_table;
begin
    select trip_participant(COT.COUNTRY_NAME, t.TRIP_DATE,
        t.TRIP_NAME, p.FIRSTNAME,
           p.LASTNAME, r.RESERVATION_ID, r.STATUS) bulk collect
    into result
    from reservation r join person p
        on r.person_id = p.person_id
    join trip t
        on r.TRIP_ID = t.TRIP_ID
    join COUNTRY_OF_TRIP COT on t.TRIP_ID = COT.TRIP_ID
    where p.PERSON_ID = PersonReservations.person_id;

    return result;
end;

create or replace type avaliable_Trips as OBJECT
(
    COUNTRY_NAME varchar2(50),
    TRIP_NAME varchar2(50),
    TRIP_DATE date
);
create or replace type avaliable_Trips_table is table of avaliable_Trips;

create or replace function avaliable_Trips_fun(country varchar2, date_from date, date_to date)
    return avaliable_Trips_table
as
    result avaliable_Trips_table;
begin
    select avaliable_Trips(AvT.COUNTRY_NAME, AvT.TRIP_NAME,
        AvT.TRIP_DATE) bulk collect
    into result
    from AVAILABLETRIPS AvT
    where AvT.COUNTRY_NAME = avaliable_Trips_fun.country and (AvT.TRIP_DATE between date_from and date_to);

    return result;
end;

create or replace function avaliable_Trips_fun4(country varchar2,
    date_from date, date_to date)
    return avaliable_Trips_table
as
    result avaliable_Trips_table;
begin
    select avaliable_Trips(AvT.COUNTRY_NAME, AvT.TRIP_NAME,
        AvT.TRIP_DATE) bulk collect
    into result
    from AVAILABLETRIPS2 AvT
    where AvT.COUNTRY_NAME = avaliable_Trips_fun4.country
      and (AvT.TRIP_DATE between date_from and date_to);

    return result;
end;


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