--What were your best-selling products last year?

SELECT TOP 10 p.Name, SUM(s.LineTotal) AS TotalSales
FROM Sales.SalesOrderDetail s
JOIN Production.Product p ON s.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalSales DESC

--What is the highest revenue generating category?

SELECT pc.Name, SUM(s.LineTotal) AS Revenue
FROM Sales.SalesOrderDetail s
JOIN Production.Product p ON s.ProductID = p.ProductID
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY Revenue DESC

--What is the average discount that customers get?

SELECT AVG(UnitPriceDiscount) AS AvgDiscount
FROM Sales.SalesOrderDetail

--What is the average number of products in each order?

SELECT AVG(OrderQty) AS AvgProductsPerOrder
FROM Sales.SalesOrderDetail

--Which products have the highest quantity sold?

SELECT TOP 10 p.Name, SUM(s.OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail s
JOIN Production.Product p ON s.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalQuantity DESC;

--Which countries have the most customers?

SELECT c.CountryRegionCode, COUNT(*) AS CustomerCount
FROM Sales.Customer cu
JOIN Person.Address a ON cu.CustomerID = a.AddressID
JOIN Person.StateProvince s ON a.StateProvinceID = s.StateProvinceID
JOIN Person.CountryRegion c ON s.CountryRegionCode = c.CountryRegionCode
GROUP BY c.CountryRegionCode
ORDER BY CustomerCount DESC

--Who are your top 10 buying customers?

SELECT TOP 10 
    p.FirstName + ' ' + p.LastName AS CustomerName,
    SUM(s.LineTotal) AS TotalPurchase
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail s ON h.SalesOrderID = s.SalesOrderID
JOIN Sales.Customer c ON h.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY p.FirstName, p.LastName
ORDER BY TotalPurchase DESC

--How many new customers per year?

SELECT YEAR(h.OrderDate) AS Year, COUNT(DISTINCT h.CustomerID) AS NewCustomers
FROM Sales.SalesOrderHeader h
GROUP BY YEAR(h.OrderDate)
ORDER BY Year

--Which cities have the most sales?

SELECT TOP 10  a.City, COUNT(*) AS SalesCount
FROM Sales.SalesOrderHeader h
JOIN Person.Address a ON h.ShipToAddressID = a.AddressID
GROUP BY a.City
ORDER BY SalesCount DESC

--How many customers didn't buy anything?

SELECT COUNT(*) AS InactiveCustomers
FROM Sales.Customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.SalesOrderHeader h
    WHERE h.CustomerID = c.CustomerID
)

--What is the job distribution in the company?

SELECT JobTitle, COUNT(*) AS NumberOfEmployees
FROM HumanResources.Employee
GROUP BY JobTitle
ORDER BY NumberOfEmployees DESC

-- What is the average length of service for employees in each department?

SELECT d.Name AS Department,
       AVG(DATEDIFF(YEAR, e.HireDate, GETDATE())) AS AvgYearsWorked
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL  
GROUP BY d.Name
ORDER BY AvgYearsWorked DESC


--Who were the employees hired in the last 20 years?

SELECT YEAR(HireDate) AS HireYear, COUNT(*) AS NumberOfHiredEmployees
FROM HumanResources.Employee
WHERE HireDate >= DATEADD(YEAR, -20, GETDATE())
GROUP BY YEAR(HireDate)
ORDER BY HireYear

--What is the sales distribution by month of the year?

SELECT MONTH(OrderDate) AS Month, SUM(TotalDue) AS MonthlySales
FROM Sales.SalesOrderHeader
GROUP BY MONTH(OrderDate)
ORDER BY Month

--What is the percentage growth in sales between years?

SELECT YEAR(OrderDate) AS Year, SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY Year

--How many orders are placed each month?

SELECT 
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    COUNT(SalesOrderID) AS TotalOrders
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY OrderYear, OrderMonth

--What is the average bill amount per month?

SELECT 
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    AVG(TotalDue) AS AvgInvoiceAmount
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month

--How many orders were shipped late from the order date?

SELECT 
    COUNT(*) AS LateOrders
FROM Sales.SalesOrderHeader
WHERE ShipDate > OrderDate

--What seasons have the most sales?

SELECT 
    CASE 
        WHEN MONTH(OrderDate) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(OrderDate) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(OrderDate) IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH(OrderDate) IN (9, 10, 11) THEN 'Fall'
    END AS Season,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY 
    CASE 
        WHEN MONTH(OrderDate) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(OrderDate) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(OrderDate) IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH(OrderDate) IN (9, 10, 11) THEN 'Fall'
    END
ORDER BY TotalSales DESC


