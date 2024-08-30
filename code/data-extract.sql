-- Customer support queue data available in SQL databse

-- Data extraction script

WITH t1 AS (
	SELECT
		*
		, (m.matched_at - s.created_at) AS wait_time
    , CASE WHEN EXTRACT(EPOCH FROM (m.matched_at - s.created_at)) / 60 > 30 THEN 1 ELSE 0 END AS wait_time_exceeded
	FROM support_tickets AS s
	LEFT JOIN matches AS m
    ON s.ticket_id = m.ticket_id
    LEFT JOIN companies AS c
    ON s.company_id = c.company_id
	)

SELECT * FROM t1
;