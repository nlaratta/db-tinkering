-- Average budget, revenue and profit of comedies per year, 1950–2023
-- ("Average Revenue and Budget of Comedy Movies" chart). Years where the
-- average profit is negative are the "losing years" in the dashboard.
WITH comedy AS (
  SELECT DISTINCT m.id, m.date, m.budget, m.revenue
  FROM movies m
  JOIN movie_categories mc ON mc.movie_id = m.id
  JOIN category_names cn   ON cn.category_id = mc.category_id
  WHERE m.kind = 'movie'
    AND cn.language = 'en' AND cn.name = 'Comedy'
    AND m.date >= '1950-01-01' AND m.date < '2024-01-01'
    AND m.budget > 0 AND m.revenue > 0
)
SELECT extract(year FROM date)::int  AS year,
       count(*)                      AS movies,
       round(avg(budget))            AS avg_budget,
       round(avg(revenue))           AS avg_revenue,
       round(avg(revenue - budget))  AS avg_profit
FROM comedy
GROUP BY 1
ORDER BY 1;
