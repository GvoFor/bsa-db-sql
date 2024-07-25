# BSA homework: DB & SQL

[setup.sql](./setup.sql) file contains all DDL statements to craete all the tables.

Here is an ER Diagram which represent reletionships between tables.
Note that each table also contain `created_at` and `updated_at` attributes, but they are not present in the diagram for compactness and readability purposes.

```mermaid
erDiagram
    COUNTRY {
        INT id PK
        CHAR(2) code
        VARCHAR(100) name
    }

    GENRE {
        INT id PK
        VARCHAR(50) name
    }

    FILE {
        INT id PK
        VARCHAR(50) name
        VARCHAR(100) mime_type
        VARCHAR(50) key
        VARCHAR(100) url
    }

    USER {
        INT id PK
        VARCHAR(50) firstname
        VARCHAR(50) lastname
        VARCHAR(50) username
        VARCHAR(50) password
        VARCHAR(50) email
        INT avatar_id FK
    }

    PERSON {
        INT id PK
        VARCHAR(50) firstname
        VARCHAR(50) lastname
        TEXT biography
        DATE birthday
        GENDER gender
        INT homecountry_id FK
        INT photo_id FK
    }

    MOVIE {
        INT id PK
        VARCHAR(50) title
        TEXT description
        INT budget
        DATE release_date
        TIME duration
        INT director_id FK
        INT country_id FK
        INT poster_id FK
    }

    CHARACTER {
        INT id PK
        VARCHAR(50) name
        TEXT description
        ROLE role
        INT movie_id FK
    }

    PERSON_PHOTO {
        INT person_id PK, FK
        INT photo_id PK, FK
    }

    MOVIE_GENRE {
        INT movie_id PK, FK
        INT genre_id PK, FK
    }

    FAVORITE_MOVIE {
        INT user_id PK, FK
        INT movie_id PK, FK
    }

    MOVIE_PARTICIPANT {
        INT movie_id PK, FK
        INT participant_id PK, FK
    }

    CHARACTER_PERSON {
        INT character_id PK, FK
        INT person_id PK, FK
    }

    FILE ||--o{ PERSON : "photo_id"
    FILE ||--o{ USER : "avatar_id"
    FILE ||--o{ MOVIE : "photo_id"
    FILE ||--o{ PERSON_PHOTO : "poster_id"
    COUNTRY |o--o{ PERSON : "homecountry_id"
    COUNTRY |o--o{ MOVIE : "country_id"
    MOVIE }o--o| PERSON : "director_id"
    MOVIE }o--|| CHARACTER : "movie_id"
    GENRE ||--o{ MOVIE_GENRE : "genre_id"
    MOVIE_GENRE }o--|| MOVIE : "movie_id"
    USER ||--o{ FAVORITE_MOVIE : "user_id"
    MOVIE ||--o{ FAVORITE_MOVIE : "movie_id"
    MOVIE_PARTICIPANT }o--|| PERSON : "participant_id"
    MOVIE ||--o{ MOVIE_PARTICIPANT : "movie_id"
    PERSON_PHOTO }o--|| PERSON : "person_id"
    PERSON }o--|| CHARACTER_PERSON : "person_id"
    CHARACTER }o--|| CHARACTER_PERSON : "character_id"

```
