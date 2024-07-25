-- Select detailed information about movies that meet criteria below
-- Criteria
--   Belong to a country with ID of 1.
--   Were released in 2022 or later.
--   Have a duration of more than 2 hours and 15 minutes.
--   Include at least one of the genres: Action or Drama.
SELECT
  m.id "ID",
  m.title "Title",
  m.release_date "Release date",
  m.duration "Duration",
  m.description "Description",
  ROW_TO_JSON(f) "Poster",
  JSON_BUILD_OBJECT(
    'id', p.id,
    'firstname', p.firstname,
    'lastname', p.lastname
  ) "Director"
FROM (
  (
    SELECT m.*
    FROM movie m
    LEFT JOIN movie_genre mg ON m.id = mg.movie_id
    LEFT JOIN genre g ON g.id = mg.genre_id
    GROUP BY m.id
    HAVING
      m.country_id = 1 AND
      m.release_date >= '2022-01-01' AND
      m.duration > '02:15:00' AND
      ARRAY_AGG(g.name) && ARRAY['Action', 'Drama']::character varying[]
  ) AS m
  LEFT JOIN file f ON m.poster_id = f.id
  LEFT JOIN person p ON m.director_id = p.id
);
