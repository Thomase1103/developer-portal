# Hướng Dẫn Viết DAX Functions

## DAX là gì?

DAX (Data Analysis Expressions) là ngôn ngữ công thức được sử dụng trong:
- Power BI
- Power Pivot trong Excel
- Analysis Services Tabular models

## Cú pháp cơ bản

### 1. Cấu trúc cơ bản của DAX
```dax
TenMeasure = FUNCTION(Tham_so)
```

### 2. Các loại DAX Functions chính

#### A. Calculated Columns
Tính toán giá trị cho mỗi dòng trong bảng:
```dax
Tong_Gia = Products[Gia] * Products[So_Luong]
```

#### B. Measures
Tính toán tổng hợp dữ liệu:
```dax
Tong_Doanh_Thu = SUM(Sales[Amount])
```

#### C. Calculated Tables
Tạo bảng mới từ dữ liệu hiện có:
```dax
Top_Customers = TOPN(10, Customers, [Total_Sales])
```

## Các hàm DAX quan trọng

### 1. Hàm Aggregate (Tổng hợp)

#### SUM - Tính tổng
```dax
Tong_Ban_Hang = SUM(Sales[Amount])
```

#### AVERAGE - Tính trung bình
```dax
Gia_Trung_Binh = AVERAGE(Products[Price])
```

#### COUNT/COUNTA - Đếm
```dax
So_Don_Hang = COUNT(Orders[OrderID])
So_Khach_Hang = COUNTA(Customers[CustomerName])
```

#### MIN/MAX - Giá trị nhỏ nhất/lớn nhất
```dax
Gia_Thap_Nhat = MIN(Products[Price])
Gia_Cao_Nhat = MAX(Products[Price])
```

### 2. Hàm Filter (Lọc dữ liệu)

#### CALCULATE - Hàm quan trọng nhất
```dax
Doanh_Thu_2023 = CALCULATE(
    SUM(Sales[Amount]),
    YEAR(Sales[Date]) = 2023
)
```

#### FILTER - Lọc bảng
```dax
Khach_Hang_VIP = CALCULATE(
    COUNT(Customers[CustomerID]),
    FILTER(Customers, Customers[TotalPurchase] > 1000000)
)
```

#### ALL/ALLEXCEPT - Bỏ qua bộ lọc
```dax
Ty_Le_Theo_Tong = 
DIVIDE(
    SUM(Sales[Amount]),
    CALCULATE(SUM(Sales[Amount]), ALL(Sales))
)
```

### 3. Hàm Date/Time

#### TODAY/NOW - Ngày hiện tại
```dax
Ngay_Hom_Nay = TODAY()
Thoi_Gian_Hien_Tai = NOW()
```

#### DATEDIFF - Tính khoảng cách thời gian
```dax
So_Ngay_Tu_Don_Hang = DATEDIFF(Orders[OrderDate], TODAY(), DAY)
```

#### DATEADD - Thêm/bớt thời gian
```dax
Doanh_Thu_Thang_Truoc = CALCULATE(
    SUM(Sales[Amount]),
    DATEADD(Calendar[Date], -1, MONTH)
)
```

### 4. Hàm Logic

#### IF - Điều kiện
```dax
Phan_Loai_Khach_Hang = 
IF(
    Customers[TotalPurchase] > 1000000,
    "VIP",
    IF(
        Customers[TotalPurchase] > 500000,
        "Premium",
        "Standard"
    )
)
```

#### SWITCH - Nhiều điều kiện
```dax
Mua_Sam_Theo_Mua = 
SWITCH(
    MONTH(Sales[Date]),
    1, "Thang 1",
    2, "Thang 2",
    3, "Thang 3",
    "Thang khac"
)
```

### 5. Hàm Text

#### CONCATENATE/& - Nối chuỗi
```dax
Ten_Day_Du = Customers[FirstName] & " " & Customers[LastName]
```

#### LEFT/RIGHT/MID - Cắt chuỗi
```dax
Ma_Vung = LEFT(Customers[Address], 2)
```

## Ví dụ thực tế

### 1. Phân tích bán hàng cơ bản

```dax
// Tổng doanh thu
Tong_Doanh_Thu = SUM(Sales[Amount])

// Doanh thu trung bình mỗi đơn hàng
Gia_Tri_Trung_Binh_Don_Hang = 
DIVIDE(
    SUM(Sales[Amount]),
    COUNT(Sales[OrderID])
)

// Tỷ lệ tăng trưởng so với năm trước
Tang_Truong_YoY = 
VAR DoanhThuNamNay = SUM(Sales[Amount])
VAR DoanhThuNamTruoc = CALCULATE(
    SUM(Sales[Amount]),
    SAMEPERIODLASTYEAR(Calendar[Date])
)
RETURN
DIVIDE(
    DoanhThuNamNay - DoanhThuNamTruoc,
    DoanhThuNamTruoc
)
```

### 2. Phân tích khách hàng

```dax
// Khách hàng mới trong tháng
Khach_Hang_Moi = 
VAR ThangHienTai = MONTH(TODAY())
VAR NamHienTai = YEAR(TODAY())
RETURN
CALCULATE(
    DISTINCTCOUNT(Customers[CustomerID]),
    MONTH(Customers[FirstPurchaseDate]) = ThangHienTai,
    YEAR(Customers[FirstPurchaseDate]) = NamHienTai
)

// Giá trị trọn đời khách hàng (CLV)
Customer_Lifetime_Value = 
SUMX(
    Customers,
    CALCULATE(SUM(Sales[Amount]))
)
```

