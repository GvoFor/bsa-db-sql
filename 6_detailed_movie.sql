-- Select detailed information about a movie with ID of 1
SELECT
  m.id "ID",
  m.title "Title",
  m.release_date "Release date",
  m.duration "Duration",
  m.description "Description",
  ROW_TO_JSON(f) "Poster",
  ROW_TO_JSON(d) "Director",
  TO_JSON(a.actors) "Actors",
  TO_JSON(g.genres) "Genres"
FROM (
  (SELECT * FROM movie WHERE id = 1) AS m
  LEFT JOIN file f ON m.poster_id = f.id
  LEFT JOIN (
    SELECT
      p.id,
      p.firstname,
      p.lastname,
      ROW_TO_JSON(f) "photo"
    FROM person p
    LEFT JOIN file f ON p.photo_id = f.id
  ) AS d ON m.director_id = d.id
  LEFT JOIN (
    SELECT
      m.id,
      ARRAY_AGG(a) "actors"
    FROM movie m
    LEFT JOIN movie_participant mp ON m.id = mp.movie_id
    LEFT JOIN (
      SELECT
        p.id,
        p.firstname,
        p.lastname,
        ROW_TO_JSON(f) "photo"
      FROM person p
      LEFT JOIN file f ON p.photo_id = f.id
    ) AS a ON a.id = mp.participant_id
    GROUP BY m.id
  ) AS a ON a.id = m.id
  LEFT JOIN (
    SELECT
      m.id,
      ARRAY_AGG(
        JSON_BUILD_OBJECT(
          'id', g.id,
          'name', g.name
        )
      ) "genres"
    FROM movie m
    LEFT JOIN movie_genre mg ON m.id = mg.movie_id
    LEFT JOIN genre g ON g.id = mg.genre_id
    GROUP BY m.id
  ) AS g ON g.id = m.id
);
