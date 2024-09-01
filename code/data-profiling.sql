/*
Q: how long is too long to wait? -- when we get complaints, how long were the complainers waiting.
*/
WITH t1 AS (
	SELECT
		MIN(m.matched_at - s.created_at) AS min_wait_time
  	, MAX(m.matched_at - s.created_at) AS max_wait_time
  	, AVG(m.matched_at - s.created_at) AS avg_wait_time
	FROM support_tickets AS s
	LEFT JOIN matches AS m
	ON s.ticket_id = m.ticket_id
	)

SELECT * FROM t1
;
/*
| min_wait_time | max_wait_time | avg_wait_time |
| ------------- | ------------- | ------------- |
| 00:00:00      | 03:12:28      | 00:07:14.702  |
*/

------------------------

/*
Q: how many users are waiting too long?

Wait_time
75th percentile: 8.65 minutes
80th percentile: 10.02 minutes
85th percentile: 12.43 minutes
90th percentile: 16.17 minutes
95th percentile: 23.35 minutes
*/

WITH t1 AS (
	SELECT
		*
		, (m.matched_at - s.created_at) AS wait_time
    , CASE WHEN EXTRACT(EPOCH FROM (m.matched_at - s.created_at)) / 60 > 8.65 THEN 1 ELSE 0 END AS wait_time_exceeded_75th
    , CASE WHEN EXTRACT(EPOCH FROM (m.matched_at - s.created_at)) / 60 > 10.02 THEN 1 ELSE 0 END AS wait_time_exceeded_80th
    , CASE WHEN EXTRACT(EPOCH FROM (m.matched_at - s.created_at)) / 60 > 12.43 THEN 1 ELSE 0 END AS wait_time_exceeded_85th
    , CASE WHEN EXTRACT(EPOCH FROM (m.matched_at - s.created_at)) / 60 > 16.17 THEN 1 ELSE 0 END AS wait_time_exceeded_90th
    , CASE WHEN EXTRACT(EPOCH FROM (m.matched_at - s.created_at)) / 60 > 23.35 THEN 1 ELSE 0 END AS wait_time_exceeded_95th
	FROM support_tickets AS s
	LEFT JOIN matches AS m
	ON s.ticket_id = m.ticket_id
	)

SELECT
	SUM(wait_time_exceeded_75th) AS wt_exceeded_75th
  , SUM(wait_time_exceeded_80th) AS wt_exceeded_80th
  , SUM(wait_time_exceeded_85th) AS wt_exceeded_85th
  , SUM(wait_time_exceeded_90th) AS wt_exceeded_90th
  , SUM(wait_time_exceeded_95th) AS wt_exceeded_95th
FROM t1
;
/*
Answer:
| wt_exceeded_75th | wt_exceeded_80th | wt_exceeded_85th | wt_exceeded_90th | wt_exceeded_95th |
| ---------------- | ---------------- | ---------------- | ---------------- | ---------------- |
| 1248             | 999              | 751              | 499              | 250              |                   |
*/

-------------------------------

/*
Q: how is the problem of "waiting too long" distributed across users from different sized companies?
*/
WITH t1 AS (
    SELECT
        s.ticket_id,
        c.company_size,
        (m.matched_at - s.created_at) AS wait_time,
        CASE
            WHEN EXTRACT(EPOCH FROM (m.matched_at - s.created_at)) / 60 > 23.35
            THEN 1
            ELSE 0
        END AS wait_time_exceeded
    FROM support_tickets AS s
    LEFT JOIN matches AS m
    ON s.ticket_id = m.ticket_id
    LEFT JOIN companies AS c
    ON s.company_id = c.company_id
)
SELECT
    t1.company_size,
    COUNT(t1.ticket_id) AS total_tickets,
    SUM(t1.wait_time_exceeded) AS total_wait_time_exceeded,
    ROUND(SUM(t1.wait_time_exceeded)::numeric / COUNT(t1.ticket_id) * 100, 2) AS percentage_wait_time_exceeded
FROM t1
GROUP BY t1.company_size
ORDER BY t1.company_size DESC
;
/*
Answer:
| company_size | total_tickets | total_wait_time_exceeded | percentage_wait_time_exceeded |
| ------------ | ------------- | ------------------------ | ----------------------------- |
| 47           | 528           | 24                       | 4.55                          |
| 35           | 426           | 20                       | 4.69                          |
| 33           | 499           | 32                       | 6.41                          |
| 31           | 235           | 9                        | 3.83                          |
| 21           | 206           | 11                       | 5.34                          |
| 16           | 291           | 14                       | 4.81                          |
| 15           | 204           | 12                       | 5.88                          |
| 14           | 103           | 4                        | 3.88                          |
| 12           | 371           | 16                       | 4.31                          |
| 10           | 164           | 9                        | 5.49                          |
| 9            | 110           | 5                        | 4.55                          |
| 8            | 465           | 21                       | 4.52                          |
| 7            | 271           | 14                       | 5.17                          |
| 6            | 181           | 11                       | 6.08                          |
| 5            | 274           | 15                       | 5.47                          |
| 4            | 284           | 15                       | 5.28                          |
| 3            | 10            | 1                        | 10.00                         |
| 2            | 69            | 2                        | 2.90                          |
| 1            | 309           | 15                       | 4.85                          |
*/

--------------------------------