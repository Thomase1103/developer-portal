# Mẹo và Kỹ thuật DAX nâng cao

## 1. Kỹ thuật tối ưu hiệu suất

### 1.1. Sử dụng CALCULATE thay vì FILTER khi có thể
```dax
// Tốt - Hiệu suất cao hơn
Doanh_Thu_2023 = 
CALCULATE(
    SUM(Sales[Amount]),
    YEAR(Sales[OrderDate]) = 2023
)

// Không tốt - Hiệu suất thấp hơn
Doanh_Thu_2023 = 
CALCULATE(
    SUM(Sales[Amount]),
    FILTER(
        Sales,
        YEAR(Sales[OrderDate]) = 2023
    )
)
```

### 1.2. Sử dụng VALUES thay vì DISTINCT
```dax
// Tốt
Số_Khách_Hàng = COUNTROWS(VALUES(Customer[CustomerID]))

// Không tốt
Số_Khách_Hàng = COUNTROWS(DISTINCT(Customer[CustomerID]))
```

### 1.3. Tránh sử dụng ALL() không cần thiết
```dax
// Tốt - Chỉ bỏ bộ lọc cần thiết
Doanh_Thu_Tất_Cả = 
CALCULATE(
    SUM(Sales[Amount]),
    ALL(Customer)
)

// Không tốt - Bỏ tất cả bộ lọc
Doanh_Thu_Tất_Cả = 
CALCULATE(
    SUM(Sales[Amount]),
    ALL()
)
```

## 2. Kỹ thuật xử lý lỗi

### 2.1. Xử lý lỗi chia cho 0
```dax
Tỷ_Lệ_An_Toàn = 
IF(
    ISBLANK(SUM(Sales[Amount])) || SUM(Sales[Amount]) = 0,
    0,
    DIVIDE(
        SUM(Sales[Amount]),
        CALCULATE(SUM(Sales[Amount]), ALL(Sales))
    )
)
```

### 2.2. Xử lý dữ liệu null
```dax
Doanh_Thu_Không_Null = 
CALCULATE(
    SUM(Sales[Amount]),
    NOT(ISBLANK(Sales[Amount]))
)
```

### 2.3. Xử lý lỗi RELATED
```dax
Tên_Sản_Phẩm_An_Toàn = 
IF(
    ISBLANK(RELATED(Product[ProductName])),
    "Không xác định",
    RELATED(Product[ProductName])
)
```

## 3. Kỹ thuật tạo biến (Variables)

### 3.1. Sử dụng VAR để tối ưu hiệu suất
```dax
Doanh_Thu_Phức_Tạp = 
VAR TotalSales = SUM(Sales[Amount])
VAR TotalSalesLastYear = 
    CALCULATE(
        SUM(Sales[Amount]),
        SAMEPERIODLASTYEAR(Sales[OrderDate])
    )
VAR Growth = 
    IF(
        TotalSalesLastYear = 0,
        0,
        DIVIDE(TotalSales - TotalSalesLastYear, TotalSalesLastYear)
    )
RETURN
    Growth
```

### 3.2. Tạo biến cho điều kiện phức tạp
```dax
Phân_Loại_Doanh_Thu = 
VAR CurrentAmount = SUM(Sales[Amount])
VAR AverageAmount = AVERAGE(Sales[Amount])
RETURN
    SWITCH(
        TRUE(),
        CurrentAmount >= AverageAmount * 1.5, "Rất Cao",
        CurrentAmount >= AverageAmount, "Cao",
        CurrentAmount >= AverageAmount * 0.5, "Trung Bình",
        "Thấp"
    )
```

## 4. Kỹ thuật Time Intelligence nâng cao

### 4.1. Tính tăng trưởng YTD
```dax
Tăng_Trưởng_YTD = 
VAR CurrentYTD = 
    CALCULATE(
        SUM(Sales[Amount]),
        DATESYTD(Sales[OrderDate])
    )
VAR PreviousYTD = 
    CALCULATE(
        SUM(Sales[Amount]),
        DATESYTD(SAMEPERIODLASTYEAR(Sales[OrderDate]))
    )
RETURN
    DIVIDE(CurrentYTD - PreviousYTD, PreviousYTD, 0)
```

### 4.2. Tính tổng tích lũy theo tháng
```dax
Tổng_Tích_Lũy_Theo_Tháng = 
CALCULATE(
    SUM(Sales[Amount]),
    FILTER(
        ALL(Sales),
        YEAR(Sales[OrderDate]) = YEAR(MAX(Sales[OrderDate])) &&
        MONTH(Sales[OrderDate]) <= MONTH(MAX(Sales[OrderDate]))
    )
)
```

### 4.3. So sánh với cùng kỳ năm trước
```dax
So_Sánh_Cùng_Kỳ = 
VAR CurrentPeriod = SUM(Sales[Amount])
VAR PreviousPeriod = 
    CALCULATE(
        SUM(Sales[Amount]),
        SAMEPERIODLASTYEAR(Sales[OrderDate])
    )
RETURN
    DIVIDE(CurrentPeriod - PreviousPeriod, PreviousPeriod, 0)
```

## 5. Kỹ thuật xử lý dữ liệu phức tạp

### 5.1. Tạo bảng ảo với GENERATESERIES
```dax
Bảng_Tháng = 
GENERATESERIES(1, 12, 1)
```

### 5.2. Tạo bảng với UNION
```dax
Bảng_Tất_Cả_Khách = 
UNION(
    VALUES(Customer[CustomerID]),
    {BLANK()}
)
```

