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
WHERE winner = 'PETER GRÜNBERG'

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
  