### 3. Phân tích sản phẩm

```dax
// Top 10 sản phẩm bán chạy
Top_San_Pham = 
RANKX(
    ALL(Products[ProductName]),
    CALCULATE(SUM(Sales[Quantity])),
    ,
    DESC
)

// Tỷ lệ đóng góp của từng sản phẩm
Ty_Le_Dong_Gop = 
DIVIDE(
    SUM(Sales[Amount]),
    CALCULATE(
        SUM(Sales[Amount]),
        ALL(Products)
    )
)
```

## Best Practices (Thực hành tốt)

### 1. Sử dụng Variables (VAR)
```dax
Loi_Nhuan_Bien = 
VAR DoanhThu = SUM(Sales[Amount])
VAR ChiPhi = SUM(Sales[Cost])
RETURN
DIVIDE(DoanhThu - ChiPhi, DoanhThu)
```

### 2. Tối ưu hiệu suất
```dax
// Tốt - Sử dụng CALCULATE với filter đơn giản
Doanh_Thu_2023 = CALCULATE(
    SUM(Sales[Amount]),
    Sales[Year] = 2023
)

// Tránh - Filter phức tạp trong CALCULATE
Doanh_Thu_2023_Cham = CALCULATE(
    SUM(Sales[Amount]),
    FILTER(Sales, YEAR(Sales[Date]) = 2023)
)
```

### 3. Xử lý lỗi
```dax
An_Toan_Chia = 
IFERROR(
    DIVIDE(SUM(Sales[Amount]), COUNT(Sales[OrderID])),
    0
)
```

## Time Intelligence Functions

### 1. So sánh theo thời gian
```dax
// So với tháng trước
Doanh_Thu_Thang_Truoc = CALCULATE(
    SUM(Sales[Amount]),
    PREVIOUSMONTH(Calendar[Date])
)

// So với cùng kỳ năm trước
Doanh_Thu_Cung_Ky_Nam_Truoc = CALCULATE(
    SUM(Sales[Amount]),
    SAMEPERIODLASTYEAR(Calendar[Date])
)

// Tích lũy từ đầu năm
Doanh_Thu_Tu_Dau_Nam = CALCULATE(
    SUM(Sales[Amount]),
    DATESYTD(Calendar[Date])
)
```

### 2. Moving Averages
```dax
Trung_Binh_3_Thang = 
AVERAGEX(
    DATESINPERIOD(
        Calendar[Date],
        LASTDATE(Calendar[Date]),
        -3,
        MONTH
    ),
    CALCULATE(SUM(Sales[Amount]))
)
```

## Pattern thường dùng

### 1. ABC Analysis
```dax
ABC_Classification = 
VAR CurrentProductSales = CALCULATE(SUM(Sales[Amount]))
VAR TotalSales = CALCULATE(SUM(Sales[Amount]), ALL(Products))
VAR PercentageOfTotal = DIVIDE(CurrentProductSales, TotalSales)
VAR CumulativePercentage = 
    CALCULATE(
        SUM(Sales[Amount]),
        FILTER(
            ALL(Products),
            CALCULATE(SUM(Sales[Amount])) >= CurrentProductSales
        )
    ) / TotalSales
RETURN
SWITCH(
    TRUE(),
    CumulativePercentage <= 0.8, "A",
    CumulativePercentage <= 0.95, "B",
    "C"
)
```

### 2. Cohort Analysis
```dax
Cohort_Size = 
VAR FirstMonth = 
    CALCULATE(
        MIN(Sales[Date]),
        ALLEXCEPT(Sales, Customers[CustomerID])
    )
RETURN
CALCULATE(
    DISTINCTCOUNT(Customers[CustomerID]),
    Sales[Date] = FirstMonth
)
```

## Troubleshooting thường gặp

### 1. Lỗi Circular Dependency
```dax
// Sai - Tự tham chiếu
Wrong_Measure = [Wrong_Measure] + 1

// Đúng - Sử dụng VAR
Correct_Measure = 
VAR BaseValue = SUM(Sales[Amount])
RETURN BaseValue * 1.1
```

### 2. Context Transition
```dax
// Hiểu về Row Context và Filter Context
Sales_Per_Product = 
SUMX(
    Products,
    CALCULATE(SUM(Sales[Amount])) // CALCULATE tạo context transition
)
```

### 3. Performance Issues
```dax
// Chậm - Nhiều CALCULATE lồng nhau
Slow_Measure = 
CALCULATE(
    CALCULATE(
        CALCULATE(SUM(Sales[Amount]))
    )
)

// Nhanh - Gộp các filter
Fast_Measure = CALCULATE(
    SUM(Sales[Amount]),
    Products[Category] = "Electronics",
    Sales[Year] = 2023
)
```

## Kết luận

DAX là một ngôn ngữ mạnh mẽ để phân tích dữ liệu. Để thành thạo:

1. **Hiểu Context**: Row Context vs Filter Context
2. **Thực hành thường xuyên**: Viết nhiều measure và calculated column
3. **Tối ưu hiệu suất**: Sử dụng best practices
4. **Debug**: Sử dụng DAX Studio để test và tối ưu

Hãy bắt đầu với những hàm cơ bản và dần dần nâng cao độ phức tạp!