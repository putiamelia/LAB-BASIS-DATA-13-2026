SET SEARCH_PATH TO classicmodels;

--NOMOR 1
SELECT customernumber, SUM(amount) AS "Total Setoran", COUNT(checknumber) AS "Frekuensi Setoran", MAX(amount) AS "Setoran Terbesar"
FROM payments
GROUP BY customernumber
HAVING COUNT(checknumber) > 4 AND AVG(amount) > 20000;

--NOMOR 2
SELECT customernumber, SUM(amount) AS "Total Setoran"
FROM payments
GROUP BY customernumber
HAVING SUM(amount) > 80000
ORDER BY "Total Setoran" DESC;

--NOMOR 3
SELECT productline, COUNT(DISTINCT productcode) AS "Jumlah Ragam Produk", ROUND(AVG(MSRP), 2) AS "Rata-Rata MSRP", STRING_AGG(productname, ', ') AS "Nama Produk"
FROM products
GROUP BY productline
HAVING COUNT(DISTINCT productcode) > 10;

--NOMOR 4
SELECT reportsTo AS employeenumber 
FROM employees
WHERE reportsTo IS NOT NULL
EXCEPT
SELECT reportsTo
FROM employees
WHERE jobtitle ILIKE '%VP%' OR jobtitle ILIKE '%President%';

--NOMOR 5
SELECT productcode, SUM(quantityordered) AS "Total Unit Terjual", ROUND(AVG(priceeach), 2) AS "Rata-Rata Harga Jual"
FROM orderdetails
WHERE priceeach > 100
GROUP BY productcode
HAVING SUM(quantityordered) > 50
ORDER BY "Total Unit Terjual" DESC;

--NOMOR 6
SELECT productcode, SUM(quantityordered) AS "Total Unit", SUM(quantityordered * priceeach) AS "Pendapatan Kotor", ROUND(AVG(priceeach), 2) AS "Rata-Rata Harga", MAX(priceeach) - MIN(priceeach) AS "Rentang Harga"
FROM orderdetails
WHERE quantityordered > 20
GROUP BY productcode
HAVING SUM(quantityordered * priceeach) > 50000
ORDER BY "Pendapatan Kotor" DESC;

--NOMOR 7
(
	SELECT customernumber
	FROM customers
	WHERE creditlimit > 80000
	INTERSECT
	SELECT customernumber
	FROM orders
	WHERE status ILIKE '%Cancelled%' OR status ILIKE '%On Hold%'
)
EXCEPT 
SELECT customernumber
FROM payments
GROUP BY customernumber
HAVING SUM(amount) > 100000;