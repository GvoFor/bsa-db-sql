-- Select directors along with the average budget of the movies they have directed
SELECT
  p.id "ID",
  (p.firstname || ' ' || p.lastname) "Director name",
  ROUND(AVG(m.budget), 2) "Average budget"
FROM movie m
LEFT JOIN person p ON m.director_id = p.id
GROUP BY p.id
ORDER BY p.id;
