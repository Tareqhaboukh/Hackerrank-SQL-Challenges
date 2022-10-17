# Hackerrank SQL Challenges & Solutions

### 1. Challenges
[Problem](https://www.hackerrank.com/challenges/challenges/problem)

Solution:


```sql
SELECT c.hacker_id
    , h.name
    , count(c.hacker_id) AS ch_count
FROM hackers h
INNER JOIN challenges c
    ON h.hacker_id = c.hacker_id
GROUP BY h.hacker_id
    , h.name
HAVING ch_count = (
        SELECT max(temp1.cnt)
        FROM (
            SELECT count(hacker_id) AS cnt
            FROM challenges
            GROUP BY hacker_id
            ) temp1
        )
    OR ch_count IN (
        SELECT t.cnt
        FROM (
            SELECT count(*) AS cnt
            FROM challenges
            GROUP BY hacker_id
            ) t
        GROUP BY t.cnt
        HAVING count(t.cnt) = 1
        )
ORDER BY ch_count DESC
    , h.hacker_id
```

### 2. Contest leaderboard
[Problem](https://www.hackerrank.com/challenges/contest-leaderboard/problem)

Solution:


```sql
SELECT t.hacker_id
    , h.name
    , sum(t.max_score) AS sum_score
FROM (
    SELECT s.hacker_id
        , s.challenge_id cid
        , max(s.score) AS max_score
    FROM submissions s
    GROUP BY s.hacker_id
        , s.challenge_id
    ) t
JOIN hackers h
    ON t.hacker_id = h.hacker_id
GROUP BY t.hacker_id
    , h.name
HAVING sum_score > 0
ORDER BY sum_score DESC
    , t.hacker_id
```

### 3. New Companies
[Problem](https://www.hackerrank.com/challenges/the-company/problem)

Solution:


```sql
SELECT c.company_code
    , c.founder
    , count(DISTINCT (lm.lead_manager_code))
    , count(DISTINCT (sm.senior_manager_code))
    , count(DISTINCT (m.manager_code))
    , count(DISTINCT (e.employee_code))
FROM Company c
    , Lead_Manager lm
    , Senior_Manager sm
    , Manager m
    , Employee e
WHERE c.company_code = lm.company_code
    AND lm.lead_manager_code = sm.lead_manager_code
    AND sm.senior_manager_code = m.senior_manager_code
    AND m.manager_code = e.manager_code
GROUP BY c.company_code
    , c.founder
ORDER BY c.company_code ASC;
```

### 4. Occupations
[Problem](https://www.hackerrank.com/challenges/occupations/problem)

Solution:


```sql
SET @r1 = 0
    , @r2 = 0
    , @r3 = 0
    , @r4 = 0;

SELECT min(Doctor)
    , min(Professor)
    , min(Singer)
    , min(Actor)
FROM (
    SELECT CASE 
            WHEN occupation = 'Doctor'
                THEN (@r1: = @r1 + 1)
            WHEN occupation = 'Professor'
                THEN (@r2: = @r2 + 1)
            WHEN occupation = 'Singer'
                THEN (@r3: = @r3 + 1)
            WHEN occupation = 'Actor'
                THEN (@r4: = @r4 + 1)
            END AS RowNumber
        , CASE 
            WHEN occupation = 'Doctor'
                THEN name
            END AS Doctor
        , CASE 
            WHEN occupation = 'Professor'
                THEN name
            END Professor
        , CASE 
            WHEN occupation = 'Singer'
                THEN name
            END AS Singer
        , CASE 
            WHEN occupation = 'Actor'
                THEN name
            END AS Actor
    FROM occupations
    ORDER BY name
    ) AS TEMP
GROUP BY RowNumber;
```

### 5. Placements
[Problem](https://www.hackerrank.com/challenges/placements/problem)


Solution:


```sql
SELECT s.name
FROM students s
JOIN packages p
    ON s.id = p.id
JOIN (
    SELECT f.id
        , f.friend_id
        , p.salary
    FROM friends f
    JOIN packages p
        ON f.friend_id = p.id
    ) TEMP
    ON s.id = TEMP.id
WHERE TEMP.salary > p.salary
ORDER BY TEMP.salary
```

### 6. Top Competitors
[Problem](https://www.hackerrank.com/challenges/full-score/problem)

Solution:


```sql
SELECT temp2.id2
    , temp2.n2
FROM (
    SELECT TEMP.id AS id2
        , TEMP.n AS n2
        , count(*) AS a
    FROM (
        SELECT h.hacker_id AS id
            , h.name AS n
            , d.score AS ds
            , s.score AS ss
        FROM hackers h
        JOIN submissions s
            ON h.hacker_id = s.hacker_id
        JOIN challenges c
            ON c.challenge_id = s.challenge_id
        JOIN difficulty d
            ON c.difficulty_level = d.difficulty_level
        HAVING ds - ss = 0
        ) TEMP
    GROUP BY 1
        , 2
    ORDER BY count(*) DESC
        , TEMP.id ASC
    ) temp2
WHERE temp2.a > 1
```
