# Contest leaderboard
# https://www.hackerrank.com/challenges/contest-leaderboard/problem

select t.hacker_id, h.name, sum(t.max_score) as sum_score
from(
    select s.hacker_id, s.challenge_id cid, max(s.score) as max_score
    from submissions s
    group by s.hacker_id, s.challenge_id) t
join hackers h on t.hacker_id = h.hacker_id
group by t.hacker_id, h.name
having sum_score > 0
order by sum_score desc, t.hacker_id