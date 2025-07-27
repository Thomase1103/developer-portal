# Ví dụ SQL thực tế cho Power BI

## Dữ liệu mẫu

### Bảng Sales
```sql
CREATE TABLE Sales (
    OrderID INT PRIMARY KEY,
    CustomerID VARCHAR(10),
    ProductID VARCHAR(10),
    OrderDate DATE,
    Amount DECIMAL(10,2),
    Discount DECIMAL(3,2),
    Region VARCHAR(50)
);

INSERT INTO Sales VALUES
(1001, 'C001', 'P001', '2023-01-15', 1500.00, 0.10, 'Miền Bắc'),
(1002, 'C002', 'P002', '2023-01-20', 2500.00, 0.05, 'Miền Nam'),
(1003, 'C001', 'P003', '2023-02-10', 800.00, 0.00, 'Miền Bắc'),
(1004, 'C003', 'P001', '2023-02-15', 1200.00, 0.15, 'Miền Trung'),
(1005, 'C002', 'P004', '2023-03-05', 3000.00, 0.20, 'Miền Nam'),
(1006, 'C004', 'P002', '2023-03-10', 1800.00, 0.08, 'Miền Bắc'),
(1007, 'C003', 'P003', '2023-04-01', 950.00, 0.12, 'Miền Trung'),
(1008, 'C001', 'P004', '2023-04-15', 2200.00, 0.18, 'Miền Bắc');
```

### Bảng Customer
```sql
CREATE TABLE Customer (
    CustomerID VARCHAR(10) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    City VARCHAR(50),
    Segment VARCHAR(20),
    JoinDate DATE
);

INSERT INTO Customer VALUES
('C001', 'Nguyễn', 'Văn A', 'Hà Nội', 'Premium', '2020-01-15'),
('C002', 'Trần', 'Thị B', 'TP.HCM', 'Standard', '2021-03-20'),
('C003', 'Lê', 'Văn C', 'Đà Nẵng', 'Premium', '2019-11-10'),
('C004', 'Phạm', 'Thị D', 'Hải Phòng', 'Standard', '2022-06-05');
```

### Bảng Product
```sql
CREATE TABLE Product (
    ProductID VARCHAR(10) PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Supplier VARCHAR(50)
);

INSERT INTO Product VALUES
('P001', 'Laptop Dell XPS 13', 'Electronics', 1500.00, 'Dell Inc'),
('P002', 'iPhone 14 Pro', 'Electronics', 2500.00, 'Apple Inc'),
('P003', 'Sách Excel Nâng Cao', 'Books', 800.00, 'NXB Giáo Dục'),
('P004', 'Bàn làm việc cao cấp', 'Furniture', 3000.00, 'IKEA');
```

## 1. Truy vấn cơ bản cho Dashboard

### 1.1. KPI Tổng quan
```sql
-- Tổng doanh thu, số đơn hàng, trung bình đơn hàng
SELECT 
    SUM(Amount) as TotalRevenue,
    COUNT(OrderID) as TotalOrders,
    AVG(Amount) as AverageOrderValue,
    COUNT(DISTINCT CustomerID) as UniqueCustomers
FROM Sales
WHERE OrderDate >= '2023-01-01'
```

### 1.2. Doanh thu theo tháng
```sql
-- Doanh thu theo tháng năm 2023
SELECT 
    YEAR(OrderDate) as Year,
    MONTH(OrderDate) as Month,
    DATENAME(MONTH, OrderDate) as MonthName,
    SUM(Amount) as MonthlyRevenue,
    COUNT(OrderID) as OrderCount,
    AVG(Amount) as AverageOrderValue
FROM Sales
WHERE YEAR(OrderDate) = 2023
GROUP BY YEAR(OrderDate), MONTH(OrderDate), DATENAME(MONTH, OrderDate)
ORDER BY Year, Month
```

