-- Retrieve a list of all users along with their favorite movies as array of identifiers
SELECT
  u.id "ID",
  u.username "Username",
  COALESCE(
    ARRAY_AGG(fm.movie_id) FILTER (WHERE fm.movie_id IS NOT NULL),
    '{}'
  ) "Favorite movie IDs"
FROM "user" u
LEFT JOIN favorite_movie fm ON u.id = fm.user_id
GROUP BY u.id
ORDER BY u.id;
