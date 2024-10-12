-------------------------------------
-- GROUP BY Yap�s� Aggregate Function
-------------------------------------
SELECT * FROM Products
ORDER BY CategoryID

-- COUNT
SELECT * FROM Customers
SELECT COUNT(ContactTitle) FROM Customers
-- unique olarak ContactTitle
SELECT COUNT(DISTINCT ContactTitle) FROM Customers
SELECT DISTINCT ContactTitle FROM Customers 

-- GROUP BY
SELECT ContactTitle, COUNT(ContactTitle) [Count]
FROM Customers
GROUP BY ContactTitle

SELECT * FROM Products
SELECT * FROM Categories

SELECT CAT.CategoryName, COUNT(P.ProductID) [ProductCount]
FROM Products P INNER JOIN Categories CAT ON P.CategoryID = CAT.CategoryID
GROUP BY CAT.CategoryName 
ORDER BY ProductCount

SELECT * FROM Suppliers

SELECT S.CompanyName, COUNT(P.ProductID) [ProductCount]
FROM Products P INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID
GROUP BY S.CompanyName -- tekrar eden tedarik�i company name'e g�re
-- Her bir CompanyName grubu i�in ka� adet �r�n oldu�una bak�l�r (COUNT(P.ProductID)).
ORDER BY ProductCount

-- SUM
SELECT * FROM Orders
SELECT * FROM [Order Details]
-- Her customer i�in toplam sipari� tutar�:
-- M��teriye g�re gruplay�p toplam tutar hesaplamam gerek 

SELECT O.CustomerID, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) [Total]
FROM Orders O INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.CustomerID
ORDER BY O.CustomerID

-- Her employee i�in total sipari� miktar�
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Employees


SELECT O.EmployeeID, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) [Total]
FROM Orders O INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.EmployeeID
ORDER BY O.EmployeeID

-- Her bir customer ka� adet sipari� vermi�
SELECT * FROM Orders

SELECT CustomerId, COUNT(CustomerID) [OrderCount] FROM Orders
GROUP BY CustomerID
ORDER BY OrderCount

-- MAX & MIN
SELECT * FROM [Order Details]
-- Her �r�nden sat�lan max adet say�s�n� bulal�m
SELECT ProductID, MAX(Quantity) [MaxQuantity]
FROM [Order Details]
GROUP BY ProductID
ORDER BY ProductID

SELECT * FROM [Order Details] WHERE ProductID = 3

-- Her �r�nden sat�lan min adet say�s�n� bulal�m
SELECT ProductID, MIN(Quantity) [MinQuantity]
FROM [Order Details]
GROUP BY ProductID
ORDER BY ProductID

SELECT * FROM [Order Details]
-- Bir sipari�teki Max adet:
SELECT OrderID, MAX(Quantity) [MaxQuantity]
FROM [Order Details]
GROUP BY OrderID
ORDER BY OrderID

SELECT * FROM Products
SELECT * FROM [Order Details]
-- Bir �r�nden ka� adet sat�ld�:
SELECT ProductID, SUM(Quantity) TotalProductQuantity
FROM [Order Details]
GROUP BY ProductID
ORDER BY ProductID

SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Customers
-- En �ok ciroyu sa�layan m��teri
SELECT O.CustomerID, C.CompanyName, 
SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) [Total]
INTO #tmpTotalByCustomer
FROM Orders O INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
INNER JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY O.CustomerID, C.CompanyName
ORDER BY [Total] desc

SELECT TOP 1 * FROM #tmpTotalByCustomer

DROP TABLE #tmpTotalByCustomer

-- M��terinin en yeni/en eski sipari�i
SELECT CustomerID, MAX(OrderDate) [CustomerLastOrderDate]
FROM Orders
GROUP BY CustomerID

SELECT CustomerID, MIN(OrderDate) [CustomerFirstOrderDate]
FROM Orders
GROUP BY CustomerID

-- AVG
SELECT * FROM Products

SELECT AVG(UnitPrice) [AvgUnitPrice]
FROM Products

SELECT * FROM [Order Details]
SELECT AVG(Quantity) [AvgQuantity]
FROM [Order Details]

SELECT * FROM Products
SELECT * FROM Categories
-- Her kategorideki ortalama �r�n fiyat�
SELECT CAT.CategoryName, AVG(P.UnitPrice) [AvgCategoryUnitPrice], COUNT(*) [Count] -- Kategoride ka� �r�n var (Count)
FROM Products P INNER JOIN Categories CAT ON P.CategoryID = CAT.CategoryID
GROUP BY CAT.CategoryName

SELECT * FROM Products
SELECT * FROM Suppliers
-- Her supplier i�in ortalama �r�n fiyat�
SELECT S.CompanyName, AVG(P.UnitPrice) [AvgSupplierUnitPrice], COUNT(*) [Count] 
FROM Products P INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID
GROUP BY S.CompanyName

SELECT * FROM Products
-- Herhangi bir kategorideki ortalama fiyat 2:
SELECT SUM(UnitPrice) / COUNT(UnitPrice)
FROM Products
WHERE CategoryID = 7

SELECT * FROM Products
-- Ortalama fiyat�n �zerinde kalan �r�n bilgileri:
SELECT CAT.CategoryID, CAT.CategoryName, AVG(P.UnitPrice) [AvgCategoryUnitPrice], COUNT(*) [Count] 
INTO #tmpAvgPriceByCategory
FROM Products P INNER JOIN Categories CAT ON P.CategoryID = CAT.CategoryID
GROUP BY CAT.CategoryName, CAT.CategoryID

--SELECT * FROM #tmpAvgPriceByCategory

SELECT P.ProductName, P.UnitPrice
FROM Products P INNER JOIN #tmpAvgPriceByCategory AVGPC ON P.CategoryID = AVGPC.CategoryID
GROUP BY P.ProductName, P.UnitPrice, AVGPC.AvgCategoryUnitPrice
HAVING P.UnitPrice > AVGPC.AvgCategoryUnitPrice

DROP TABLE #tmpAvgPriceByCategory 

-- Customer'lar�n sipari� adedi belli bir aral�kta onlar:
SELECT O.CustomerID, COUNT(O.CustomerID)[TotalOrderCount]
FROM Orders O INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.CustomerID
HAVING COUNT(O.CustomerID) BETWEEN 20 AND 30 -- [TotalOrderCount] okuyam�yor diye uzunca yazd�k
ORDER BY TotalOrderCount

SELECT O.CustomerID, COUNT(O.CustomerID)[TotalOrderCount]
INTO #tmpCustomerOrderCount
FROM Orders O INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.CustomerID
ORDER BY TotalOrderCount

SELECT * FROM #tmpCustomerOrderCount
WHERE TotalOrderCount BETWEEN 20 AND 30
ORDER BY TotalOrderCount

DROP TABLE #tmpCustomerOrderCount