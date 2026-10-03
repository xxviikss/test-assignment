create database final_questions;
create table audiences(
	date date,
    user_id text,
    view_adverts int
);

load data infile "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\audiences.csv"
into table audiences
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

#mau за ноябрь
SELECT COUNT(DISTINCT user_id) AS mau
FROM audiences
WHERE date >= '2023-11-01' AND date < '2023-12-01';

#dau
SELECT AVG(dau) AS avg_dau
FROM (
    SELECT date, COUNT(DISTINCT user_id) AS dau
    FROM audiences
    GROUP BY date
) as t;

#retention пришедшие 1 ноября
SELECT COUNT(DISTINCT b.user_id) * 1.0 / COUNT(DISTINCT a.user_id) AS retention
FROM (
	SELECT DISTINCT user_id 
    FROM audiences
    WHERE date = '2023-11-01'
) a
LEFT JOIN (
	SELECT DISTINCT user_id 
    FROM audiences 
    WHERE date = '2023-11-02'
) b
ON a.user_id = b.user_id;

#пользовательская конверсия
SELECT
    COUNT(DISTINCT CASE WHEN view_adverts > 0 THEN user_id END) * 100.0 / COUNT(DISTINCT user_id) AS conversion
FROM audiences
WHERE date >= '2023-11-01' AND date < '2023-12-01';

#
SELECT SUM(view_adverts) * 1.0 / COUNT(DISTINCT user_id) AS avg_views_per_user
FROM audiences
WHERE date >= '2023-11-01' AND date < '2023-12-01';