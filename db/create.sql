-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.7.0-alpha
-- PostgreSQL version: 9.3
-- Project Site: pgmodeler.com.br
-- Model Author: ---

SET check_function_bodies = false;
-- ddl-end --

drop schema public cascade;
create schema public;

-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: new_database | type: DATABASE --
-- -- DROP DATABASE new_database;
-- CREATE DATABASE new_database
-- ;
-- -- ddl-end --
-- 

-- object: public.tweet | type: TABLE --
-- DROP TABLE public.tweet;
CREATE TABLE public.tweet(
	tweet_id serial NOT NULL,
	json json NOT NULL,
	time timestamp NOT NULL,
	embed_html text,
	processed boolean DEFAULT 'f',
	display boolean DEFAULT 'f',
	num_images integer,
	CONSTRAINT tweet_id PRIMARY KEY (tweet_id)

);

CREATE TABLE public.term_type(
	term_type_id serial,
	type text,
	expires_after interval NOT NULL,
	CONSTRAINT term_type_id PRIMARY KEY (term_type_id)
);
-- ddl-end --
-- object: public.term | type: TABLE --
-- DROP TABLE public.term;
CREATE TABLE public.term(
	term_id serial,
	term text,
	last_queried_at timestamp NULL,
	term_type_id integer,
	CONSTRAINT term_id PRIMARY KEY (term_id)

);
-- ddl-end --
-- object: public.tweets_has_terms | type: TABLE --
-- DROP TABLE public.tweets_has_terms;
CREATE TABLE public.tweets_has_terms(
	tweet_id integer,
	term_id integer,
	CONSTRAINT tweets_has_terms_pk PRIMARY KEY (tweet_id,term_id)

);


ALTER TABLE public.term ADD CONSTRAINT term_type_fk FOREIGN KEY (term_type_id)
REFERENCES public.term_type (term_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;

-- ddl-end --
-- object: tweet_fk | type: CONSTRAINT --
-- ALTER TABLE public.tweets_has_terms DROP CONSTRAINT tweet_fk;
ALTER TABLE public.tweets_has_terms ADD CONSTRAINT tweet_fk FOREIGN KEY (tweet_id)
REFERENCES public.tweet (tweet_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: term_fk | type: CONSTRAINT --
-- ALTER TABLE public.tweets_has_terms DROP CONSTRAINT term_fk;
ALTER TABLE public.tweets_has_terms ADD CONSTRAINT term_fk FOREIGN KEY (term_id)
REFERENCES public.term (term_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: public.image | type: TABLE --
-- DROP TABLE public.image;
CREATE TABLE public.image(
	image_id serial,
	url text,
	term_id integer
);
-- ddl-end --
-- object: term_id | type: CONSTRAINT --
-- ALTER TABLE public.image DROP CONSTRAINT term_id;
ALTER TABLE public.image ADD CONSTRAINT term_id FOREIGN KEY (term_id)
REFERENCES public.term (term_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --



-- Data
INSERT INTO term_type (type, expires_after) VALUES ('media','1 year');
INSERT INTO term_type (type, expires_after) VALUES ('hashtag', '12 hour');
INSERT INTO term_type (type, expires_after) VALUES ('dreamer','1 week');
INSERT INTO term_type (type, expires_after) VALUES ('mentioned','1 week');
INSERT INTO term_type (type, expires_after) VALUES ('nouns','12 hour');
