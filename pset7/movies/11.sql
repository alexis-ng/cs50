SELECT title, rating FROM movies JOIN ratings ON movies.id = ratings.movie_id WHERE movie_id IN
(SELECT movie_id from stars JOIN people ON stars.person_id = people.id WHERE name = "Chadwick Boseman")
ORDER BY rating DESC
LIMIT 5;