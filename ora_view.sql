create view trip_reservations
as
    select COT.COUNTRY_NAME, t.TRIP_DATE, t.TRIP_NAME, p.FIRSTNAME,
           p.LASTNAME, r.RESERVATION_ID, r.STATUS
    from reservation r join person p
        on r.person_id = p.person_id
    join trip t
        on r.TRIP_ID = t.TRIP_ID
    join COUNTRY_OF_TRIP COT on t.TRIP_ID = COT.TRIP_ID;

create view trips
as
    select distinct COT.COUNTRY_NAME, t.TRIP_DATE, t.TRIP_NAME, t.MAX_NO_PLACES,
           t.MAX_NO_PLACES - count(*) over (partition by t.TRIP_NAME) no_available_places
    from reservation r join person p
        on r.person_id = p.person_id
    join trip t
        on r.TRIP_ID = t.TRIP_ID
    join COUNTRY_OF_TRIP COT on t.TRIP_ID = COT.TRIP_ID
        where r.STATUS not like 'C';

create view AvailableTrips
as
    select distinct COT.COUNTRY_NAME, t.TRIP_DATE, t.TRIP_NAME, t.MAX_NO_PLACES,
        ts.no_available_places
    from reservation r join person p
        on r.person_id = p.person_id
    join trip t
        on r.TRIP_ID = t.TRIP_ID
    join COUNTRY_OF_TRIP COT
        on t.TRIP_ID = COT.TRIP_ID
    join TRIPS ts
        on ts.TRIP_NAME = t.TRIP_NAME
    where ts.no_available_places > 0;

select * from AvailableTrips;
