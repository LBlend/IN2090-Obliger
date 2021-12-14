-- Oppgave 2

-- a
SELECT * 
FROM timelistelinje 
WHERE timelistelinje.timelistenr = 3;

-- b
SELECT count(*) 
FROM timeliste;

-- c
SELECT count(*) 
FROM timeliste 
WHERE timeliste.status != 'utbetalt';

-- d
SELECT count(*), count(CASE WHEN timelistelinje.pause IS NOT NULL THEN 1 END) 
FROM timelistelinje;

-- e
SELECT * 
FROM timelistelinje 
WHERE timelistelinje.pause IS NULL;



-- Oppgave 3

-- a
SELECT sum(varighet)
FROM timeliste 
JOIN varighet ON timeliste.timelistenr = varighet.timelistenr 
WHERE timeliste.status != 'utbetalt';

-- b
SELECT DISTINCT timelistenr,
                beskrivelse
FROM   timeliste
WHERE  beskrivelse LIKE '%test%'
        OR beskrivelse LIKE '%Test%';

-- c
SELECT sum(varighet.varighet) / 60 * 200 
FROM timeliste 
JOIN varighet ON timeliste.timelistenr = varighet.timelistenr 
WHERE timeliste.status = 'utbetalt';



-- Oppgave 4

-- a
/*
En natural join vil gi tilbake alle rader der alle verdiene i alle attributtene er like.
I en inner join derimot vil man sjekke mot en spesifikk attributt.
*/

-- b
/*
Her er eneste felles attributten timelistenr. Dermed vil det ikke ha noe å si om du gjør en natural join eller en inner join på timelistenr.
*/