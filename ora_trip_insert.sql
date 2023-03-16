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


select * from RESERVATION

commit;