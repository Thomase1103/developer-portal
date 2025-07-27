# Hướng dẫn sử dụng SQL trong Power BI

## Giới thiệu về SQL trong Power BI

SQL (Structured Query Language) là ngôn ngữ truy vấn dữ liệu quan trọng trong Power BI, được sử dụng để:
- Kết nối và truy vấn dữ liệu từ cơ sở dữ liệu
- Thực hiện các phép biến đổi dữ liệu
- Tối ưu hiệu suất truy vấn
- Tạo các view và stored procedure

## 1. Kết nối SQL Database trong Power BI

### 1.1. Kết nối SQL Server
```
1. Mở Power BI Desktop
2. Chọn "Get Data" > "Database" > "SQL Server"
3. Nhập thông tin kết nối:
   - Server: tên server hoặc IP
   - Database: tên database
   - Authentication: Windows hoặc SQL Server
4. Chọn "Connect"
```

### 1.2. Kết nối Azure SQL Database
```
1. Chọn "Get Data" > "Azure" > "Azure SQL Database"
2. Nhập thông tin:
   - Server: your-server.database.windows.net
   - Database: tên database
   - Authentication: SQL Server Authentication
3. Nhập username và password
```

### 1.3. Kết nối MySQL/PostgreSQL
```
1. Chọn "Get Data" > "Database"
2. Chọn MySQL hoặc PostgreSQL
3. Nhập thông tin kết nối tương ứng
```

## 2. Truy vấn SQL cơ bản

### 2.1. Truy vấn SELECT đơn giản
```sql
-- Lấy tất cả dữ liệu từ bảng Sales
SELECT * FROM Sales
```

### 2.2. Truy vấn với điều kiện
```sql
-- Lấy doanh thu năm 2023
SELECT 
    OrderID,
    OrderDate,
    Amount,
    CustomerID
FROM Sales
WHERE YEAR(OrderDate) = 2023
```

### 2.3. Truy vấn với JOIN
```sql
-- Kết hợp dữ liệu Sales và Customer
SELECT 
    s.OrderID,
    s.OrderDate,
    s.Amount,
    c.FirstName,
    c.LastName,
    c.City
FROM Sales s
INNER JOIN Customer c ON s.CustomerID = c.CustomerID
```

### 2.4. Truy vấn với GROUP BY
```sql
-- Tính tổng doanh thu theo khách hàng
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(s.Amount) as TotalRevenue,
    COUNT(s.OrderID) as OrderCount
FROM Sales s
INNER JOIN Customer c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalRevenue DESC
```

## 3. Truy vấn SQL nâng cao

### 3.1. Sử dụng Common Table Expression (CTE)
```sql
-- Tính doanh thu theo tháng và tăng trưởng
WITH MonthlyRevenue AS (
    SELECT 
        YEAR(OrderDate) as Year,
        MONTH(OrderDate) as Month,
        SUM(Amount) as Revenue
    FROM Sales
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
),
RevenueGrowth AS (
    SELECT 
        Year,
        Month,
        Revenue,
        LAG(Revenue) OVER (ORDER BY Year, Month) as PreviousRevenue
    FROM MonthlyRevenue
)
SELECT 
    Year,
    Month,
    Revenue,
    PreviousRevenue,
    (Revenue - PreviousRevenue) / PreviousRevenue * 100 as GrowthPercent
FROM RevenueGrowth
WHERE PreviousRevenue IS NOT NULL
```

### 3.2. Sử dụng Window Functions
```sql
-- Tính tổng tích lũy và ranking
SELECT 
    CustomerID,
    OrderDate,
    Amount,
    SUM(Amount) OVER (
        PARTITION BY CustomerID 
        ORDER BY OrderDate 
        ROWS UNBOUNDED PRECEDING
    ) as CumulativeAmount,
    ROW_NUMBER() OVER (
        PARTITION BY CustomerID 
        ORDER BY Amount DESC
    ) as OrderRank
FROM Sales
```

