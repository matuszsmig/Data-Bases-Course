-- trip

insert into trip(trip_name, country, trip_date, max_no_places)
values ('Wycieczka do Paryza', 2, to_date('2022-09-12','YYYY-MM-DD'), 3);

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

-- reservation
-- trip 1
insert into reservation(trip_id, person_id, status)
values (41, 21, 'P');

insert into reservation(trip_id, person_id, status)
values (41, 22, 'N');

-- trip 2
insert into reservation(trip_id, person_id, status)
values (42, 21, 'P');

insert into reservation(trip_id, person_id, status)
values (42, 24, 'C');

-- trip 3
insert into reservation(trip_id, person_id, status)
values (42, 24, 'P');

select * from COUNTRIES

commit;