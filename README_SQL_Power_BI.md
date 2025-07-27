# Hướng dẫn SQL trong Power BI

## 📚 Tài liệu học tập

Bộ tài liệu này bao gồm 2 file chính để giúp bạn học và sử dụng SQL trong Power BI:

### 1. 📖 `SQL_in_Power_BI_Guide.md` - Hướng dẫn cơ bản
- **Đối tượng**: Người mới bắt đầu với SQL trong Power BI
- **Nội dung**:
  - Kết nối SQL Database trong Power BI
  - Truy vấn SQL cơ bản và nâng cao
  - Tối ưu hiệu suất SQL
  - Tạo View và Stored Procedure
  - Sử dụng SQL trong Power Query
  - Các loại kết nối SQL
  - Best Practices và Troubleshooting

### 2. 📊 `SQL_Power_BI_Examples.md` - Ví dụ thực tế
- **Đối tượng**: Người đã biết cơ bản về SQL
- **Nội dung**:
  - Dữ liệu mẫu chi tiết
  - Truy vấn cho Dashboard
  - Phân tích khách hàng và sản phẩm
  - Time Intelligence với SQL
  - Advanced Analytics (RFM, Chiết khấu)
  - Stored Procedures và Views
  - Kết hợp với DAX

## 🎯 Lộ trình học tập

### Giai đoạn 1: Cơ bản (1-2 tuần)
1. **Đọc**: `SQL_in_Power_BI_Guide.md` từ đầu đến hết
2. **Thực hành**: Kết nối SQL Server với Power BI
3. **Mục tiêu**: Hiểu cách kết nối và truy vấn cơ bản

### Giai đoạn 2: Thực hành (2-3 tuần)
1. **Làm**: Các ví dụ trong `SQL_Power_BI_Examples.md`
2. **Thử nghiệm**: Tạo stored procedures và views
3. **Mục tiêu**: Thành thạo SQL trong Power BI

### Giai đoạn 3: Nâng cao (3-4 tuần)
1. **Học**: Advanced Analytics và Time Intelligence
2. **Áp dụng**: Tối ưu hiệu suất và best practices
3. **Mục tiêu**: Tạo giải pháp SQL hoàn chỉnh

## 🛠️ Công cụ cần thiết

