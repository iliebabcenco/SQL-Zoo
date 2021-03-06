-- SELECT basics
SELECT population FROM world
WHERE name = 'Germany';

SELECT name, population FROM world
WHERE name IN ('Sweden', 'Norway', 'Denmark');

SELECT name, area FROM world
WHERE area BETWEEN 200000 AND 250000;

--SELECT from WORLD Tutorial

SELECT name, continent, population 
FROM world;

SELECT name
FROM world
WHERE population >= 200000000;

SELECT name, gdp/population
FROM world
WHERE population >= 200000000

SELECT name, population/1000000 
FROM world
WHERE continent = 'South America'

SELECT name, population 
FROM world 
WHERE name in ('France', 'Germany', 'Italy');

SELECT name 
FROM world 
WHERE name LIKE ('%United%')

SELECT name, population, area 
FROM world 
WHERE area > 3000000 OR population > 250000000;

SELECT name, population, area 
FROM world 
WHERE(area > 3000000 AND population < 250000000)
    OR (area < 3000000 AND population > 250000000)

SELECT name, ROUND(gdp/population,-3) FROM world WHERE gdp >= 1000000000000

SELECT name, capital
FROM world
WHERE LEN(name) = LEN(capital)

SELECT name, capital
FROM world 
WHERE LEFT(name,1) = LEFT(capital,1) AND name != capital

SELECT name
FROM world
WHERE name LIKE '%a%' 
AND name LIKE '%e%' 
AND name LIKE '%i%' 
AND name LIKE '%o%' 
AND name LIKE '%u%'
AND name NOT LIKE '% %'

--SELECT from Nobel Tutorial

SELECT yr, subject, winner
FROM nobel
WHERE yr = 1950

SELECT winner
FROM nobel
WHERE yr = 1962
AND subject = 'Literature'

SELECT yr, subject 
FROM nobel 
WHERE winner = 'Albert Einstein'

SELECT winner 
FROM nobel 
WHERE subject = 'Peace' AND yr >= 2000

SELECT * FROM nobel 
WHERE subject = 'Literature' 
AND yr BETWEEN 1980 AND 1989

SELECT * FROM nobel
WHERE winner IN ('Theodore Roosevelt',
                  'Woodrow Wilson',
                  'Jimmy Carter', 'Barack Obama')

SELECT winner FROM nobel 
WHERE winner LIKE ('John%')

SELECT * FROM nobel 
WHERE (subject = 'Physics' AND yr = 1980) 
OR (subject = 'Chemistry' AND yr = 1984)

SELECT * FROM nobel 
WHERE yr = 1980 
AND subject NOT IN ('Chemistry', 'Medicine')

SELECT * FROM nobel 
WHERE subject = 'Medicine' 
AND yr < 1910 OR subject = 'Literature'
AND yr >= 2004

SELECT * FROM nobel 
WHERE winner = 'PETER GR??NBERG'

SELECT * FROM nobel 
WHERE winner = 'EUGENE O''NEILL'

SELECT winner, yr, subject FROM nobel 
WHERE winner LIKE ('Sir%') ORDER BY yr DESC, subject

SELECT winner, subject
FROM nobel
WHERE yr = 1984
ORDER BY subject IN ('Physics', 'Chemistry'), subject, winner

--SELECT within SELECT Tutorial

SELECT name FROM world
WHERE population >
(SELECT population FROM world
WHERE name='Russia')

SELECT name FROM world 
WHERE (gdp / population) > (SELECT gdp / population FROM world WHERE name = 'United Kingdom') 
AND continent = 'Europe'

SELECT name, continent FROM world 
WHERE continent = (SELECT continent FROM world WHERE name = 'Argentina') 
OR continent = (SELECT continent FROM world WHERE name = 'Australia') ORDER BY name

SELECT name, population FROM world 
WHERE population > (SELECT population FROM world WHERE name = 'Canada') 
AND population < (SELECT population FROM world WHERE name = 'Poland')

SELECT name, CONCAT(CAST(ROUND((population/(SELECT population from world where name = 'Germany'))*100,0) AS DECIMAL(3,0)),'%')
AS percentage FROM world WHERE continent = 'Europe'

SELECT name FROM world WHERE gdp > (SELECT MAX(gdp) FROM world WHERE continent = 'Europe')

