-- Movie releases per year, 1900–2019 ("Movie Releases per year" chart).
SELECT extract(year FROM date)::int AS year,
       count(*)                     AS movies
FROM movies
WHERE kind = 'movie'
  AND date >= '1900-01-01' AND date < '2020-01-01'
GROUP BY 1
ORDER BY 1;
