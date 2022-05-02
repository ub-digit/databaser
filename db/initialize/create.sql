DROP TABLE IF EXISTS databases;
DROP TABLE IF EXISTS database_media_types;
-- DROP TABLE IF EXISTS alternative_titles;
-- DROP TABLE IF EXISTS databas_urls;
-- DROP TABLE IF EXISTS alternative_title_for;
DROP TABLE IF EXISTS database_alternative_titles;
DROP TABLE IF EXISTS topics;
-- DROP TABLE IF EXISTS sub_topic_for;
-- DROP TABLE IF EXISTS topic_for;
DROP TABLE IF EXISTS database_topics;
-- DROP TABLE IF EXISTS database_topic;
DROP TABLE IF EXISTS database_sub_topics;
DROP TABLE IF EXISTS publishers;
-- DROP TABLE IF EXISTS publisher_for;
-- DROP TABLE IF EXISTS urls;
-- DROP TABLE IF EXISTS url_for;
DROP TABLE IF EXISTS database_urls;
-- DROP TABLE IF EXISTS terms_of_use;
-- DROP TABLE IF EXISTS terms_of_use_for;
DROP TABLE IF EXISTS database_terms_of_use;
-- DROP TABLE IF EXISTS topic_recommended_for;
DROP TABLE IF EXISTS media_types;
DROP TABLE IF EXISTS media_type_for;
DROP TABLE IF EXISTS sub_topics;
DROP TABLE IF EXISTS database_publishers;

CREATE TABLE databases (
    id serial PRIMARY KEY,
    title_en text,
    title_sv text,
    description_en text,
    description_sv text,
    is_popular boolean,
    public_access boolean,
    malfunction_message_active boolean,
    malfunction_message text,
    access_information_code text
);

CREATE TABLE database_alternative_titles (
    id serial PRIMARY KEY,
    database_id int,
    title text
);



CREATE TABLE database_terms_of_use (
    id serial PRIMARY KEY,
    description_sv text,
    description_en text,
    permitted boolean,
    database_id int,
    code text
);

CREATE TABLE database_urls (
    id serial PRIMARY KEY,
    database_id int,
    title text,
    url text
);


CREATE TABLE topics (
    id serial PRIMARY KEY,
    name_en text,
    name_sv text
);

CREATE TABLE sub_topics (
    id serial PRIMARY KEY,
    name_en text,
    name_sv text,
    topic_id int
);

CREATE TABLE database_topics (
    id serial PRIMARY KEY,
    database_id int,
    topic_id int,
    is_recommended boolean
);

CREATE TABLE database_sub_topics (
    id serial PRIMARY KEY,
    database_id int,
    topic_id int,
    sub_topic_id int,
    is_recommended boolean
);

CREATE TABLE publishers (
    id serial PRIMARY KEY,
    name text
);

CREATE TABLE database_publishers (
    id serial PRIMARY KEY,
    database_id int,
    publisher_id int
);

CREATE TABLE media_types (
    id serial PRIMARY KEY,
    name_en text,
    name_sv text
);

CREATE TABLE media_type_for (
    id serial PRIMARY KEY,
    database_id int,
    media_type_id int
);

CREATE TABLE database_media_types (
    id serial PRIMARY KEY,
    database_id int,
    media_type_id int
);
