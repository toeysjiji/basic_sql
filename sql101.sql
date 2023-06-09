--CREATE
CREATE TABLE customer (
	id int,
	name text,
	city text,
	email text,
	avg_spending real
);

--INSERT INTO
INSERT INTO customer VALUES 
(1, "toy", "BKK", "toy@mail.com", 500.25),
(2, "joe", "BKK", "joe@mail.com", 125.50),
(3, "ann", "LON", "ann@mail.com", 999.55),
(4, "ken", "LON", "mae@mail.com", 658.20);

--DROP TABLE
DROP TABLE customer;

--SELECT ex. 1
SELECT
firstname AS fname,
lastname AS lname,
firstname || " " || lastname AS Fullname,
country,
email
FROM customers;

--SELECT ex. 2
SELECT
	name,
	ROUND(milliseconds/60000.0, 2) AS minutes,
	ROUND(bytes/(1024*1024.0), 4) AS MBs,
FROM tracks;

--WHERE ex. 1
SELECT
firstname,
lastname,
country,
email
FROM customers
WHERE country = 'USA';

--WHERE ex. 2
SELECT * FROM customers
WHERE LOWER(country) IN ('usa', 'brazil', 'belgium');

--WHERE ex. 3
SELECT * FROM customers
WHERE country = 'USA' OR country = 'Brazil' OR country = 'Belgium' AND firstname = 'Tim';

--WHERE ex. 4
SELECT * FROM customers
WHERE country LIKE '%M' OR country LIKE '%U'; 
--Tips: LIKE is case insensitive

--WHERE ex. 5
SELECT * FROM customers
WHERE company IS NULL;

--WHERE ex. 6
SELECT * FROM customers
WHERE company IS NOT NULL;

--STRFTIME ex. 1
SELECT
	invoicedate,
	STRFTIME("%Y", invoicedate) AS year,
	STRFTIME("%m", invoicedate) AS month,
	STRFTIME("%d", invoicedate) AS day,
	billingaddress
FROM invoices
WHERE year = "2009" AND month = "09" AND day = "15";


--STRFTIME ex. 2 with CAST
SELECT
	invoicedate,
	CAST(STRFTIME("%Y", invoicedate) AS int) AS year,
	CAST(STRFTIME("%m", invoicedate) AS int) AS month,
	CAST(STRFTIME("%d", invoicedate) AS int) AS day,
	billingaddress
FROM invoices
WHERE year = 2009 AND month = 09 AND day = 15;

--STRFTIME ex. 3 
SELECT
	invoicedate,
	STRFTIME("%Y-%m", invoicedate) AS monthid,
	billingaddress
FROM invoices
WHERE monthid = "2009-05" 

--CAST(change type)
SELECT CAST("100" AS int) * 2

--CAST(change type)
SELECT
	invoicedate,
	CAST(STRFTIME("%Y", invoicedate) AS int) AS year,
	CAST(STRFTIME("%m", invoicedate) AS int) AS month,
	CAST(STRFTIME("%d", invoicedate) AS int) AS day,
	billingaddress
FROM invoices
WHERE year = 2009 AND month = 09 AND day = 15;

--Aggregate ex. 1
SELECT 
ROUND(AVG(total), 2) AS avg_total,
SUM(total) AS sum_total,
MIN(total) AS min_total,
MAX(total) AS max_total,
COUNT(total) AS n_total
FROM invoices;

--Aggregate ex. 2
SELECT
	COUNT(*) AS total_n,
	COUNT(company) AS B2B,
	COUNT(*) - COUNT(company) AS B2C
FROM customers;

--Aggregate + Group by + Having
SELECT 
country,
state,
COUNT(*) AS n
FROM customers
WHERE country <> 'Brazil'
GROUP BY country, state
HAVING n >= 5 AND (country LIKE "B%" OR country LIKE "C%");
--Tips: columns in group by should be presented in SELECT too

--Order by ex. 1
SELECT * 
FROM customers
ORDER BY country DESC;

