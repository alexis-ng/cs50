select DISTINCT name from people
	JOIN stars ON stars.person_id = people.id where people.name != 'Kevin Bacon' and
    movie_id in (
	select movie_id from people JOIN stars ON people.id = stars.person_id
	where name = 'Kevin Bacon' and birth=1958
	)