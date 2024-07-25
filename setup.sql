BEGIN;

DROP TABLE IF EXISTS character_person;
DROP TABLE IF EXISTS movie_participant;
DROP TABLE IF EXISTS favorite_movie;
DROP TABLE IF EXISTS movie_genre;
DROP TABLE IF EXISTS person_photo;
DROP TABLE IF EXISTS character;
DROP TABLE IF EXISTS movie;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS "user";
DROP TABLE IF EXISTS file;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS country;

CREATE TYPE gender AS ENUM ('M', 'F');
CREATE TYPE role AS ENUM ('leading', 'supporting', 'background');

-- Secondary entities tables

CREATE TABLE country (
  id SERIAL PRIMARY KEY,
  code CHAR(2) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE genre (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE file (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  mime_type VARCHAR(100) NOT NULL,
  key VARCHAR(50) NOT NULL,
  url VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Main entities tables

CREATE TABLE "user" (
  id SERIAL PRIMARY KEY,
  firstname VARCHAR(50),
  lastname VARCHAR(50),
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL UNIQUE,
	avatar_id INT REFERENCES file(id) ON DELETE SET NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CHECK(email ~ '^[\w.]+@\w+\.\w{2,4}$')
);

CREATE TABLE person (
  id SERIAL PRIMARY KEY,
  firstname VARCHAR(50) NOT NULL,
  lastname VARCHAR(50) NOT NULL,
  biography TEXT,
  birthday DATE,
  gender GENDER,
  homecountry_id INT REFERENCES country(id) ON DELETE SET NULL,
  photo_id INT REFERENCES file(id) ON DELETE SET NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE movie (
  id SERIAL PRIMARY KEY,
  title VARCHAR(50) NOT NULL,
  description TEXT,
  budget INT NOT NULL,
  release_date DATE NOT NULL,
  duration TIME NOT NULL,
  director_id INT REFERENCES person(id) ON DELETE SET NULL,
  country_id INT REFERENCES country(id) ON DELETE SET NULL,
  poster_id INT REFERENCES file(id) ON DELETE SET NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE character (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description TEXT,
  role ROLE NOT NULL,
  movie_id INT REFERENCES movie(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Link tables

CREATE TABLE person_photo (
  person_id INT REFERENCES person(id) ON DELETE CASCADE,
  photo_id INT REFERENCES file(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (person_id, photo_id)
);

CREATE TABLE movie_genre (
  movie_id INT REFERENCES movie(id) ON DELETE CASCADE,
  genre_id INT REFERENCES genre(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (movie_id, genre_id)
);

CREATE TABLE favorite_movie (
  user_id INT REFERENCES "user"(id) ON DELETE CASCADE,
  movie_id INT REFERENCES movie(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, movie_id)
);

CREATE TABLE movie_participant (
  movie_id INT REFERENCES movie(id) ON DELETE CASCADE,
  participant_id INT REFERENCES person(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (movie_id, participant_id)
);

CREATE TABLE character_person (
  character_id INT REFERENCES character(id) ON DELETE CASCADE,
  person_id INT REFERENCES person(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (character_id, person_id)
);

-- Add updating for update_at column

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    table_name text;
BEGIN
    FOR table_name IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'public' AND tablename IN (
          'country', 'genre', 'file', 'user', 'person', 'movie', 'character',
          'person_photo', 'movie_genre', 'favorite_movie', 'movie_participant', 'character_person'
        )
    LOOP
        EXECUTE format('
            CREATE TRIGGER update_updated_at_trigger
            BEFORE UPDATE ON %I
            FOR EACH ROW
            EXECUTE FUNCTION update_updated_at_column();
        ', table_name);
    END LOOP;
END;
$$;

COMMIT;