### 5.3. Sử dụng ADDCOLUMNS để tạo cột tính toán
```dax
Bảng_Chi_Tiết = 
ADDCOLUMNS(
    VALUES(Customer[CustomerID]),
    "Doanh Thu", CALCULATE(SUM(Sales[Amount])),
    "Số Đơn Hàng", CALCULATE(COUNT(Sales[OrderID]))
)
```

## 6. Kỹ thuật tạo Dashboard

### 6.1. Tạo KPI với nhiều điều kiện
```dax
KPI_Doanh_Thu = 
VAR Target = 10000
VAR Actual = SUM(Sales[Amount])
VAR Variance = Actual - Target
VAR VariancePercent = DIVIDE(Variance, Target, 0)
RETURN
    SWITCH(
        TRUE(),
        VariancePercent >= 0.1, "Tuyệt vời",
        VariancePercent >= 0, "Tốt",
        VariancePercent >= -0.1, "Cần cải thiện",
        "Cần hành động ngay"
    )
```

### 6.2. Tạo thước đo tương đối
```dax
Thước_Đo_Tương_Đối = 
VAR CurrentValue = SUM(Sales[Amount])
VAR MinValue = MIN(Sales[Amount])
VAR MaxValue = MAX(Sales[Amount])
RETURN
    DIVIDE(CurrentValue - MinValue, MaxValue - MinValue, 0)
```

## 7. Kỹ thuật xử lý dữ liệu không đồng nhất

### 7.1. Chuẩn hóa dữ liệu
```dax
Tên_Chuẩn_Hóa = 
UPPER(TRIM(LEFT(Customer[FirstName], 1))) & 
LOWER(TRIM(RIGHT(Customer[FirstName], LEN(Customer[FirstName]) - 1)))
```

### 7.2. Xử lý dữ liệu thiếu
```dax
Doanh_Thu_Điền_Thiếu = 
IF(
    ISBLANK(SUM(Sales[Amount])),
    AVERAGE(Sales[Amount]),
    SUM(Sales[Amount])
)
```

## 8. Kỹ thuật tối ưu bộ nhớ

### 8.1. Sử dụng EARLIER thay vì nested CALCULATE
```dax
// Tốt
Doanh_Thu_Tương_Đối = 
SUMX(
    Sales,
    Sales[Amount] / CALCULATE(SUM(Sales[Amount]), ALL(Sales))
)

// Không tốt - Nested CALCULATE
Doanh_Thu_Tương_Đối = 
CALCULATE(
    DIVIDE(
        SUM(Sales[Amount]),
        CALCULATE(SUM(Sales[Amount]), ALL(Sales))
    )
)
```

### 8.2. Sử dụng SUMMARIZE thay vì GROUPBY
```dax
// Tốt
Tổng_Theo_Khách = 
SUMMARIZE(
    Sales,
    Customer[CustomerID],
    "Doanh Thu", SUM(Sales[Amount])
)

// Không tốt
Tổng_Theo_Khách = 
GROUPBY(
    Sales,
    Customer[CustomerID],
    "Doanh Thu", SUM(Sales[Amount])
)
```

## 9. Kỹ thuật debug và test

### 9.1. Tạo công thức test
```dax
Test_Formula = 
VAR TestValue = SUM(Sales[Amount])
VAR ExpectedValue = 9000
VAR IsCorrect = TestValue = ExpectedValue
RETURN
    IF(IsCorrect, "Đúng", "Sai")
```

### 9.2. Sử dụng ISERROR để bắt lỗi
```dax
Formula_An_Toàn = 
IF(
    ISERROR(SUM(Sales[Amount])),
    "Lỗi tính toán",
    SUM(Sales[Amount])
)
```

## 10. Best Practices tổng hợp

### 10.1. Đặt tên biến có ý nghĩa
```dax
// Tốt
Doanh_Thu_Khách_Premium_2023 = 
VAR PremiumCustomers = FILTER(Customer, Customer[Segment] = "Premium")
VAR Year2023 = YEAR(Sales[OrderDate]) = 2023
RETURN
    CALCULATE(
        SUM(Sales[Amount]),
        PremiumCustomers,
        Year2023
    )

// Không tốt
DT = 
VAR A = FILTER(Customer, Customer[Segment] = "Premium")
VAR B = YEAR(Sales[OrderDate]) = 2023
RETURN
    CALCULATE(SUM(Sales[Amount]), A, B)
```

### 10.2. Sử dụng comment cho công thức phức tạp
```dax
// Tính tổng doanh thu theo khách hàng Premium trong năm 2023
// Bước 1: Lọc khách hàng Premium
// Bước 2: Lọc theo năm 2023
// Bước 3: Tính tổng doanh thu
Doanh_Thu_Premium_2023 = 
VAR PremiumCustomers = FILTER(Customer, Customer[Segment] = "Premium")
VAR Year2023 = YEAR(Sales[OrderDate]) = 2023
RETURN
    CALCULATE(
        SUM(Sales[Amount]),
        PremiumCustomers,
        Year2023
    )
```

### 10.3. Tạo công thức có thể tái sử dụng
```dax
// Công thức cơ bản có thể tái sử dụng
Base_Revenue = SUM(Sales[Amount])

// Sử dụng công thức cơ bản
Revenue_2023 = CALCULATE(Base_Revenue, YEAR(Sales[OrderDate]) = 2023)
Revenue_Premium = CALCULATE(Base_Revenue, Customer[Segment] = "Premium")
```

---

**Lưu ý quan trọng**:
1. Luôn test công thức với dữ liệu nhỏ trước
2. Sử dụng Performance Analyzer trong Power BI để kiểm tra hiệu suất
3. Tạo backup trước khi thay đổi công thức phức tạp
4. Document các công thức quan trọng
5. Thực hành thường xuyên để nâng cao kỹ năng