-- Movie releases by genre, 1900–2019 ("Movie Releases by Genre" chart).
-- Category names come in several languages; prefer English, fall back to any.
SELECT coalesce(en.name, other.name) AS genre,
       count(*)                      AS movies
FROM movies m
JOIN movie_categories mc ON mc.movie_id = m.id
LEFT JOIN category_names en ON en.category_id = mc.category_id AND en.language = 'en'
LEFT JOIN LATERAL (
  SELECT name FROM category_names cn WHERE cn.category_id = mc.category_id LIMIT 1
) other ON true
WHERE m.kind = 'movie'
  AND m.date >= '1900-01-01' AND m.date < '2020-01-01'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 25;