--Order by + Limit ex. 2
SELECT 
country,
state,
COUNT(*) AS n
FROM customers
WHERE country <> 'Brazil'
GROUP BY country, state
HAVING n >= 5
ORDER BY n DESC
LIMIT 2;

--COALESCE ex
SELECT
	firstname,
	company,
	COALESCE(company, "No information") AS clean_company
FROM customer;

--CASE WHEN ex. 1
SELECT
	firstname,
	company,
	COALESCE(company, "No information") AS clean_company,
	CASE
		WHEN company IS NULL THEN 'B2C'
		WHEN company IS NOT NULL THEN 'B2B'
	END AS segment
FROM customer;

--CASE WHEN ex. 2
SELECT
	firstname,
	company,
	COALESCE(company, "No information") AS clean_company,
	CASE
		WHEN company IS NULL THEN 'B2C'
		ELSE 'B2B'
	END AS segment
FROM customer;

--Join Syntax
SELECT * FROM table1
JOIN table2
ON table1.pk = table2.fk;

-- pk = primary key, fk = foreign key

--JOIN ex. 1
SELECT * FROM customer
JOIN segment
ON customer.id = segment.cust_id;

/*
FOUR JOIN TYPES
1. INNER JOIN
2. OUTER JOIN
3. LEFT JOIN
4. RIGHT JOIN
*/

--JOIN ex. 2
SELECT 
	ar.name,
	al.title
FROM artists AS ar
JOIN albums AS al
ON ar.artistsid = al.artists.id;

--JOIN ex. 3
SELECT
	ar.artistid, 
	ar.name,
	al.title,
	tr.name AS track_name,
	tr.composer,
	tr.bytes / (1024*1024) AS mb
FROM artists AS ar
JOIN albums AS al
	ON ar.artistsid = al.artists.id
JOIN tracks AS tr
	ON al.albumid = tr.albumid;

--JOIN ex. 4
SELECT
	ar.artistid, 
	ar.name,
	al.title,
	ge.name AS genre_name
	tr.name AS track_name,
	tr.composer,
	tr.bytes / (1024*1024) AS mb
FROM artists AS ar
JOIN albums AS al
	ON ar.artistsid = al.artists.id
JOIN tracks AS tr
	ON al.albumid = tr.albumid
JOIN genres AS ge
	ON tr.genreid = ge.genreid;

--CREATE VIEW ex
--Virtual Table (view)
CREATE VIEW IF NOT EXISTS songs_view AS
		SELECT
			ar.artistid, 
			ar.name AS artist_name,
			al.title,
			ge.name AS genre_name
			tr.name AS track_name,
			tr.composer,
			tr.bytes / (1024*1024) AS mb
		FROM artists AS ar
		JOIN albums AS al
			ON ar.artistsid = al.artists.id
		JOIN tracks AS tr
			ON al.albumid = tr.albumid
		JOIN genres AS ge
			ON tr.genreid = ge.genreid;


--subquery
SELECT * FROM (
	SELECT firstname, country FROM(
		SELECT * FROM customers
	)
)
WHERE country = 'USA';

--subquery ex. 1
SELECT email FROM (
	SELECT * FROM customers
	WHERE country = 'USA'
) AS usa_customers
WHERE email LIKE '%gmail.com';

--subquery ex. 2
SELECT 
	sub1.firstname, 
	sub2.total
FROM (SELECT * FROM customers
			WHERE country = 'USA') AS sub1
JOIN (SELECT * FROM invoices
			WHERE STRFTIME("%Y", invoicedate) = "2009") AS sub2
ON sub1.customerid = sub2.customerid;

--subquery ex. 3
--common table expression => WITH
WITH sub1 AS (
	SELECT * FROM customers
	WHERE country = 'USA'
), sub2 AS (
	SELECT * FROM invoices
	WHERE STRFTIME("%Y", invoicedate) = "2009"
)
SELECT
	sub1.firstname,
	sub2.total
FROM sub1
JOIN sub2
ON sub1.customerid = sub2.customerid;

/* temp subquery
WITH sub1 AS (), sub2 AS ()
SELECT * FROM sub1 JOIN sub2 ON sub1.pk = sub2.fk
*/