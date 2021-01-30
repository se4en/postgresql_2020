DROP TABLE IF EXISTS passengers CASCADE;
DROP TABLE IF EXISTS ports CASCADE;
DROP TABLE IF EXISTS visits CASCADE;
DROP TABLE IF EXISTS ships CASCADE;
DROP TABLE IF EXISTS crew_members CASCADE;
DROP TABLE IF EXISTS cruises CASCADE;
DROP TABLE IF EXISTS tickets CASCADE;

CREATE TABLE IF NOT EXISTS passengers (
  passenger_id SERIAL, --последовательность
  first_name varchar NOT NULL,
  sername varchar NOT NULL,
  phone varchar(12) NOT NULL,
  e_mail varchar,
  PRIMARY KEY (passenger_id)
);

CREATE TABLE IF NOT EXISTS ports (
  port_id SERIAL,
  country varchar NOT NULL,
  city varchar NOT NULL,
  capacity smallint NOT NULL,
  PRIMARY KEY (port_id)
);

CREATE TABLE IF NOT EXISTS ships (
  ship_id SERIAL,
  model varchar NOT NULL,
  ship_name varchar,
  number_of_places integer NOT NULL,
  base_port_id integer DEFAULT 1 REFERENCES ports (port_id)
	ON DELETE SET DEFAULT, --
  PRIMARY KEY (ship_id)
);

CREATE TABLE IF NOT EXISTS crew_members (
  member_id SERIAL,
  first_name varchar NOT NULL,
  sername varchar NOT NULL,
  post varchar,
  ship_id integer REFERENCES ships  
	ON DELETE SET NULL,
  PRIMARY KEY (member_id)
);

CREATE TABLE IF NOT EXISTS cruises (
  cruise_id SERIAL,
  ship_id integer DEFAULT 1 REFERENCES ships 
    ON DELETE SET DEFAULT
	ON UPDATE CASCADE,
  start_port_id integer REFERENCES ports (port_id) 
	ON DELETE SET NULL
	ON UPDATE CASCADE,
  finish_port_id integer REFERENCES ports (port_id) 
	ON DELETE SET NULL
	ON UPDATE CASCADE,
  start_date timestamp,
  finish_date timestamp,
  PRIMARY KEY (cruise_id)
);

CREATE TABLE IF NOT EXISTS tickets (
  ticket_id SERIAL,
  passenger_id integer REFERENCES passengers 
	ON DELETE CASCADE,
  cruise_id integer REFERENCES cruises 
	ON DELETE CASCADE,
  place varchar NOT NULL,
  price money NOT NULL,
  PRIMARY KEY (ticket_id),
  CHECK (price > money(0)) --- привести
);

CREATE TABLE IF NOT EXISTS visits (
  visit_id SERIAL,
  cruise_id integer REFERENCES cruises ON DELETE CASCADE,
  port_id integer REFERENCES ports ON DELETE CASCADE, 
  start_time timestamp NOT NULL,
  end_time timestamp NOT NULL,
  PRIMARY KEY (visit_id)
);

INSERT INTO ports (country, city, capacity) VALUES
  ('Испания', 'Барселона', 7),
  ('Италия', 'Неаполь', 3),
  ('Италия', 'Леворно', 4),
  ('Италия', 'Рим', 6),
  ('Франция', 'Канны', 5),
  ('Испания', 'Майорка', 4),
  ('Франция', 'Марсель', 6),
  ('Италия', 'Генуа', 3),
  ('Испания', 'Малага', 4),
  ('Марокко', 'Касабланка', 4), --10
  ('Португалия', 'Лиссабон', 7),
  ('Испания', 'Ибица', 6),
  ('Греция', 'Афины', 7),
  ('Египет', 'Порт-Саид', 2),
  ('Израиль', 'Ашдод', 2),
  ('Кипр', 'Лимассол', 3),
  ('Греция', 'Миконос', 4),
  ('Турция', 'Кушадасы', 2),
  ('Греция', 'Патмос', 2),
  ('Греция', 'Родос', 3), --20
  ('Греция', 'Санторини', 3),
  ('Италия', 'Венеция', 6),
  ('Черногория', 'Котор', 4),
  ('Греция', 'Корфу', 2),
  ('Хорватия', 'Дубровник', 2),
  ('Италия', 'Бари', 3),
  ('Хорватия', 'Сплит', 3),
  ('Иордания', 'Акаба', 4),
  ('ЮАР', 'Дурбан', 4);
  
