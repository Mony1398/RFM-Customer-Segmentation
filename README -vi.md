# 📊 Phân tích phân khúc khách hàng theo mô hình RFM

## 🔎 Giới thiệu
Dự án này áp dụng mô hình **RFM (Recency, Frequency, Monetary)** để phân tích hành vi khách hàng.  
Kết quả phân tích giúp phân nhóm khách hàng thành các nhóm như **VIP, Trung thành, Sắp rời bỏ, Đã rời bỏ** nhằm hỗ trợ doanh nghiệp tối ưu hóa marketing và giữ chân khách hàng.  

Bộ dữ liệu gồm hơn **113.800 khách hàng** với tổng doanh thu **2,39 tỷ USD** tính đến ngày 01-09-2022.  

## 🛠 Công cụ & Kỹ năng
- **SQL (MySQL)** → viết truy vấn phân nhóm khách hàng dựa trên IQR (Interquartile Range)  
- **Power BI** → trực quan hóa kết quả phân tích bằng dashboard  
- **Python** (tùy chọn) → tiền xử lý dữ liệu & phân tích bổ sung  

## 📂 Cấu trúc dự án
/report/ → Báo cáo PDF đầy đủ
/src/ → Script SQL, code xử lý dữ liệu
/images/ → Hình ảnh dashboard, biểu đồ

## 📄 Báo cáo
👉 [Xem toàn bộ báo cáo (PDF)](report/Bao-cao-phan-tich-khach-hang-dua-tren-mo-hinh-RFM.pdf)

## 📸 Dashboard
*(chèn hình Power BI dashboard tại đây)*  
Ví dụ:  
![Dashboard](images/dashboard.png)

## 🚀 Phát hiện chính
- **Khách hàng sắp rời bỏ**: chiếm ~28% số lượng và 714M USD doanh thu → rủi ro lớn nhất, cần ưu tiên giữ chân.  
- **Khách hàng VIP**: đóng góp ~25% doanh thu với chỉ 16% số khách, ARPU rất cao → cần chăm sóc cá nhân hóa.  
- **Khách vãng lai & đã rời bỏ**: vẫn đóng góp gần 660M USD → có tiềm năng tái kích hoạt.  
- Nhóm **RFM 344** và **RFM 444** nổi bật về giá trị và hành vi.  

## 💡 Cách tiếp cận SQL
Thay vì chia nhóm bằng **N-tile** (chia đều số lượng khách hàng), dự án này sử dụng **IQR (Interquartile Range)** để xác định ngưỡng.  
Điều này giúp:  
- Các khách hàng có hành vi tương đồng được xếp cùng nhóm.  
- Giảm ảnh hưởng của ngoại lệ (outliers).  
- Kết quả phản ánh thực tế hơn.  

---

👤 Tác giả: **Nguyễn Hoàng Phương Linh**
