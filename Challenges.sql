# Challenges
# https://www.hackerrank.com/challenges/challenges/problem

select c.hacker_id, h.name, count(c.hacker_id) as ch_count
from hackers h
    inner join challenges c on h.hacker_id = c.hacker_id
group by h.hacker_id, h.name
having 

ch_count = (select max(temp1.cnt)
            from (  select count(hacker_id) as cnt
                    from challenges
                    group by hacker_id) temp1)
or
ch_count in (select t.cnt
            from (  select count(*) as cnt 
                    from challenges
                    group by hacker_id) t
            group by t.cnt
            having count(t.cnt) = 1)
            
order by ch_count desc, h.hacker_id