INSERT INTO passengers (first_name, sername, phone, e_mail) VALUES
  ('ARTUR', 'GERASIMOV', '+70760429203', 'ar.ger.v@postgrespro.ru'),
  ('MAKSIM', 'ZHUKOV', '+70149562185', 'm-zhukov061972@postgrespro.ru'),
  ('TATYANA', 'KUZNECOVA', '+70400736223', 'kuznetcova-t-011961@postgrespro.ru'),
  ('IRINA', 'ANTONOVA', '+70844502967', 'antonovairina04121972@postgrespro.ru'),
  ('ILYA', 'POPOV', '+70003638926', 'popov_ilya@postgrespro.ru'),
  ('VSEVOLOD', 'BORISOV', '+70126208679', 'borisov_v_1975@postgrespro.ru'),
  ('NATALYA', 'ROMANOVA', '+70898580864', 'n-romanova.1981@postgrespro.ru'),
  ('VALENTINA', 'NICITINA', '+70794132478', 'nikitinavalentina.1975@postgrespro.ru'),
  ('GENNADIY', 'GERASIMOV', '+70733090498', 'gerasimov-g@postgrespro.ru'),
  ('VICTOR', 'IVANOV', '+70467287014', 'ivanovviktor1976@postgrespro.ru'),
  ('OKSANA', 'KOROLEVA', '+70467287014', 'okoroleva1963@postgrespro.ru'),
  ('NIKOLAY', 'IVANOV', '+70512056517', 'ivanovn1963@postgrespro.ru'),
  ('DENIS', 'KUZNECOV', '+70127715737', 'kuznecov-d1978@postgrespro.ru'),
  ('NATALYA', 'BELOVA', '+70969066252', 'natabel@postgrespro.ru'),
  ('YURIY', 'MEDVEDEV', '+70620336121', NULL),
  ('ANZHELIKA', 'ABRAMOVA', '+7051893810', NULL),
  ('SVETLANA', 'VLASOVA', '+70375206559', 's_vlasova_1999@postgrespro.ru'),
  ('PAVEL', 'GUSEV', '+70450902749', NULL),
  ('LEONID', 'ORLOV', '+70569828738', 'l_orl_92@postgrespro.ru'),
  ('TATYANA', 'MAKSIMOVA', '+70235326894', NULL);
  
INSERT INTO ships (model, ship_name, number_of_places, base_port_id) VALUES
  ('epic', 'NORWEGIAN EPIC', 4100, 1),
  ('jade', 'NORWEGIAN JADE', 2100, 13),
  ('epic', 'COSTA SMERALDA', 6500, 4),
  ('fantasia', 'MSC SPLENDIDA', 4300, 9),
  ('fantasia', 'MSC DIVINA', 4250, 7),
  ('jade', 'CELESTYAL CRYSTAL', 1200, 1),
  ('jade', 'CRYSTAL OLIMPIA', 1600, 13),
  ('down', 'NORWEGIAN DOWN', 2340, 17),
  ('lirica', 'MSC OPERA', 2679, 22),
  ('luminosa', 'COSTA DELIZIOSA', 2826, 21);
  
INSERT INTO crew_members (first_name, sername, post, ship_id) VALUES
  ('DAN', 'JAN', 'capitan', 1),
  ('ANNA', 'KAZAKOVA', 'cook', 1),
  ('ILYA', 'BONDARENKO', 'capitan', 3),
  ('EGOR', 'NIKOLAEV', 'capitan', NULL),
  ('SERGEY', 'MOROZOV', 'cook', 7),
  ('ALEKSANDR', 'MAKSIMOV', 'capitan', 4),
  ('ALEX', 'SMITH', 'capitan', 9),
  ('DENIS', 'KLUEV', 'cook', 3),
  ('DAN', 'BORISOV', 'capitan', 6),
  ('ILYA', 'OSIPOV', 'cook', NULL);
  
