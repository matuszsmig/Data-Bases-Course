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