### 1.3. Doanh thu theo khu vực
```sql
-- Doanh thu theo khu vực
SELECT 
    Region,
    SUM(Amount) as TotalRevenue,
    COUNT(OrderID) as OrderCount,
    AVG(Amount) as AverageOrderValue,
    COUNT(DISTINCT CustomerID) as CustomerCount
FROM Sales
WHERE OrderDate >= '2023-01-01'
GROUP BY Region
ORDER BY TotalRevenue DESC
```

## 2. Phân tích khách hàng

### 2.1. Top khách hàng theo doanh thu
```sql
-- Top 5 khách hàng có doanh thu cao nhất
SELECT TOP 5
    c.CustomerID,
    c.FirstName + ' ' + c.LastName as FullName,
    c.City,
    c.Segment,
    SUM(s.Amount) as TotalRevenue,
    COUNT(s.OrderID) as OrderCount,
    AVG(s.Amount) as AverageOrderValue,
    MAX(s.OrderDate) as LastOrderDate
FROM Sales s
INNER JOIN Customer c ON s.CustomerID = c.CustomerID
WHERE s.OrderDate >= '2023-01-01'
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.City, c.Segment
ORDER BY TotalRevenue DESC
```

### 2.2. Phân tích theo segment
```sql
-- Phân tích khách hàng theo segment
SELECT 
    c.Segment,
    COUNT(DISTINCT c.CustomerID) as CustomerCount,
    SUM(s.Amount) as TotalRevenue,
    AVG(s.Amount) as AverageRevenue,
    COUNT(s.OrderID) as TotalOrders,
    AVG(s.Amount) as AverageOrderValue
FROM Customer c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID 
    AND s.OrderDate >= '2023-01-01'
GROUP BY c.Segment
ORDER BY TotalRevenue DESC
```

### 2.3. Khách hàng mới vs cũ
```sql
-- So sánh khách hàng mới và cũ
SELECT 
    CASE 
        WHEN c.JoinDate >= '2023-01-01' THEN 'Khách hàng mới'
        ELSE 'Khách hàng cũ'
    END as CustomerType,
    COUNT(DISTINCT c.CustomerID) as CustomerCount,
    SUM(s.Amount) as TotalRevenue,
    AVG(s.Amount) as AverageRevenue
FROM Customer c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID 
    AND s.OrderDate >= '2023-01-01'
GROUP BY 
    CASE 
        WHEN c.JoinDate >= '2023-01-01' THEN 'Khách hàng mới'
        ELSE 'Khách hàng cũ'
    END
```

## 3. Phân tích sản phẩm

### 3.1. Top sản phẩm bán chạy
```sql
-- Top sản phẩm theo doanh thu
SELECT TOP 10
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Supplier,
    SUM(s.Amount) as TotalRevenue,
    COUNT(s.OrderID) as OrderCount,
    AVG(s.Amount) as AverageOrderValue
FROM Sales s
INNER JOIN Product p ON s.ProductID = p.ProductID
WHERE s.OrderDate >= '2023-01-01'
GROUP BY p.ProductID, p.ProductName, p.Category, p.Supplier
ORDER BY TotalRevenue DESC
```

### 3.2. Phân tích theo category
```sql
-- Doanh thu theo category
SELECT 
    p.Category,
    SUM(s.Amount) as TotalRevenue,
    COUNT(s.OrderID) as OrderCount,
    AVG(s.Amount) as AverageOrderValue,
    COUNT(DISTINCT s.CustomerID) as CustomerCount
FROM Sales s
INNER JOIN Product p ON s.ProductID = p.ProductID
WHERE s.OrderDate >= '2023-01-01'
GROUP BY p.Category
ORDER BY TotalRevenue DESC
```

### 3.3. Sản phẩm theo khu vực
```sql
-- Sản phẩm bán chạy theo khu vực
SELECT 
    s.Region,
    p.Category,
    SUM(s.Amount) as TotalRevenue,
    COUNT(s.OrderID) as OrderCount
FROM Sales s
INNER JOIN Product p ON s.ProductID = p.ProductID
WHERE s.OrderDate >= '2023-01-01'
GROUP BY s.Region, p.Category
ORDER BY s.Region, TotalRevenue DESC
```