SELECT continent, name, area FROM world x
WHERE area >= ALL
(SELECT area FROM world y
WHERE y.continent=x.continent
AND area>0)

SELECT continent, name FROM world x
WHERE name <= ALL
(SELECT name FROM world y
WHERE y.continent=x.continent)

SELECT name, continent, population FROM world x
  WHERE 25000000>=ALL (SELECT population FROM world y
                         WHERE x.continent=y.continent
                         AND population>0)

SELECT name, continent FROM world x
WHERE population >= ALL (SELECT population*3 FROM world y WHERE x.continent = y.continent AND x.name != y.name)

-- SUM and COUNT

SELECT SUM(population)
FROM world

SELECT DISTINCT continent FROM world

SELECT SUM(gdp) FROM world WHERE continent = 'Africa'

SELECT COUNT(name) FROM world WHERE area >= 1000000

SELECT SUM(population) FROM world WHERE name in ('Estonia', 'Latvia', 'Lithuania')

SELECT DISTINCT continent, COUNT(name) FROM world GROUP BY continent

SELECT DISTINCT continent, count(name) FROM world WHERE population > 10000000 GROUP BY continent

SELECT continent FROM world GROUP BY continent HAVING SUM(population) >= 100000000

--The JOIN operation

SELECT matchid, player FROM goal 
WHERE teamid = 'GER'

SELECT id,stadium,team1,team2
FROM game WHERE id= 1012

SELECT player, teamid, stadium, mdate
FROM game JOIN goal ON (id=matchid) WHERE teamid = 'GER'

SELECT team1, team2, goal.player FROM game JOIN goal on (id=matchid) WHERE player LIKE 'Mario%'

SELECT player, teamid, coach, gtime
FROM goal JOIN eteam ON teamid = id
WHERE gtime<=10

SELECT mdate, eteam.teamname FROM game JOIN eteam ON (team1=eteam.id) WHERE coach = 'Fernando Santos'

SELECT player FROM goal JOIN game on matchid = game.id WHERE stadium = 'National Stadium, Warsaw'

SELECT DISTINCT player
FROM game JOIN goal ON matchid = id 
WHERE teamid != 'GER' AND (team1 = 'GER' OR team2 = 'GER')

SELECT DISTINCT teamname, COUNT(goal.teamid)
FROM eteam JOIN goal ON id=teamid
GROUP BY teamname

SELECT DISTINCT stadium, COUNT(goal.teamid) FROM game JOIN goal ON id=matchid GROUP BY stadium

SELECT id, mdate, COUNT(goal.teamid) AS goals FROM game JOIN goal ON id = matchid  WHERE(team1 = 'POL' OR team2 = 'POL')
GROUP BY mdate, id

SELECT matchid, mdate, COUNT(goal.teamid) AS goal FROM game JOIN goal ON id = matchid 
WHERE goal.teamid = 'GER' GROUP BY matchid, mdate

SELECT mdate,
team1, 
SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1, 
team2,
SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) score2
FROM game LEFT JOIN goal ON matchid = id 
GROUP BY mdate, matchid, team1, team2
ORDER BY mdate, matchid, team1, team2
  
--More JOIN operations

SELECT id, title FROM movie WHERE yr=1962

SELECT yr FROM movie WHERE title = 'Citizen Kane'

SELECT id, title, yr FROM movie WHERE title LIKE 'Star Trek%' ORDER BY yr

SELECT id FROM actor WHERE name = 'Glenn Close'

SELECT id FROM movie WHERE title = 'Casablanca'

SELECT DISTINCT name FROM actor JOIN casting ON actorid = id WHERE movieid = 27

SELECT DISTINCT name FROM actor 
JOIN casting ON actorid = id
JOIN movie ON movieid = movie.id
WHERE movie.title = 'Alien'

SELECT DISTINCT title FROM movie
JOIN casting ON movieid = movie.id
JOIN actor ON actorid = actor.id
WHERE actor.name = 'Harrison Ford'

SELECT DISTINCT title FROM movie
JOIN casting ON movieid = movie.id
JOIN actor ON actorid = actor.id
WHERE actor.name = 'Harrison Ford' AND casting.ord != 1