INSERT INTO cruises (ship_id, start_port_id, finish_port_id, start_date, finish_date) VALUES
  (5, 1, 1, '2020-10-06 15:00', '2020-10-13 17:00'),
  (5, 1, 1, '2020-10-15 15:00', '2020-10-22 17:00'),
  (5, 1, 1, '2020-10-23 15:00', '2020-10-30 17:00'),
  (4, 1, 1, '2020-11-01 21:00', '2020-11-10 10:00'),
  (4, 1, 1, '2020-11-21 21:00', '2020-11-30 10:00'),
  (1, 1, 1, '2020-10-02 14:00', '2020-10-09 13:30'),
  (1, 1, 1, '2020-10-11 18:00', '2020-10-20 17:30'),
  (6, 13, 16, '2020-11-20 13:00', '2020-11-24 22:00'),
  (6, 13, 16, '2020-11-30 14:00', '2020-12-03 17:30'),
  (7, 13, 13, '2020-10-22 11:00', '2020-10-29 23:00'), 
  (7, 13, 13, '2020-10-28 11:00', '2020-11-05 23:00'),
  (7, 13, 13, '2020-11-05 11:00', '2020-11-12 23:00'), 
  (8, 22, 22, '2020-10-15 10:00', '2020-10-23 17:00'),
  (8, 22, 22, '2020-10-24 09:00', '2020-11-02 19:00'), 
  (9, 22, 22, '2020-11-01 12:30', '2020-11-08 16:00'),
  (9, 22, 22, '2020-11-09 12:30', '2020-11-16 16:00'),
  (9, 22, 22, '2020-11-20 14:00', '2020-11-27 19:30'), 
  (10, 22, 29, '2020-10-02 12:30', '2020-10-18 16:00'),
  (10, 22, 29, '2020-10-20 13:00', '2020-11-06 18:00'),
  (10, 22, 29, '2020-11-08 10:30', '2020-11-24 19:00');

INSERT INTO visits (cruise_id, port_id, start_time, end_time) VALUES
  (1, 3, '2020-10-08 7:00', '2020-10-08 23:00'),
  (1, 2, '2020-10-09 9:00', '2020-10-09 22:00'),
  (3, 7, '2020-10-25 9:00', '2020-10-25 22:00'),
  (3, 11, '2020-10-27 8:00', '2020-10-27 21:00'),
  (3, 2, '2020-10-29 11:00', '2020-10-29 23:00'),
  (6, 13, '2020-10-04 11:00', '2020-10-04 23:00'),
  (6, 17, '2020-10-07 9:00', '2020-10-07 22:30'),
  (8, 7, '2020-11-22 10:00', '2020-11-22 23:30'),
  (8, 9, '2020-11-23 11:30', '2020-11-23 22:30'),
  (10, 9, '2020-10-24 11:30', '2020-10-24 22:30'), 
  (10, 4, '2020-10-26 9:30', '2020-10-26 22:30'),
  (12, 25, '2020-11-07 11:00', '2020-11-07 23:00'), 
  (13, 27, '2020-10-18 10:00', '2020-10-18 17:00'),
  (14, 26, '2020-10-25 9:00', '2020-10-25 19:00'), 
  (14, 18, '2020-10-26 10:00', '2020-10-26 22:00'),
  (14, 21, '2020-10-28 8:30', '2020-10-28 23:00'),
  (18, 19, '2020-10-08 7:00', '2020-10-08 23:00'),
  (18, 27, '2020-10-04 9:30', '2020-10-04 21:00'),
  (19, 24, '2020-10-26 9:30', '2020-10-26 21:00'),
  (19, 22, '2020-10-28 10:30', '2020-10-28 19:00');
  
INSERT INTO tickets (passenger_id, cruise_id, place, price) VALUES
  (1, 3, '13F', 42000),
  (1, 1, '17A', 65000),
  (2, 7, '6G', 73500),
  (3, 8, '4T', 39000),
  (4, 11, '12B', 43000),
  (5, 4, '23E', 46000),
  (5, 2, '11A', 61000),
  (7, 6, '11C', 70500),
  (8, 9, '4G', 31000),
  (9, 15, '14A', 40000),
  (9, 13, '5B', 44000),
  (10, 1, '6H', 56000),
  (13, 5, '12D', 41500),
  (13, 9, '3C', 29000),
  (14, 14, '13D', 47500),
  (16, 16, '13C', 48500),
  (17, 1, '19E', 61000),
  (18, 2, '6A', 70000),
  (19, 18, '4E', 33000),
  (20, 20, '11B', 42000);
  
  
  