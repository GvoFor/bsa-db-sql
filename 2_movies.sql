-- Select movies released in the last 5 years with the number of actors who have appeared in each movie
SELECT
  m.id "ID",
  m.title "Title",
  COUNT(p.id) "Actors count"
FROM movie m
LEFT JOIN movie_participant mp ON m.id = mp.participant_id
LEFT JOIN person p ON p.id = mp.movie_id
GROUP BY m.id
HAVING m.release_date >= DATE_TRUNC('year', CURRENT_DATE) - INTERVAL '5 year'
ORDER BY m.id;