### 3.3. Sử dụng Subquery
```sql
-- Tìm khách hàng có doanh thu cao hơn trung bình
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(s.Amount) as TotalRevenue
FROM Sales s
INNER JOIN Customer c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(s.Amount) > (
    SELECT AVG(TotalRevenue) 
    FROM (
        SELECT CustomerID, SUM(Amount) as TotalRevenue
        FROM Sales
        GROUP BY CustomerID
    ) as AvgRevenue
)
```

## 4. Tối ưu hiệu suất SQL

### 4.1. Sử dụng INDEX
```sql
-- Tạo index cho các cột thường xuyên truy vấn
CREATE INDEX IX_Sales_OrderDate ON Sales(OrderDate)
CREATE INDEX IX_Sales_CustomerID ON Sales(CustomerID)
CREATE INDEX IX_Sales_Amount ON Sales(Amount)
```

### 4.2. Sử dụng WHERE hiệu quả
```sql
-- Tốt - Sử dụng index
SELECT * FROM Sales 
WHERE OrderDate >= '2023-01-01' 
AND OrderDate < '2024-01-01'

-- Không tốt - Không sử dụng index
SELECT * FROM Sales 
WHERE YEAR(OrderDate) = 2023
```

### 4.3. Giới hạn kết quả
```sql
-- Sử dụng TOP để giới hạn kết quả
SELECT TOP 100 *
FROM Sales
ORDER BY OrderDate DESC
```

## 5. Tạo View và Stored Procedure

### 5.1. Tạo View
```sql
-- Tạo view cho doanh thu theo khách hàng
CREATE VIEW vw_CustomerRevenue AS
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.City,
    SUM(s.Amount) as TotalRevenue,
    COUNT(s.OrderID) as OrderCount,
    AVG(s.Amount) as AverageOrderValue
FROM Sales s
INNER JOIN Customer c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.City
```

### 5.2. Tạo Stored Procedure
```sql
-- Tạo stored procedure cho báo cáo doanh thu
CREATE PROCEDURE sp_GetRevenueReport
    @StartDate DATE,
    @EndDate DATE,
    @CustomerID NVARCHAR(10) = NULL
AS
BEGIN
    SELECT 
        s.OrderID,
        s.OrderDate,
        s.Amount,
        c.FirstName,
        c.LastName
    FROM Sales s
    INNER JOIN Customer c ON s.CustomerID = c.CustomerID
    WHERE s.OrderDate BETWEEN @StartDate AND @EndDate
    AND (@CustomerID IS NULL OR s.CustomerID = @CustomerID)
    ORDER BY s.OrderDate DESC
END
```

## 6. Sử dụng SQL trong Power Query

### 6.1. Truy vấn SQL trong Power Query
```sql
-- Truy vấn SQL trong Power Query Editor
SELECT 
    CustomerID,
    FirstName,
    LastName,
    City,
    CASE 
        WHEN City IN ('Hà Nội', 'TP.HCM') THEN 'Thành phố lớn'
        ELSE 'Tỉnh lẻ'
    END as CityType
FROM Customer
```

### 6.2. Kết hợp SQL với Power Query Transformations
```sql
-- Truy vấn SQL cơ bản
SELECT 
    OrderID,
    OrderDate,
    Amount,
    CustomerID
FROM Sales
WHERE OrderDate >= '2023-01-01'
```

Sau đó trong Power Query:
```m
// Thêm cột tính toán
= Table.AddColumn(Source, "Year", each Date.Year([OrderDate]))
= Table.AddColumn(Source, "Month", each Date.Month([OrderDate]))
```

## 7. Các loại kết nối SQL

### 7.1. Import Mode (Mặc định)
```
- Dữ liệu được import vào Power BI
- Tốc độ truy vấn nhanh
- Cần refresh để cập nhật dữ liệu
- Phù hợp với dữ liệu nhỏ và trung bình
```

