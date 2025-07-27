# DAX Examples - Ví dụ Thực hành DAX

Thư mục này chứa các ví dụ DAX functions được phân loại theo mức độ từ cơ bản đến nâng cao.

## Cấu trúc Files

### 1. `basic-measures.dax`
**Mức độ: Cơ bản** 🟢

Chứa các measures DAX cơ bản cho:
- Tổng hợp dữ liệu (SUM, COUNT, AVERAGE)
- Sử dụng CALCULATE function
- Time Intelligence cơ bản
- Phân tích khách hàng
- Phân tích sản phẩm
- KPIs và metrics cơ bản

**Phù hợp cho:** Người mới bắt đầu học DAX

### 2. `calculated-columns.dax`
**Mức độ: Trung bình** 🟡

Chứa các calculated columns cho:
- Bảng Sales (phân loại, ranking, ABC analysis)
- Bảng Customers (RFM analysis, segmentation)
- Bảng Products (lifecycle, performance analysis)
- Bảng Date (calendar attributes)

**Phù hợp cho:** Người đã có kinh nghiệm cơ bản với DAX

### 3. `advanced-patterns.dax`
**Mức độ: Nâng cao** 🔴

Chứa các pattern phức tạp:
- Iterative functions
- Dynamic segmentation
- Cross-filtering techniques
- Advanced time intelligence
- Statistical analysis
- Recursive calculations
- Error handling

**Phù hợp cho:** Người có kinh nghiệm với DAX và muốn học các kỹ thuật nâng cao

## Cách sử dụng

### Bước 1: Chuẩn bị dữ liệu
Các ví dụ này giả định bạn có các bảng sau:

```
Sales Table:
- OrderID (Text)
- CustomerID (Text) 
- ProductID (Text)
- Date (Date)
- Amount (Decimal)
- Quantity (Integer)
- Cost (Decimal)
- Unit_Price (Decimal)

Customers Table:
- CustomerID (Text)
- First_Name (Text)
- Last_Name (Text)
- Birth_Date (Date)
- City (Text)
- Region (Text)

Products Table:
- ProductID (Text)
- Product_Name (Text)
- Category (Text)
- SubCategory (Text)
- Unit_Price (Decimal)
- Launch_Date (Date)
- SKU (Text)

Date Table:
- Date (Date)
- Year (Integer)
- Month (Integer)
- Quarter (Integer)
```

### Bước 2: Import vào Power BI
1. Mở Power BI Desktop
2. Load dữ liệu của bạn
3. Đi tới tab "Modeling"
4. Copy-paste các DAX formulas từ files

### Bước 3: Tạo Relationships
Đảm bảo tạo relationships giữa các bảng:
- Sales[CustomerID] → Customers[CustomerID]
- Sales[ProductID] → Products[ProductID]  
- Sales[Date] → Date[Date]

### Bước 4: Test và Modify
- Test các measures với dữ liệu thực của bạn
- Modify các threshold values cho phù hợp
- Thêm error handling nếu cần

## Các Concept quan trọng

### 1. Context trong DAX
```dax
// Row Context - chạy cho từng dòng
Products[Total_Revenue] = Products[Unit_Price] * Products[Quantity_Sold]

// Filter Context - áp dụng filter
Total_Sales = CALCULATE(SUM(Sales[Amount]), Products[Category] = "Electronics")
```

### 2. Variables (VAR)
```dax
// Sử dụng VAR để code sạch hơn và hiệu quả hơn
Profit_Analysis = 
VAR Revenue = SUM(Sales[Amount])
VAR Cost = SUM(Sales[Cost])
VAR Profit = Revenue - Cost
RETURN
DIVIDE(Profit, Revenue, 0)
```

### 3. Error Handling
```dax
// Luôn handle division by zero
Safe_Division = DIVIDE(SUM(Sales[Amount]), COUNT(Sales[OrderID]), 0)

// Check for blank values
Result = IF(ISBLANK([Measure]), "No Data", [Measure])
```

### 4. Performance Tips
```dax
// Tốt - Filter trước rồi tính toán
Good_Performance = CALCULATE(
    SUM(Sales[Amount]),
    Products[Category] = "Electronics"
)

// Không tốt - Tính toán rồi filter
Bad_Performance = CALCULATE(
    SUM(Sales[Amount]),
    FILTER(Products, Products[Category] = "Electronics")
)
```

## Troubleshooting thường gặp

### Lỗi: "A single value for column 'X' cannot be determined"
**Nguyên nhân:** Đang try lấy single value từ column có nhiều values

**Giải pháp:**
```dax
// Thay vì
Wrong = Products[Category]

// Sử dụng
Correct = SELECTEDVALUE(Products[Category], "Multiple Categories")
```

### Lỗi: "The column 'X' either doesn't exist or doesn't have a relationship"
**Nguyên nhân:** Thiếu relationship hoặc sai table reference

**Giải pháp:**
- Check relationships trong Model view
- Đảm bảo table names và column names đúng

### Lỗi: Measures trả về blank
**Nguyên nhân:** Context filtering loại bỏ hết dữ liệu

**Giải pháp:**
```dax
// Check context với ALL()
Debug_Measure = CALCULATE(SUM(Sales[Amount]), ALL())
```

## Best Practices

### 1. Naming Conventions
```dax
// Measures: không có prefix
Total Sales = SUM(Sales[Amount])

// Calculated Columns: Table[Column]
Sales[Profit_Margin] = DIVIDE(Sales[Profit], Sales[Amount])

// Tables: PascalCase
'Date Table'[Month Name]
```

### 2. Code Organization
```dax
// Sử dụng indentation và line breaks
Complex_Measure = 
VAR Variable1 = CALCULATE(...)
VAR Variable2 = FILTER(...)
RETURN
IF(
    Variable1 > 0,
    DIVIDE(Variable2, Variable1),
    BLANK()
)
```

### 3. Documentation
```dax
// Comment your complex logic
// This measure calculates retention rate for customer cohorts
Cohort_Retention = 
VAR CohortCustomers = ... // Customers from first purchase month
VAR RetainedCustomers = ... // Customers still active
RETURN
DIVIDE(RetainedCustomers, CohortCustomers)
```

## Tài liệu tham khảo

### Websites
- [DAX Guide](https://dax.guide/) - Complete DAX function reference
- [SQLBI](https://www.sqlbi.com/) - Advanced DAX patterns and articles
- [Microsoft Docs](https://docs.microsoft.com/en-us/dax/) - Official documentation

### Books
- "The Definitive Guide to DAX" - Marco Russo, Alberto Ferrari
- "DAX Patterns" - Marco Russo, Alberto Ferrari

### Tools
- [DAX Studio](https://daxstudio.org/) - For testing and optimizing DAX
- [Tabular Editor](https://tabulareditor.github.io/) - Advanced model editing

## Contributions

Nếu bạn có thêm patterns hoặc improvements, welcome to contribute!

1. Fork repository
2. Thêm examples với comments đầy đủ
3. Test với sample data
4. Submit pull request

---

**Lưu ý:** Các ví dụ này được thiết kế cho mục đích học tập. Trong production, luôn test thoroughly với dữ liệu thực và optimize performance theo requirement cụ thể.