## 4. Time Intelligence

### 4.1. So sánh với tháng trước
```sql
-- So sánh doanh thu với tháng trước
WITH MonthlyRevenue AS (
    SELECT 
        YEAR(OrderDate) as Year,
        MONTH(OrderDate) as Month,
        SUM(Amount) as Revenue
    FROM Sales
    WHERE OrderDate >= '2023-01-01'
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
),
RevenueComparison AS (
    SELECT 
        Year,
        Month,
        Revenue,
        LAG(Revenue) OVER (ORDER BY Year, Month) as PreviousMonthRevenue
    FROM MonthlyRevenue
)
SELECT 
    Year,
    Month,
    Revenue,
    PreviousMonthRevenue,
    Revenue - PreviousMonthRevenue as RevenueChange,
    CASE 
        WHEN PreviousMonthRevenue = 0 THEN NULL
        ELSE (Revenue - PreviousMonthRevenue) / PreviousMonthRevenue * 100
    END as GrowthPercent
FROM RevenueComparison
WHERE PreviousMonthRevenue IS NOT NULL
ORDER BY Year, Month
```

### 4.2. Tổng tích lũy theo tháng
```sql
-- Tổng tích lũy doanh thu theo tháng
SELECT 
    YEAR(OrderDate) as Year,
    MONTH(OrderDate) as Month,
    DATENAME(MONTH, OrderDate) as MonthName,
    SUM(Amount) as MonthlyRevenue,
    SUM(SUM(Amount)) OVER (
        ORDER BY YEAR(OrderDate), MONTH(OrderDate)
        ROWS UNBOUNDED PRECEDING
    ) as CumulativeRevenue
FROM Sales
WHERE YEAR(OrderDate) = 2023
GROUP BY YEAR(OrderDate), MONTH(OrderDate), DATENAME(MONTH, OrderDate)
ORDER BY Year, Month
```

### 4.3. Tăng trưởng theo quý
```sql
-- Tăng trưởng doanh thu theo quý
WITH QuarterlyRevenue AS (
    SELECT 
        YEAR(OrderDate) as Year,
        DATEPART(QUARTER, OrderDate) as Quarter,
        SUM(Amount) as Revenue
    FROM Sales
    WHERE OrderDate >= '2023-01-01'
    GROUP BY YEAR(OrderDate), DATEPART(QUARTER, OrderDate)
)
SELECT 
    Year,
    Quarter,
    Revenue,
    LAG(Revenue) OVER (ORDER BY Year, Quarter) as PreviousQuarterRevenue,
    Revenue - LAG(Revenue) OVER (ORDER BY Year, Quarter) as RevenueChange
FROM QuarterlyRevenue
ORDER BY Year, Quarter
```

## 5. Advanced Analytics

### 5.1. Phân tích RFM (Recency, Frequency, Monetary)
```sql
-- Phân tích RFM cho khách hàng
WITH CustomerRFM AS (
    SELECT 
        s.CustomerID,
        c.FirstName + ' ' + c.LastName as CustomerName,
        c.Segment,
        DATEDIFF(DAY, MAX(s.OrderDate), GETDATE()) as Recency,
        COUNT(s.OrderID) as Frequency,
        SUM(s.Amount) as Monetary
    FROM Sales s
    INNER JOIN Customer c ON s.CustomerID = c.CustomerID
    WHERE s.OrderDate >= '2023-01-01'
    GROUP BY s.CustomerID, c.FirstName, c.LastName, c.Segment
),
RFMScore AS (
    SELECT 
        *,
        NTILE(4) OVER (ORDER BY Recency DESC) as R_Score,
        NTILE(4) OVER (ORDER BY Frequency) as F_Score,
        NTILE(4) OVER (ORDER BY Monetary) as M_Score
    FROM CustomerRFM
)
SELECT 
    CustomerID,
    CustomerName,
    Segment,
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,
    R_Score + F_Score + M_Score as RFM_Score,
    CASE 
        WHEN R_Score >= 3 AND F_Score >= 3 AND M_Score >= 3 THEN 'VIP'
        WHEN R_Score >= 3 AND F_Score >= 3 THEN 'Loyal'
        WHEN M_Score >= 3 THEN 'Big Spender'
        WHEN R_Score >= 3 THEN 'Recent'
        WHEN F_Score >= 3 THEN 'Frequent'
        ELSE 'At Risk'
    END as CustomerSegment
FROM RFMScore
ORDER BY RFM_Score DESC
```

