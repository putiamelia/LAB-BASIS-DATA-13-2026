SET SEARCH_PATH TO classicmodels;

--nomor 1
SELECT c.contactfirstname,c.customername,o.city, 
firstname || ' ' || lastname AS "sales rep name"
FROM customers as c
JOIN employees AS e 
	ON c.salesrepemployeenumber = e.employeenumber
JOIN offices AS o
	ON e.officecode = o.officecode

WHERE c.contactfirstname ILIKE 'A%' AND e.jobtitle = 'Sales Rep' AND o.city != 'NYC' 
ORDER BY c.customername ;

--nomor 2
SELECT c.customername, 
SUM (p.amount) AS "total payment",
MAX (p.amount) AS "max single payment" 
FROM customers AS c
JOIN payments AS p
	ON c.customernumber = p.customernumber
GROUP BY c.customername
HAVING SUM(p.amount) > 50000
ORDER BY "total payment" DESC;

--nomor 3
SELECT c.customername,
COUNT (DISTINCT o.ordernumber) AS "total order",
ROUND(AVG(od.quantityordered),2) AS "avg quantity perorder"
FROM customers AS c
JOIN orders AS o
	ON c.customernumber = o.customernumber
JOIN orderdetails AS od
	ON o.ordernumber = od.ordernumber
GROUP BY c.customername
HAVING COUNT (DISTINCT o.ordernumber)>3 AND 
ROUND(AVG(od.quantityordered),2) > 35
ORDER BY "total order" DESC, "avg quantity perorder" DESC;

--nomor 4
SELECT pl.productline,
SUM (od.quantityordered) AS "total terjual",
ROUND(AVG(od.priceeach),2) AS "rata rata harga",
ROUND(AVG(((p.msrp - od.priceeach) / p.msrp) * 100),2) || ''|| '%' AS "avg discount percentage"
FROM productlines AS pl
JOIN products AS p
	ON pl.productline = p.productline
JOIN orderdetails AS od
	ON p.productcode = od.productcode
GROUP BY pl.productline
HAVING SUM (od.quantityordered)>3000 AND ROUND(AVG(priceeach),2) >80
ORDER BY "total terjual" DESC;

--nomor 5
SELECT c.customername, 
SUM (od.quantityordered*od.priceeach) AS "total transaksi",
COUNT (DISTINCT o.ordernumber) AS "total shipped orders",
ROUND((SUM(od.quantityordered*od.priceeach)/COUNT(DISTINCT od.ordernumber)),2) AS "avg transaction perorder"
FROM customers AS c
JOIN orders AS o
	ON c.customernumber = o.customernumber
JOIN orderdetails AS od
	ON o.ordernumber = od.ordernumber

WHERE o.status = 'Shipped'
GROUP BY c.customername
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM o.orderdate)) > 1
ORDER BY "total transaksi" DESC
LIMIT 5;

--nomor 6
SELECT c.customername,
c.city,
of.city,
SUM(od.quantityordered) AS total_unit_terjual,
ROUND(SUM(od.quantityordered*od.priceeach)/COUNT(DISTINCT o.ordernumber),2) AS avg_nilai_per_order
FROM customers AS c
JOIN orders AS o
	ON c.customernumber = o.customernumber
JOIN orderdetails AS od
	ON o.ordernumber = od.ordernumber
JOIN employees AS e
	ON c.salesrepemployeenumber = e.employeenumber
JOIN offices AS of
	ON e.officecode = of.officecode
	
WHERE of.territory = 'EMEA'
GROUP BY c.customername, c.city,of.city
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM o.orderdate)) > 2 AND 
SUM(od.quantityordered) > 1000 AND 
ROUND(SUM(od.quantityordered*od.priceeach)/COUNT(DISTINCT c.customernumber),2) > 10000
ORDER BY avg_nilai_per_order DESC;