### 7.2. DirectQuery Mode
```
- Truy vấn trực tiếp từ database
- Dữ liệu luôn cập nhật
- Hiệu suất phụ thuộc vào database
- Phù hợp với dữ liệu lớn
```

### 7.3. Live Connection
```
- Kết nối trực tiếp với Analysis Services
- Tốc độ truy vấn nhanh
- Không thể thay đổi model
- Phù hợp với enterprise environment
```

## 8. Best Practices

### 8.1. Tối ưu truy vấn
```sql
-- Sử dụng SELECT cụ thể thay vì SELECT *
SELECT 
    OrderID,
    OrderDate,
    Amount,
    CustomerID
FROM Sales
WHERE OrderDate >= '2023-01-01'
```

### 8.2. Sử dụng parameter
```sql
-- Sử dụng parameter để linh hoạt
SELECT * FROM Sales
WHERE OrderDate >= @StartDate
AND OrderDate <= @EndDate
```

### 8.3. Xử lý lỗi
```sql
-- Sử dụng TRY-CATCH để xử lý lỗi
BEGIN TRY
    SELECT * FROM Sales WHERE OrderDate = '2023-01-01'
END TRY
BEGIN CATCH
    SELECT 'Lỗi truy vấn: ' + ERROR_MESSAGE()
END CATCH
```

## 9. Ví dụ thực tế

### 9.1. Báo cáo doanh thu theo thời gian
```sql
-- Truy vấn cho báo cáo doanh thu
SELECT 
    YEAR(OrderDate) as Year,
    MONTH(OrderDate) as Month,
    DATENAME(MONTH, OrderDate) as MonthName,
    SUM(Amount) as TotalRevenue,
    COUNT(OrderID) as OrderCount,
    AVG(Amount) as AverageOrderValue
FROM Sales
WHERE OrderDate >= '2023-01-01'
GROUP BY YEAR(OrderDate), MONTH(OrderDate), DATENAME(MONTH, OrderDate)
ORDER BY Year, Month
```

### 9.2. Phân tích khách hàng
```sql
-- Phân tích khách hàng theo segment
SELECT 
    c.Segment,
    COUNT(DISTINCT c.CustomerID) as CustomerCount,
    SUM(s.Amount) as TotalRevenue,
    AVG(s.Amount) as AverageRevenue,
    COUNT(s.OrderID) as TotalOrders
FROM Customer c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.Segment
ORDER BY TotalRevenue DESC
```

### 9.3. Top khách hàng
```sql
-- Top 10 khách hàng có doanh thu cao nhất
SELECT TOP 10
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.City,
    SUM(s.Amount) as TotalRevenue,
    COUNT(s.OrderID) as OrderCount,
    AVG(s.Amount) as AverageOrderValue
FROM Sales s
INNER JOIN Customer c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.City
ORDER BY TotalRevenue DESC
```

## 10. Troubleshooting

### 10.1. Lỗi kết nối
```
- Kiểm tra thông tin server và database
- Kiểm tra quyền truy cập
- Kiểm tra firewall
- Thử kết nối từ SQL Server Management Studio
```

### 10.2. Lỗi hiệu suất
```
- Kiểm tra index trên các cột truy vấn
- Sử dụng Execution Plan để phân tích
- Giới hạn kết quả với TOP hoặc LIMIT
- Sử dụng WHERE để lọc dữ liệu sớm
```

### 10.3. Lỗi syntax
```
- Kiểm tra cú pháp SQL
- Sử dụng SQL Server Management Studio để test
- Kiểm tra version của SQL Server
- Tham khảo documentation
```

---

**Lưu ý quan trọng**:
1. Luôn test truy vấn SQL trước khi sử dụng trong Power BI
2. Sử dụng parameter để tăng tính linh hoạt
3. Tối ưu hiệu suất với index và WHERE clause
4. Backup dữ liệu trước khi thực hiện thay đổi lớn
5. Document các truy vấn phức tạp