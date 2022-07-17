# Top Competitors
# https://www.hackerrank.com/challenges/full-score/problem

select temp2.id2, temp2.n2
from(
    select temp.id as id2, temp.n as n2, count(*) as a
    from(
        select h.hacker_id as id, h.name as n, d.score as ds, s.score as ss
        from hackers h
            join submissions s on h.hacker_id = s.hacker_id
            join challenges c on c.challenge_id = s.challenge_id
            join difficulty d on c.difficulty_level = d.difficulty_level
        having ds - ss = 0) temp
    group by 1,2
    order by count(*) desc, temp.id asc) temp2
where temp2.a > 1