### 5.2. Phân tích chiết khấu
```sql
-- Phân tích hiệu quả chiết khấu
SELECT 
    CASE 
        WHEN Discount = 0 THEN 'Không chiết khấu'
        WHEN Discount <= 0.1 THEN 'Chiết khấu thấp (≤10%)'
        WHEN Discount <= 0.2 THEN 'Chiết khấu trung bình (11-20%)'
        ELSE 'Chiết khấu cao (>20%)'
    END as DiscountCategory,
    COUNT(OrderID) as OrderCount,
    SUM(Amount) as TotalRevenue,
    AVG(Amount) as AverageOrderValue,
    SUM(Amount * Discount) as TotalDiscount,
    AVG(Discount) as AverageDiscount
FROM Sales
WHERE OrderDate >= '2023-01-01'
GROUP BY 
    CASE 
        WHEN Discount = 0 THEN 'Không chiết khấu'
        WHEN Discount <= 0.1 THEN 'Chiết khấu thấp (≤10%)'
        WHEN Discount <= 0.2 THEN 'Chiết khấu trung bình (11-20%)'
        ELSE 'Chiết khấu cao (>20%)'
    END
ORDER BY TotalRevenue DESC
```

### 5.3. Phân tích theo thời gian
```sql
-- Phân tích doanh thu theo ngày trong tuần
SELECT 
    DATENAME(WEEKDAY, OrderDate) as DayOfWeek,
    DATEPART(WEEKDAY, OrderDate) as DayNumber,
    COUNT(OrderID) as OrderCount,
    SUM(Amount) as TotalRevenue,
    AVG(Amount) as AverageOrderValue
FROM Sales
WHERE OrderDate >= '2023-01-01'
GROUP BY DATENAME(WEEKDAY, OrderDate), DATEPART(WEEKDAY, OrderDate)
ORDER BY DayNumber
```

## 6. Stored Procedures cho Power BI

### 6.1. Stored Procedure cho báo cáo tổng quan
```sql
CREATE PROCEDURE sp_GetDashboardSummary
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        -- KPI chính
        SUM(Amount) as TotalRevenue,
        COUNT(OrderID) as TotalOrders,
        AVG(Amount) as AverageOrderValue,
        COUNT(DISTINCT CustomerID) as UniqueCustomers,
        
        -- Phân tích theo segment
        SUM(CASE WHEN c.Segment = 'Premium' THEN Amount ELSE 0 END) as PremiumRevenue,
        SUM(CASE WHEN c.Segment = 'Standard' THEN Amount ELSE 0 END) as StandardRevenue,
        
        -- Phân tích theo khu vực
        SUM(CASE WHEN Region = 'Miền Bắc' THEN Amount ELSE 0 END) as NorthRevenue,
        SUM(CASE WHEN Region = 'Miền Nam' THEN Amount ELSE 0 END) as SouthRevenue,
        SUM(CASE WHEN Region = 'Miền Trung' THEN Amount ELSE 0 END) as CentralRevenue
        
    FROM Sales s
    LEFT JOIN Customer c ON s.CustomerID = c.CustomerID
    WHERE s.OrderDate BETWEEN @StartDate AND @EndDate
END
```

