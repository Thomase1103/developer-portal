# Ví dụ DAX thực tế với dữ liệu mẫu

## Dữ liệu mẫu

### Bảng Sales (Bán hàng)
| OrderID | CustomerID | ProductID | OrderDate | Amount | Discount |
|---------|------------|-----------|-----------|--------|----------|
| 1001 | C001 | P001 | 2023-01-15 | 1500 | 0.1 |
| 1002 | C002 | P002 | 2023-01-20 | 2500 | 0.05 |
| 1003 | C001 | P003 | 2023-02-10 | 800 | 0 |
| 1004 | C003 | P001 | 2023-02-15 | 1200 | 0.15 |
| 1005 | C002 | P004 | 2023-03-05 | 3000 | 0.2 |

### Bảng Customer (Khách hàng)
| CustomerID | FirstName | LastName | City | Segment |
|------------|-----------|----------|------|---------|
| C001 | Nguyễn | Văn A | Hà Nội | Premium |
| C002 | Trần | Thị B | TP.HCM | Standard |
| C003 | Lê | Văn C | Đà Nẵng | Premium |

### Bảng Product (Sản phẩm)
| ProductID | ProductName | Category | Price |
|-----------|-------------|----------|-------|
| P001 | Laptop Dell | Electronics | 1500 |
| P002 | iPhone 14 | Electronics | 2500 |
| P003 | Sách Excel | Books | 800 |
| P004 | Bàn làm việc | Furniture | 3000 |

## 1. Các ví dụ cơ bản

### 1.1. Tính tổng doanh thu
```dax
Tổng_Doanh_Thu = SUM(Sales[Amount])
// Kết quả: 9000
```

### 1.2. Tính doanh thu sau chiết khấu
```dax
Doanh_Thu_Sau_Chiết_Khấu = 
SUMX(
    Sales,
    Sales[Amount] * (1 - Sales[Discount])
)
// Kết quả: 7875
```

### 1.3. Đếm số đơn hàng
```dax
Số_Đơn_Hàng = COUNT(Sales[OrderID])
// Kết quả: 5
```

## 2. Các ví dụ với bộ lọc

### 2.1. Doanh thu theo tháng
```dax
Doanh_Thu_Tháng_1 = 
CALCULATE(
    SUM(Sales[Amount]),
    MONTH(Sales[OrderDate]) = 1
)
// Kết quả: 4000 (1001 + 1002)
```

### 2.2. Doanh thu khách hàng Premium
```dax
Doanh_Thu_Premium = 
CALCULATE(
    SUM(Sales[Amount]),
    RELATED(Customer[Segment]) = "Premium"
)
// Kết quả: 3500 (C001 + C003)
```

### 2.3. Doanh thu sản phẩm Electronics
```dax
Doanh_Thu_Electronics = 
CALCULATE(
    SUM(Sales[Amount]),
    RELATED(Product[Category]) = "Electronics"
)
// Kết quả: 5200 (P001 + P002)
```

## 3. Các ví dụ nâng cao

### 3.1. Tính tỷ lệ đóng góp theo khách hàng
```dax
Tỷ_Lệ_Đóng_Góp_Theo_Khách = 
DIVIDE(
    CALCULATE(SUM(Sales[Amount])),
    CALCULATE(SUM(Sales[Amount]), ALL(Sales)),
    0
)
```

### 3.2. Tính tăng trưởng doanh thu theo tháng
```dax
Tăng_Trưởng_Tháng_2 = 
DIVIDE(
    CALCULATE(SUM(Sales[Amount]), MONTH(Sales[OrderDate]) = 2) -
    CALCULATE(SUM(Sales[Amount]), MONTH(Sales[OrderDate]) = 1),
    CALCULATE(SUM(Sales[Amount]), MONTH(Sales[OrderDate]) = 1),
    0
)
// Kết quả: -0.5 (giảm 50%)
```

### 3.3. Tìm khách hàng có doanh thu cao nhất
```dax
Khách_Hàng_Top = 
CALCULATE(
    VALUES(Customer[FirstName]),
    TOPN(
        1,
        Customer,
        CALCULATE(SUM(Sales[Amount]))
    )
)
```

## 4. Các ví dụ với Time Intelligence

### 4.1. So sánh với tháng trước
```dax
So_Sánh_Tháng_Trước = 
DIVIDE(
    CALCULATE(SUM(Sales[Amount]), MONTH(Sales[OrderDate]) = 2) -
    CALCULATE(SUM(Sales[Amount]), MONTH(Sales[OrderDate]) = 1),
    CALCULATE(SUM(Sales[Amount]), MONTH(Sales[OrderDate]) = 1),
    0
)
```

