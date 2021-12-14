-- Oppgave 1

SELECT filmcharacter, COUNT(*) 
FROM filmcharacter 
GROUP BY filmcharacter 
HAVING COUNT(*) > 2000 
ORDER BY count DESC;


-- Oppgave 2

SELECT country 
FROM filmcountry 
GROUP BY country 
HAVING COUNT(*) = 1;


-- Oppgave 3

SELECT title, parttype, COUNT(parttype) 
FROM film 
JOIN filmparticipation USING (filmid) 
JOIN filmitem USING (filmid) 
WHERE filmtype = 'C' AND title LIKE '%Lord of the Rings%' 
GROUP BY title, parttype;

-- Oppgave 4

(
	SELECT film.filmid, title, prodyear 
	FROM filmgenre 
	JOIN film USING (filmid) 
	WHERE genre = 'Comedy'
) 
INTERSECT 
(
	SELECT film.filmid, title, prodyear 
	FROM filmgenre 
	JOIN film USING (filmid) 
	WHERE genre = 'Film-Noir'
);

-- Oppgave 5

SELECT maintitle 
FROM series 
JOIN filmrating ON series.seriesid = filmrating.filmid 
WHERE votes > 1000 
ORDER BY rank DESC, votes DESC 
LIMIT 3;

-- Oppgave 6

WITH movies AS (
	SELECT filmid, title 
	FROM film 
	JOIN filmparticipation USING (filmid) 
	JOIN filmcharacter USING (partid) 
	WHERE filmcharacter = 'Mr. Bean'
) 
SELECT filmid, title, COUNT(language) 
FROM movies 
LEFT OUTER JOIN filmlanguage USING (filmid) 
GROUP BY filmid, title;

-- Opgave 7

-- Denne versjonen viser navn på vestlig vis. Jeg er derimot veldig mot denne visningen på grunn av dette:
-- https://www.kalzumeus.com/2010/06/17/falsehoods-programmers-believe-about-names/
-- I dette tilfellet derimot så går jeg for denne framfor egne kolonner for fornavn og etternavn.

WITH characters AS (
	SELECT whole.partid, names.filmcharacter 
	FROM (
		SELECT filmcharacter, COUNT(filmcharacter) 
		FROM filmcharacter 
		GROUP BY filmcharacter 
		HAVING COUNT(filmcharacter) = 1
	) AS names, filmcharacter AS whole 
	WHERE names.filmcharacter = whole.filmcharacter
) 
SELECT CONCAT(firstname, ' ', lastname) as full_name, COUNT(*) 
FROM characters 
JOIN filmparticipation USING (partid) 
JOIN person USING (personid) 
GROUP BY full_name 
HAVING COUNT(*) > 199;