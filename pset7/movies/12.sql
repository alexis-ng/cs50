SELECT title FROM movies JOIN stars ON movies.id = stars.movie_id
WHERE  person_id = 136 or person_id = 307
GROUP by id
HAVING COUNT(id)>1
ORDER by title;

