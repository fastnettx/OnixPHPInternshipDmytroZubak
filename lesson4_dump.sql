--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4 (Ubuntu 12.4-1.pgdg18.04+1)
-- Dumped by pg_dump version 12.4 (Ubuntu 12.4-1.pgdg18.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: ram; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.ram AS (
	type character varying(20),
	memory integer
);


--
-- Name: add_age(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.add_age() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
date_birthday DATE;
BEGIN
date_birthday := NEW.birthday;
NEW.age := extract(year from age(date_birthday));
RETURN NEW;
END;
$$;


--
-- Name: trigger_s_before_del(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.trigger_s_before_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
if (select count(*) from spj a where trim(a.ns)=trim(OLD.ns))>0
then delete from spj where trim(spj.ns)=trim(OLD.ns);
end if;
return OLD;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    price numeric(10,2),
    owner integer,
    processor integer,
    ram public.ram
);


--
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_id_seq OWNED BY public.product.id;


--
-- Name: serial_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.serial_id
    START WITH 10001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer DEFAULT nextval('public.serial_id'::regclass) NOT NULL,
    name character(20) NOT NULL,
    balance numeric(10,2),
    email character varying(30),
    birthday date,
    age smallint,
    CONSTRAINT users_age CHECK (((age > 0) AND (age < 200))),
    CONSTRAINT users_date CHECK ((birthday < (CURRENT_DATE - '1 day'::interval)))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: product id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public.product_id_seq'::regclass);


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product (id, name, price, owner, processor, ram) FROM stdin;
8	memory	1000.00	10039	15000	\N
9	CPU	2500.00	10040	\N	(DDR1,256)
10	memory1	1000.00	10041	15000	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, name, balance, email, birthday, age) FROM stdin;
10008	Vlad                	1000.00	vlad@in.ua	\N	\N
10009	Ivan                	16000.00	ivan@in.ua	\N	\N
10010	Sergey              	1000.00	serg@in.ua	\N	\N
10011	Serg                	10000.00	se@in.ua	2019-09-12	\N
10012	Serg1               	10000.00	se1@in.ua	2019-09-14	\N
10031	Rost                	1004.00	ros@in.ua	1985-10-11	34
10036	Rost1               	1004.00	ros1@in.ua	1978-09-14	42
10038	Rost13              	14004.00	ros13@in.ua	1999-10-11	20
10039	Test1               	200.00	test1@in.ua	2000-05-14	20
10040	Test2               	300.00	test2@in.ua	2001-05-14	19
10041	Test3               	250.00	test3@in.ua	1980-05-15	40
\.


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_id_seq', 10, true);


--
-- Name: serial_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.serial_id', 10042, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 13, true);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_add_age; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER users_add_age BEFORE INSERT OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.add_age();


--
-- Name: product product_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_owner_fkey FOREIGN KEY (owner) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