### 4.2. Tính tổng tích lũy
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

## 5. Các ví dụ với Text Functions

### 5.1. Tạo mã đơn hàng ngắn
```dax
Mã_Đơn_Hàng_Ngắn = 
LEFT(Sales[OrderID], 2) & "-" & RIGHT(Sales[OrderID], 2)
// Kết quả: 10-01, 10-02, 10-03, ...
```

### 5.2. Tên khách hàng đầy đủ
```dax
Tên_Đầy_Đủ = 
CONCATENATE(
    RELATED(Customer[FirstName]),
    " ",
    RELATED(Customer[LastName])
)
```

## 6. Các ví dụ với Logical Functions

### 6.1. Phân loại đơn hàng theo giá trị
```dax
Phân_Loại_Đơn_Hàng = 
SWITCH(
    TRUE(),
    Sales[Amount] >= 2000, "Cao",
    Sales[Amount] >= 1000, "Trung Bình",
    "Thấp"
)
```

### 6.2. Tính phí vận chuyển
```dax
Phí_Vận_Chuyển = 
IF(
    Sales[Amount] > 2000,
    0,
    50
)
```

## 7. Các ví dụ với Iterator Functions

### 7.1. Tính tổng doanh thu có chiết khấu theo khách hàng
```dax
Doanh_Thu_Có_Chiết_Khấu_Theo_Khách = 
SUMX(
    VALUES(Customer[CustomerID]),
    CALCULATE(
        SUMX(
            Sales,
            Sales[Amount] * (1 - Sales[Discount])
        )
    )
)
```

### 7.2. Tính trung bình doanh thu theo sản phẩm
```dax
Trung_Bình_Doanh_Thu_Theo_Sản_Phẩm = 
AVERAGEX(
    VALUES(Product[ProductID]),
    CALCULATE(SUM(Sales[Amount]))
)
```

## 8. Các ví dụ với Table Functions

### 8.1. Số lượng khách hàng duy nhất
```dax
Số_Khách_Hàng_Duy_Nhất = 
COUNTROWS(VALUES(Customer[CustomerID]))
// Kết quả: 3
```

### 8.2. Số lượng sản phẩm đã bán
```dax
Số_Sản_Phẩm_Đã_Bán = 
COUNTROWS(VALUES(Product[ProductID]))
// Kết quả: 4
```

## 9. Các ví dụ phức tạp

### 9.1. Tính doanh thu theo segment và tháng
```dax
Doanh_Thu_Theo_Segment_Và_Tháng = 
CALCULATE(
    SUM(Sales[Amount]),
    VALUES(Customer[Segment]),
    VALUES(MONTH(Sales[OrderDate]))
)
```

### 9.2. Tìm sản phẩm bán chạy nhất
```dax
Sản_Phẩm_Bán_Chạy_Nhất = 
CALCULATE(
    VALUES(Product[ProductName]),
    TOPN(
        1,
        VALUES(Product[ProductID]),
        CALCULATE(COUNT(Sales[OrderID]))
    )
)
```

### 9.3. Tính tỷ lệ chiết khấu trung bình
```dax
Tỷ_Lệ_Chiết_Khấu_Trung_Bình = 
AVERAGE(Sales[Discount])
// Kết quả: 0.1 (10%)
```

## 10. Bài tập thực hành

### Bài tập 1: Tính doanh thu theo quý
```dax
Doanh_Thu_Theo_Quý = 
CALCULATE(
    SUM(Sales[Amount]),
    QUARTER(Sales[OrderDate])
)
```

### Bài tập 2: Tìm top 3 sản phẩm có doanh thu cao nhất
```dax
Top_3_Sản_Phẩm = 
TOPN(
    3,
    VALUES(Product[ProductID]),
    CALCULATE(SUM(Sales[Amount]))
)
```

### Bài tập 3: Tính tỷ lệ khách hàng Premium
```dax
Tỷ_Lệ_Khách_Premium = 
DIVIDE(
    CALCULATE(
        COUNTROWS(VALUES(Customer[CustomerID])),
        Customer[Segment] = "Premium"
    ),
    COUNTROWS(VALUES(Customer[CustomerID])),
    0
)
```

---

**Hướng dẫn sử dụng**: 
1. Copy các công thức DAX vào Power BI hoặc Excel Power Pivot
2. Thay đổi tên bảng và cột cho phù hợp với dữ liệu của bạn
3. Kiểm tra kết quả và điều chỉnh công thức nếu cần
4. Thực hành với dữ liệu thực tế của bạn