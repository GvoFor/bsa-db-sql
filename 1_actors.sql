-- Select a list of actors along with the total budget of the movies they have appeared in
SELECT
  p.id "ID",
  p.firstname "First name",
  p.lastname "Last name",
  COALESCE(SUM(m.budget), 0) "Total movies budget"
FROM person p
LEFT JOIN movie_participant mp ON p.id = mp.participant_id
LEFT JOIN movie m ON m.id = mp.movie_id
GROUP BY p.id
ORDER BY p.id;
