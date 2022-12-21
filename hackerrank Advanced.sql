-- Weekend Hours
WITH CTE_1
AS (
    SELECT [timestamp]
        , emp_id
        , DATEPART(HOUR, [timestamp]) AS hour
        , DATEPART(HOUR, LAG([timestamp]) OVER (PARTITION BY CAST(TIMESTAMP AS DATE), emp_id ORDER BY TIMESTAMP)) AS lag_hour
        , CASE 
            WHEN datepart(minute, TIMESTAMP) >= datepart(minute, lag(TIMESTAMP) OVER (PARTITION BY CAST(TIMESTAMP AS DATE), emp_id ORDER BY TIMESTAMP))
                THEN datepart(hour, TIMESTAMP) - datepart(hour, lag(TIMESTAMP) OVER (PARTITION BY CAST(TIMESTAMP AS DATE), emp_id ORDER BY TIMESTAMP))
            ELSE datepart(hour, TIMESTAMP) - datepart(hour, lag(TIMESTAMP) OVER (PARTITION BY CAST(TIMESTAMP AS DATE), emp_id ORDER BY TIMESTAMP)) - 1
        END AS hours_worked
    FROM attendance
    WHERE DATENAME(WEEKDAY, [timestamp]) IN ('Saturday', 'Sunday')
    )
SELECT emp_id
    , SUM(hours_worked) AS hours_worked
FROM CTE_1
GROUP BY emp_id
ORDER BY hours_worked DESC;

-- Weather Analysis
SELECT
    DATEPART(MONTH,record_date) AS month,
    MAX(CASE WHEN data_type = 'max' THEN data_value ELSE NULL END) AS max_value,
    MIN(CASE WHEN data_type = 'min' THEN data_value ELSE NULL END) AS min_value,
    ROUND(AVG(CASE WHEN data_type = 'avg' THEN CAST(data_value AS FLOAt) ELSE NULL END),0) AS avg_value
FROM temperature_records
GROUP BY DATEPART(MONTH,record_date);

-- Crypto Market Analysis

WITH difference AS (
SELECT *
    , DATEDIFF(minute,lag(dt) OVER (ORDER BY sender,dt),dt) AS difF_minute
    , ROW_NUMBER() OVER(ORDER BY sender,dt) AS rownumber
FROM krypto
),

rn AS (
SELECT rownumber
FROM difference
WHERE rownumber IN(
    SELECT rownumber
    FROM   krypto
    WHERE  abs(diff_minute) < 60)
),
sequences AS (
    SELECT *
    FROM    difference
    WHERE rownumber IN(
        SELECT rownumber
        FROM rn
    UNION
    SELECT rownumber - 1 AS rownumber
    FROM   rn)
)
SELECT 
       sender,
       MIN(dt) AS Sequence_start,
       MAX(dt) AS Sequence_end,
       COUNT(rownumber) AS transactions_count,
       SUM(amount) AS transactions_sum
FROM   sequences
GROUP BY sender
HAVING SUM(amount) >= 150
order by sender,MIN(dt),MAX(dt)