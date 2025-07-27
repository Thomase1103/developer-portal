# Hướng dẫn học DAX (Data Analysis Expressions)

## Giới thiệu về DAX

DAX (Data Analysis Expressions) là ngôn ngữ công thức được sử dụng trong Power BI, SQL Server Analysis Services (SSAS), và Power Pivot trong Excel để tạo ra các tính toán và phân tích dữ liệu.

## 1. Cú pháp cơ bản của DAX

### Cấu trúc cơ bản:
```
Tên_Đo = CÔNG_THỨC_DAX
```

### Ví dụ đơn giản:
```
Tổng_Doanh_Thu = SUM(Sales[Amount])
```

## 2. Các loại DAX Functions chính

### 2.1. Aggregation Functions (Hàm tổng hợp)

#### SUM - Tính tổng
```dax
Tổng_Doanh_Thu = SUM(Sales[Amount])
```

#### AVERAGE - Tính trung bình
```dax
Trung_Bình_Doanh_Thu = AVERAGE(Sales[Amount])
```

#### COUNT - Đếm số lượng
```dax
Số_Lượng_Đơn_Hàng = COUNT(Sales[OrderID])
```

#### COUNTROWS - Đếm số dòng
```dax
Số_Dòng_Dữ_Liệu = COUNTROWS(Sales)
```

### 2.2. Text Functions (Hàm xử lý văn bản)

#### CONCATENATE - Nối chuỗi
```dax
Tên_Đầy_Đủ = CONCATENATE(Customer[FirstName], " ", Customer[LastName])
```

#### LEFT - Lấy ký tự bên trái
```dax
Mã_Đơn_Hàng = LEFT(Sales[OrderID], 3)
```

#### RIGHT - Lấy ký tự bên phải
```dax
Mã_Sản_Phẩm = RIGHT(Products[ProductCode], 4)
```

### 2.3. Date Functions (Hàm xử lý ngày tháng)

#### TODAY - Ngày hôm nay
```dax
Ngày_Hiện_Tại = TODAY()
```

#### NOW - Thời gian hiện tại
```dax
Thời_Gian_Hiện_Tại = NOW()
```

#### YEAR - Lấy năm
```dax
Năm_Đơn_Hàng = YEAR(Sales[OrderDate])
```

#### MONTH - Lấy tháng
```dax
Tháng_Đơn_Hàng = MONTH(Sales[OrderDate])
```

### 2.4. Logical Functions (Hàm logic)

#### IF - Điều kiện
```dax
Trạng_Thái_Đơn_Hàng = 
IF(
    Sales[Amount] > 1000,
    "Cao",
    "Thấp"
)
```

#### SWITCH - Chuyển đổi nhiều điều kiện
```dax
Phân_Loại_Doanh_Thu = 
SWITCH(
    TRUE(),
    Sales[Amount] >= 5000, "Rất Cao",
    Sales[Amount] >= 2000, "Cao",
    Sales[Amount] >= 500, "Trung Bình",
    "Thấp"
)
```

## 3. Filter Functions (Hàm lọc)

### CALCULATE - Tính toán với bộ lọc
```dax
Doanh_Thu_2023 = 
CALCULATE(
    SUM(Sales[Amount]),
    YEAR(Sales[OrderDate]) = 2023
)
```

### FILTER - Lọc dữ liệu
```dax
Doanh_Thu_Cao = 
CALCULATE(
    SUM(Sales[Amount]),
    FILTER(
        Sales,
        Sales[Amount] > 1000
    )
)
```

## 4. Time Intelligence Functions (Hàm thông minh thời gian)

### SAMEPERIODLASTYEAR - So sánh với năm trước
```dax
Doanh_Thu_Năm_Trước = 
CALCULATE(
    SUM(Sales[Amount]),
    SAMEPERIODLASTYEAR(Sales[OrderDate])
)
```

### PREVIOUSMONTH - Tháng trước
```dax
Doanh_Thu_Tháng_Trước = 
CALCULATE(
    SUM(Sales[Amount]),
    PREVIOUSMONTH(Sales[OrderDate])
)
```

## 5. Iterator Functions (Hàm lặp)

### SUMX - Tính tổng với điều kiện
```dax
Tổng_Doanh_Thu_Có_Chiết_Khấu = 
SUMX(
    Sales,
    Sales[Amount] * (1 - Sales[Discount])
)
```

### AVERAGEX - Tính trung bình với điều kiện
```dax
Trung_Bình_Doanh_Thu_Theo_Khách_Hàng = 
AVERAGEX(
    Customer,
    CALCULATE(SUM(Sales[Amount]))
)
```

## 6. Relationship Functions (Hàm quan hệ)