### SQL Server Management Studio (SSMS)
- **Tải về**: [SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
- **Mục đích**: Quản lý và truy vấn SQL Server

### Power BI Desktop
- **Tải về**: [Microsoft Power BI Desktop](https://powerbi.microsoft.com/desktop/)
- **Mục đích**: Kết nối và visualize dữ liệu SQL

### Azure Data Studio (Tùy chọn)
- **Tải về**: [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/)
- **Mục đích**: Quản lý database hiện đại

## 📝 Cách sử dụng tài liệu

### 1. Học lý thuyết
```markdown
1. Đọc từng phần trong SQL_in_Power_BI_Guide.md
2. Ghi chú các khái niệm quan trọng
3. Thực hành ngay sau khi đọc
```

### 2. Thực hành ví dụ
```markdown
1. Tạo database mẫu từ SQL_Power_BI_Examples.md
2. Mở Power BI Desktop và kết nối
3. Copy và paste truy vấn SQL
4. Kiểm tra kết quả và tạo visualization
```

### 3. Áp dụng nâng cao
```markdown
1. Tạo stored procedures và views
2. Tối ưu hiệu suất truy vấn
3. Kết hợp SQL với DAX
4. Tạo dashboard hoàn chỉnh
```

## 🎯 Các kỹ năng cần đạt được

### Kỹ năng cơ bản
- [ ] Kết nối SQL Server với Power BI
- [ ] Viết truy vấn SELECT cơ bản
- [ ] Sử dụng JOIN để kết hợp dữ liệu
- [ ] Tạo GROUP BY và aggregation
- [ ] Sử dụng WHERE để lọc dữ liệu

### Kỹ năng trung cấp
- [ ] Tạo stored procedures với parameters
- [ ] Tạo views cho Power BI
- [ ] Sử dụng CTE và Window Functions
- [ ] Tối ưu hiệu suất với index
- [ ] Xử lý lỗi và debugging

### Kỹ năng nâng cao
- [ ] Time Intelligence với SQL
- [ ] Advanced Analytics (RFM, Cohort)
- [ ] DirectQuery và Live Connection
- [ ] Kết hợp SQL với DAX
- [ ] Performance tuning

## 📚 Tài nguyên bổ sung

### Tài liệu chính thức
- [SQL Server Documentation](https://docs.microsoft.com/en-us/sql/sql-server/)
- [Power BI Documentation](https://docs.microsoft.com/en-us/power-bi/)
- [T-SQL Reference](https://docs.microsoft.com/en-us/sql/t-sql/)

### Khóa học và blog
- [SQLBI](https://www.sqlbi.com/) - Marco Russo & Alberto Ferrari
- [SQL Server Central](https://www.sqlservercentral.com/)
- [Brent Ozar](https://www.brentozar.com/)

### Cộng đồng và diễn đàn
- [Stack Overflow - SQL](https://stackoverflow.com/questions/tagged/sql)
- [SQL Server Community](https://community.microsoft.com/en-us/topics/sql-server)

## 🚀 Best Practices

### 1. Kết nối và bảo mật
```
- Sử dụng Windows Authentication khi có thể
- Tạo dedicated user cho Power BI
- Giới hạn quyền truy cập cần thiết
- Sử dụng connection string an toàn
```

### 2. Tối ưu hiệu suất
```
- Sử dụng index cho các cột truy vấn
- Giới hạn dữ liệu với WHERE clause
- Sử dụng SELECT cụ thể thay vì SELECT *
- Test truy vấn trước khi sử dụng
```

### 3. Quản lý dữ liệu
```
- Tạo views cho truy vấn phức tạp
- Sử dụng stored procedures cho logic nghiệp vụ
- Parameter hóa truy vấn để linh hoạt
- Backup dữ liệu thường xuyên
```

## 🔧 Troubleshooting

### Lỗi kết nối thường gặp
```
1. Kiểm tra thông tin server và database
2. Kiểm tra quyền truy cập user
3. Kiểm tra firewall và network
4. Test kết nối từ SSMS
```

### Lỗi hiệu suất
```
1. Kiểm tra execution plan
2. Tối ưu index cho truy vấn
3. Giới hạn kết quả với TOP/LIMIT
4. Sử dụng WHERE để lọc sớm
```

### Lỗi syntax
```
1. Kiểm tra cú pháp SQL
2. Test truy vấn trong SSMS
3. Kiểm tra version SQL Server
4. Tham khảo documentation
```

## 📊 Ví dụ thực tế

### Dashboard Sales
```sql
-- KPI chính
SELECT 
    SUM(Amount) as TotalRevenue,
    COUNT(OrderID) as TotalOrders,
    AVG(Amount) as AverageOrderValue
FROM Sales
WHERE OrderDate >= '2023-01-01'
```

### Phân tích khách hàng
```sql
-- Top khách hàng
SELECT TOP 10
    c.CustomerID,
    c.FirstName + ' ' + c.LastName as CustomerName,
    SUM(s.Amount) as TotalRevenue
FROM Sales s
INNER JOIN Customer c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalRevenue DESC
```

### Time Intelligence
```sql
-- Tăng trưởng theo tháng
WITH MonthlyRevenue AS (
    SELECT 
        YEAR(OrderDate) as Year,
        MONTH(OrderDate) as Month,
        SUM(Amount) as Revenue
    FROM Sales
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT 
    Year,
    Month,
    Revenue,
    LAG(Revenue) OVER (ORDER BY Year, Month) as PreviousMonth
FROM MonthlyRevenue
```

## 🎯 Tips học tập hiệu quả

### 1. Thực hành thường xuyên
- Tạo database mẫu để thực hành
- Viết truy vấn SQL hàng ngày
- Test các scenario khác nhau

### 2. Học từ lỗi
- Ghi chú các lỗi thường gặp
- Debug và tìm hiểu nguyên nhân
- Tham khảo cộng đồng

### 3. Tối ưu liên tục
- Review và cải thiện truy vấn
- Tối ưu hiệu suất
- Cập nhật best practices

### 4. Tham gia cộng đồng
- Tham gia diễn đàn SQL
- Chia sẻ và học hỏi
- Đọc blog và bài viết chuyên môn

## 📞 Hỗ trợ

Nếu bạn gặp khó khăn trong quá trình học:

1. **Kiểm tra tài liệu**: Đọc lại các phần liên quan
2. **Tìm kiếm**: Sử dụng Google với từ khóa cụ thể
3. **Cộng đồng**: Đặt câu hỏi trên Stack Overflow
4. **Thực hành**: Tạo ví dụ đơn giản để test

## 🎉 Chúc mừng!

Bạn đã có trong tay bộ tài liệu SQL trong Power BI toàn diện. Hãy bắt đầu hành trình học tập và trở thành chuyên gia SQL trong Power BI!

---

**Lưu ý**: SQL trong Power BI là kỹ năng quan trọng cho data analysis. Hãy kiên nhẫn và thực hành thường xuyên để thành thạo!