SELECT title, actor.name FROM movie
JOIN casting ON movieid = movie.id
JOIN actor ON actorid = actor.id
WHERE casting.ord = 1 AND movie.yr = 1962

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 1

SELECT title, actor.name FROM movie
JOIN casting ON (casting.movieid = movie.id)
JOIN actor ON (casting.actorid = actor.id)
WHERE movie.id IN (
    SELECT movieid FROM casting
    WHERE actorid IN (
      SELECT id FROM actor
      WHERE name='Julie Andrews'))  AND casting.ord = 1

SELECT name AS 'starring roles' FROM actor 
JOIN casting ON actorid = actor.id
JOIN movie ON movieid = movie.id
WHERE ord = 1 GROUP BY name
HAVING COUNT(movie.title) >= 15

SELECT title, COUNT(name) FROM actor 
JOIN casting ON actorid = actor.id
JOIN movie ON movieid = movie.id
WHERE yr = 1978 GROUP BY title ORDER BY COUNT(name) DESC, title

SELECT name FROM actor
JOIN casting ON actorid = actor.id
JOIN movie ON movieid = movie.id
WHERE title IN (
SELECT title FROM movie
JOIN casting ON movieid = movie.id
JOIN actor ON actorid = actor.id
WHERE actor.name = 'Art Garfunkel' ) AND name != 'Art Garfunkel' ORDER BY name

-- Using Null

SELECT name FROM teacher WHERE dept IS NULL

SELECT teacher.name, dept.name
FROM teacher INNER JOIN dept
ON (teacher.dept=dept.id)

SELECT teacher.name, dept.name
FROM teacher LEFT JOIN dept
ON (teacher.dept=dept.id)

SELECT teacher.name, dept.name
FROM teacher RIGHT JOIN dept
ON (teacher.dept=dept.id)

SELECT name, COALESCE(mobile,'07986 444 2266') FROM teacher

SELECT teacher.name, COALESCE(dept.name, 'None') FROM teacher
LEFT JOIN dept ON dept.id = teacher.dept

SELECT COUNT(teacher.name) AS 'number of teachers', COUNT(teacher.mobile) AS 'number of mb phones' FROM teacher

SELECT dept.name, COUNT(teacher.id) AS 'number of staff' FROM teacher
RIGHT JOIN dept ON dept.id = teacher.dept GROUP BY dept.name

SELECT name, 
CASE WHEN dept = 1 THEN 'Sci'
     WHEN dept = 2 THEN 'Sci'
     ELSE 'Art' END
FROM teacher

SELECT name, 
CASE WHEN dept = 1 THEN 'Sci'
     WHEN dept = 2 THEN 'Sci'
     WHEN dept = 3 THEN 'Art'
     ELSE 'None' END
FROM teacher

--Self join

SELECT COUNT(*) FROM stops

SELECT id FROM stops WHERE name = 'Craiglockhart'

SELECT id, name FROM stops 
JOIN route ON stops.id = route.stop
WHERE num = '4' AND company = 'LRT'

SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(stop) = 2

SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b 
ON (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop = 149

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='London Road'

SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=115 AND b.stop = 137

SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
 JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='Tollcross'

SELECT DISTINCT bstop.name, a.company, a.num FROM
	route AS a JOIN route AS b ON (a.company = b.company AND a.num = b.num)
			   JOIN stops AS astop ON (a.stop = astop.id)
			   JOIN stops AS bstop ON (b.stop = bstop.id)
	WHERE astop.name = 'Craiglockhart'

SELECT DISTINCT one.num as FirstBus, one.company as FirstComp, one.name as Transfer, two.num as SecBus, two.company as SecComp
FROM (SELECT DISTINCT a.num, a.company, yy.name
     FROM route a join route b on (a.company=b.company and a.num=b.num) 
                  join stops xx on (xx.id=a.stop) 
                  join stops yy on (yy.id=b.stop)
     WHERE xx.name='Craiglockhart' and yy.name<>'Lochend'
     ) AS one JOIN
    (SELECT DISTINCT c.num, d.company, mm.name
     FROM route c join route d on (c.company=d.company and c.num=d.num) 
                  join stops mm on (mm.id=c.stop) 
                  join stops nn on (nn.id=d.stop)
     WHERE mm.name <> 'Craiglockhart' and nn.name='Lochend'
     ) AS two
ON (two.name=one.name)