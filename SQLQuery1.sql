

ALTER TABLE OnlineRetail
ADD TotalSales AS (Quantity * UnitPrice) PERSISTED;

--Total Transaction from 01/12/2010 to 09/12/2011 
SELECT COUNT(InvoiceNo)
FROM OnlineRetail

--TOTAL SALES
SELECT ROUND(SUM(TotalSales),2)
FROM OnlineRetail

--5.	SALES BREAKDOWN
-- By Product 

WITH ProductGroup AS(
SELECT Description, COUNT(Description) as 'NumberofPurchase' 
FROM OnlineRetail 
GROUP BY Description 
)
SELECT TOP 20 Description, NumberofPurchase 
FROM ProductGroup
ORDER BY NumberofPurchase DESC
;

-- By Customer

WITH Customer AS(
SELECT CustomerID, COUNT(CustomerID) as 'NumberofPurchase' 
FROM OnlineRetail 
GROUP BY CustomerID 
)
SELECT TOP 20 CustomerID, NumberofPurchase
FROM Customer
ORDER BY NumberofPurchase DESC
;

-- By Country

WITH Customer AS(
SELECT Country, COUNT(Country) as 'NumberofPurchase' 
FROM OnlineRetail 
GROUP BY Country
)
SELECT  Country, NumberofPurchase
FROM Customer
ORDER BY NumberofPurchase DESC
;


--7.	Customer Analysis

--Identifying High Value Customers( Sales breakdown by customer)
--geographical regions contributing the most to revenue and profitability (Sales breakdown by region)


--9.	Pricing Analysis
--Analyze Price-Volume Relationship
SELECT
    UnitPrice,
    SUM(Quantity) AS TotalQuantity,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM
    OnlineRetail
GROUP BY
    UnitPrice
ORDER BY
    UnitPrice;



-- 10.	Seasonal Analysis
SELECT
    MONTH(InvoiceDate) AS Month,
    ROUND(SUM(TotalSales),0) AS TotalSales
FROM
    OnlineRetail
GROUP BY
    MONTH(InvoiceDate)
ORDER BY
    --MONTH(InvoiceDate) 
	2 DESC;



--12 Risk Assessment
-- i. Sales growth rate by month(Analyze Market Trends)
SELECT
    YEAR(InvoiceDate) AS Year,
    MONTH(InvoiceDate) AS Month,
    Round(SUM(TotalSales),0) AS TotalSales
FROM
    OnlineRetail
GROUP BY
    YEAR(InvoiceDate),
    MONTH(InvoiceDate)
ORDER BY
    YEAR(InvoiceDate),
    MONTH(InvoiceDate);


-- ii. Customer segmentation based on purchase behavior(Evaluate Customer Behavior Changes)
SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS NumTransactions,
    ROUND(SUM(TotalSales),2) AS TotalSpent
FROM
    OnlineRetail
GROUP BY
    CustomerID;


--iii Calculate Average Order Value (AOV)
SELECT
    Description,
    SUM(Quantity * UnitPrice) AS TotalSales
FROM
    OnlineRetail
GROUP BY
    Description;


-- iv. Inventory turnover rate(Consider Industry-specific Risks)
SELECT
    Description,
    SUM(Quantity) AS TotalQuantitySold,
    (SUM(Quantity) / COUNT(DISTINCT InvoiceDate)) AS AvgQuantitySoldPerDay
FROM
    OnlineRetail
GROUP BY
    Description;


-- v. Identify underperforming products for targeted improvement(Mitigation Strategies)
SELECT
    Description,
    SUM(Quantity * UnitPrice) AS TotalSales
FROM
    OnlineRetail
GROUP BY
    Description
HAVING
    TotalSales < (SELECT AVG(Quantity * UnitPrice) FROM OnlineRetail);

--dashboard

-- 8.	Sales Channel Performance
-- Calculate revenue by sales channel(Calculate Revenue by Sales Channel)
SELECT
    CASE
        WHEN InvoiceNo LIKE 'C%' THEN 'Cancellation'
        WHEN CustomerID IS NULL THEN 'Unknown'
        ELSE 'Online' -- Modify this condition based on your available sales channel information
    END AS SalesChannel,
    SUM(Quantity * UnitPrice) AS Revenue
FROM
    OnlineRetail
GROUP BY
    CASE
        WHEN InvoiceNo LIKE 'C%' THEN 'Cancellation'
        WHEN CustomerID IS NULL THEN 'Unknown'
        ELSE 'Online' -- Modify this condition based on your available sales channel information
    END;


9 Cancellation Analysis
-- Calculate cancellation statistics
SELECT
    SUM(CASE WHEN InvoiceNo LIKE 'C%' THEN 1 ELSE 0 END) AS CanceledTransactions,
    SUM(CASE WHEN InvoiceNo LIKE 'C%' THEN Quantity * UnitPrice ELSE 0 END) AS CanceledRevenue,
    COUNT(*) AS TotalTransactions,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM
    OnlineRetail;


--10 Key Performance Indicators (KPIs)
-- Calculate Average Order Value (AOV)
SELECT
    AVG(Quantity * UnitPrice) AS AverageOrderValue
FROM
    OnlineRetail;
