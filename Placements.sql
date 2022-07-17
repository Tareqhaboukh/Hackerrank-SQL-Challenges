# Placements
# https://www.hackerrank.com/challenges/placements/problem

select s.name
from students s
join packages p on s.id = p.id
join (
        select f.id, f.friend_id, p.salary
        from friends f
        join packages p on f.friend_id = p.id) temp on s.id = temp.id
where temp.salary > p.salary
order by temp.salary