### RELATED - Lấy dữ liệu từ bảng liên quan
```dax
Tên_Sản_Phẩm = RELATED(Products[ProductName])
```

### RELATEDTABLE - Lấy bảng liên quan
```dax
Số_Đơn_Hàng_Của_Khách = 
COUNTROWS(
    RELATEDTABLE(Sales)
)
```

## 7. Table Functions (Hàm bảng)

### ALL - Bỏ tất cả bộ lọc
```dax
Tổng_Doanh_Thu_Tất_Cả = 
CALCULATE(
    SUM(Sales[Amount]),
    ALL(Sales)
)
```

### VALUES - Lấy giá trị duy nhất
```dax
Số_Khách_Hàng = 
COUNTROWS(VALUES(Customer[CustomerID]))
```

## 8. Ví dụ thực tế

### Ví dụ 1: Tính tỷ lệ phần trăm
```dax
Tỷ_Lệ_Doanh_Thu = 
DIVIDE(
    SUM(Sales[Amount]),
    CALCULATE(
        SUM(Sales[Amount]),
        ALL(Sales)
    ),
    0
)
```

### Ví dụ 2: Tính tăng trưởng
```dax
Tăng_Trưởng_Doanh_Thu = 
DIVIDE(
    SUM(Sales[Amount]) - 
    CALCULATE(
        SUM(Sales[Amount]),
        SAMEPERIODLASTYEAR(Sales[OrderDate])
    ),
    CALCULATE(
        SUM(Sales[Amount]),
        SAMEPERIODLASTYEAR(Sales[OrderDate])
    ),
    0
)
```

### Ví dụ 3: Tính tổng tích lũy
```dax
Tổng_Tích_Lũy = 
CALCULATE(
    SUM(Sales[Amount]),
    FILTER(
        ALL(Sales),
        Sales[OrderDate] <= MAX(Sales[OrderDate])
    )
)
```

## 9. Best Practices (Thực hành tốt nhất)

### 9.1. Đặt tên biến rõ ràng
```dax
// Tốt
Tổng_Doanh_Thu_2023 = CALCULATE(SUM(Sales[Amount]), YEAR(Sales[OrderDate]) = 2023)

// Không tốt
T = CALCULATE(SUM(Sales[Amount]), YEAR(Sales[OrderDate]) = 2023)
```

### 9.2. Sử dụng comment
```dax
// Tính tổng doanh thu theo năm
Tổng_Doanh_Thu_Theo_Năm = 
CALCULATE(
    SUM(Sales[Amount]),
    YEAR(Sales[OrderDate])
)
```

### 9.3. Kiểm tra lỗi
```dax
Tỷ_Lệ_An_Toàn = 
IF(
    ISBLANK(SUM(Sales[Amount])),
    0,
    DIVIDE(SUM(Sales[Amount]), COUNT(Sales[OrderID]))
)
```

## 10. Debugging DAX

### Sử dụng EVALUATE để test
```dax
EVALUATE
FILTER(
    Sales,
    Sales[Amount] > 1000
)
```

### Kiểm tra kết quả từng bước
```dax
// Bước 1: Tính tổng
Tổng_Test = SUM(Sales[Amount])

// Bước 2: Thêm bộ lọc
Tổng_Test_Có_Lọc = CALCULATE(SUM(Sales[Amount]), YEAR(Sales[OrderDate]) = 2023)
```

## 11. Tài nguyên học tập

1. **Microsoft DAX Reference**: https://docs.microsoft.com/en-us/dax/
2. **DAX Patterns**: https://www.daxpatterns.com/
3. **Power BI Community**: https://community.powerbi.com/
4. **SQLBI**: https://www.sqlbi.com/

## 12. Bài tập thực hành

### Bài tập 1: Tính doanh thu theo quý
```dax
Doanh_Thu_Theo_Quý = 
CALCULATE(
    SUM(Sales[Amount]),
    QUARTER(Sales[OrderDate])
)
```

### Bài tập 2: Tìm top 5 khách hàng
```dax
Top_5_Khách_Hàng = 
TOPN(
    5,
    Customer,
    CALCULATE(SUM(Sales[Amount]))
)
```

### Bài tập 3: Tính tỷ lệ đóng góp
```dax
Tỷ_Lệ_Đóng_Góp = 
DIVIDE(
    CALCULATE(SUM(Sales[Amount])),
    CALCULATE(SUM(Sales[Amount]), ALL(Sales)),
    0
)
```

---

**Lưu ý**: DAX là ngôn ngữ mạnh mẽ nhưng cần thực hành nhiều để thành thạo. Hãy bắt đầu với các hàm cơ bản và dần dần nâng cao kỹ năng của bạn.