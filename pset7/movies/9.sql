select name from people where id IN (
select DISTINCT stars.person_id from stars JOIN movies ON stars.movie_id = movies.id
JOIN people ON stars.person_id = people.id
where year =2004)
ORDER BY birth;

