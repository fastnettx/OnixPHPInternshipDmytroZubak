sudo su - postgres
psql
CREATE USER intern WITH PASSWORD '12345678';
create database market;
alter database market owner to intern;
alter user intern superuser createrole createdb;
\q
psql -U intern -h localhost -d market

CREATE TABLE users (Id SERIAL PRIMARY KEY, Name CHARACTER(20), Balance NUMERIC (3));

ALTER TABLE users ALTER COLUMN Balance TYPE NUMERIC (10,2);
ALTER TABLE users ALTER COLUMN Name  SET NOT NULL;
insert into users (Name, Balance) values ('Ivan', 1033.00);
insert into users (Name, Balance) values ('Sergey', 10133.00);

select * from  users;

CREATE TYPE ram AS (type character varying(20), memory integer);

CREATE TABLE product (Id SERIAL PRIMARY KEY, Name VARCHAR(50) NOT NULL, Price NUMERIC (10,2), Owner INTEGER REFERENCES users (Id) ON DELETE CASCADE, Processor INTEGER NULL, Ram ram NULL);

INSERT INTO product (Name, Price, Owner, Processor, Ram) VALUES ('memory', 1000, 1, 25000, NULL);
INSERT INTO product (Name, Price, Owner, Processor, Ram) VALUES ('memory', 1000, 2, 15000, NULL);
INSERT INTO product (Name, Price, Owner, Processor, Ram) VALUES ('CPU', 2500, 2, NULL , ROW('DDR1', 256));
INSERT INTO product (Name, Price, Owner, Processor, Ram) VALUES ('CPU', 2510, 2, NULL , ROW('DDR4', 6256));

SELECT product.Name, users.Name 
FROM users LEFT JOIN product
ON product.owner = users.id;

UPDATE Product
SET owner = 2
WHERE id = 3;

DELETE FROM users
WHERE name='Sergey';

insert into users (Name, Balance) values ('Vlad', 10133.00);
INSERT INTO product (Name, Price, Owner, Processor, Ram)
VALUES ('memory', 1000, 3, 15000, NULL),
('CPU', 2500, 3, NULL , ROW('DDR1', 256));

SELECT * FROM users;

SELECT users.name,  COUNT(product.name)
FROM product JOIN users
ON product.owner = users.id
GROUP BY users.id; 

ALTER TABLE users
ADD email VARCHAR(30) UNIQUE;


CREATE SEQUENCE serial_id START 10000;
ALTER TABLE users
ALTER COLUMN id
SET DEFAULT NEXTVAL('serial_id'::regclass);

DELETE FROM users;

insert into users (Name, Balance, email) values ('Vlad', 1000.00, 'vlad@in.ua'),
('Ivan', 16000.00, 'ivan@in.ua'),
('Sergey', 1000.00, 'serg@in.ua');

ALTER TABLE users
ADD birthday DATE
CONSTRAINT users_date CHECK(birthday < current_date - interval '1 day');

insert into users (Name, Balance, email, birthday ) values ('Serg1', 10000.00, 'se1@in.ua', '14.09.2019');

ALTER TABLE users
ADD age SMALLINT 
CONSTRAINT users_age CHECK(age >0 AND age < 200);


CREATE OR REPLACE FUNCTION add_age() RETURNS TRIGGER AS $$
DECLARE
date_birthday DATE;
BEGIN
date_birthday := NEW.birthday;
NEW.age := extract(year from age(date_birthday));
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER users_add_age
BEFORE INSERT OR UPDATE  ON users FOR EACH ROW EXECUTE PROCEDURE add_age ();

insert into users (Name, Balance, email, birthday ) values ('Rost', 1004.00, 'ros@in.ua', '14.09.1985');


BEGIN;
insert into users (Name, Balance, email, birthday ) values ('Test1', 200.00, 'test1@in.ua', '14.05.2000'),
 ('Test2', 300.00, 'test2@in.ua', '14.05.2001'),
 ('Test3', 250.00, 'test3@in.ua', '15.05.1980');
INSERT INTO product (Name, Price, Owner, Processor, Ram)
VALUES ('memory', 1000, 10039, 15000, NULL),
('CPU', 2500, 10040, NULL , ROW('DDR1', 256)),
('memory1', 1000, 10041, 15000, NULL);
SAVEPOINT my_savepoint;
COMMIT; \\Успех

BEGIN;
insert into users (Name, Balance, email, birthday ) values ('Test1', 200.00, 'test4@in.ua', '14.05.2000'),
 ('Test2', 300.00, 'test5@in.ua', '14.05.2001'),
 ('Test3', 250.00, 'test6@in.ua', '15.05.1980');
INSERT INTO product (Name, Price, Owner, Processor, Ram)
VALUES ('memory', 1000, 10039, 15000, NULL),
('CPU', 2500, 140, NULL , ROW('DDR1', 256)),
('memory1', 1000, 10041, 15000, NULL);
SAVEPOINT my_savepoint;
COMMIT; \\Откат, не существующий id пользователя

sudo su - postgres
pg_dump -U intern -h localhost -d market>lesson4_dump.sql -O