### 6.2. Stored Procedure cho phân tích khách hàng
```sql
CREATE PROCEDURE sp_GetCustomerAnalysis
    @StartDate DATE,
    @EndDate DATE,
    @Segment VARCHAR(20) = NULL
AS
BEGIN
    SELECT 
        c.CustomerID,
        c.FirstName + ' ' + c.LastName as CustomerName,
        c.City,
        c.Segment,
        c.JoinDate,
        COUNT(s.OrderID) as OrderCount,
        SUM(s.Amount) as TotalRevenue,
        AVG(s.Amount) as AverageOrderValue,
        MAX(s.OrderDate) as LastOrderDate,
        MIN(s.OrderDate) as FirstOrderDate,
        DATEDIFF(DAY, MAX(s.OrderDate), GETDATE()) as DaysSinceLastOrder
    FROM Customer c
    LEFT JOIN Sales s ON c.CustomerID = s.CustomerID 
        AND s.OrderDate BETWEEN @StartDate AND @EndDate
    WHERE (@Segment IS NULL OR c.Segment = @Segment)
    GROUP BY c.CustomerID, c.FirstName, c.LastName, c.City, c.Segment, c.JoinDate
    ORDER BY TotalRevenue DESC
END
```

## 7. Views cho Power BI

### 7.1. View cho báo cáo doanh thu
```sql
CREATE VIEW vw_RevenueReport AS
SELECT 
    s.OrderID,
    s.OrderDate,
    s.Amount,
    s.Discount,
    s.Region,
    c.CustomerID,
    c.FirstName + ' ' + c.LastName as CustomerName,
    c.Segment,
    c.City,
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Supplier,
    YEAR(s.OrderDate) as Year,
    MONTH(s.OrderDate) as Month,
    DATENAME(MONTH, s.OrderDate) as MonthName,
    DATEPART(QUARTER, s.OrderDate) as Quarter,
    s.Amount * (1 - s.Discount) as NetAmount
FROM Sales s
INNER JOIN Customer c ON s.CustomerID = c.CustomerID
INNER JOIN Product p ON s.ProductID = p.ProductID
```

### 7.2. View cho phân tích khách hàng
```sql
CREATE VIEW vw_CustomerAnalysis AS
SELECT 
    c.CustomerID,
    c.FirstName + ' ' + c.LastName as CustomerName,
    c.City,
    c.Segment,
    c.JoinDate,
    COUNT(s.OrderID) as TotalOrders,
    SUM(s.Amount) as TotalRevenue,
    AVG(s.Amount) as AverageOrderValue,
    MAX(s.OrderDate) as LastOrderDate,
    MIN(s.OrderDate) as FirstOrderDate,
    DATEDIFF(DAY, c.JoinDate, GETDATE()) as CustomerAge,
    DATEDIFF(DAY, MAX(s.OrderDate), GETDATE()) as DaysSinceLastOrder
FROM Customer c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.City, c.Segment, c.JoinDate
```

## 8. Sử dụng trong Power BI

### 8.1. Kết nối và load dữ liệu
```
1. Mở Power BI Desktop
2. Get Data > SQL Server
3. Nhập thông tin kết nối
4. Chọn stored procedure hoặc view
5. Load dữ liệu vào Power BI
```

### 8.2. Tạo measures với DAX
```dax
// Tổng doanh thu
Total Revenue = SUM(Sales[Amount])

// Doanh thu sau chiết khấu
Net Revenue = SUMX(Sales, Sales[Amount] * (1 - Sales[Discount]))

// Tăng trưởng so với tháng trước
Revenue Growth = 
DIVIDE(
    [Total Revenue] - CALCULATE([Total Revenue], PREVIOUSMONTH(Sales[OrderDate])),
    CALCULATE([Total Revenue], PREVIOUSMONTH(Sales[OrderDate])),
    0
)
```

---

**Lưu ý**: 
- Test tất cả truy vấn SQL trước khi sử dụng trong Power BI
- Sử dụng parameter để tăng tính linh hoạt
- Tối ưu hiệu suất với index và WHERE clause
- Backup dữ liệu trước khi thực hiện thay đổi