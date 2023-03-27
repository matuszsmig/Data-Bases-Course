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