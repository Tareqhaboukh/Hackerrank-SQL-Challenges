# Occupations
# https://www.hackerrank.com/challenges/occupations/problem

set @r1=0, @r2=0, @r3=0, @r4=0;

select min(Doctor), min(Professor), min(Singer), min(Actor)
from(
    select
        case
         when occupation='Doctor' then (@r1:=@r1+1)
         when occupation='Professor' then (@r2:=@r2+1)
         when occupation='Singer' then (@r3:=@r3+1)
         when occupation='Actor' then (@r4:=@r4+1) end as RowNumber,
        case when occupation='Doctor' then name end as Doctor,
        case when occupation='Professor' then name end Professor,
        case when occupation='Singer' then name end as Singer,
        case when occupation='Actor' then name end as Actor
    from occupations
    order by name
        ) as temp
    group by RowNumber;