# TeenUp_Test
Tổng quan
Dự án này phân tích hiệu quả hoạt động trong quý 3/2020 của TeenUp – một thương hiệu giáo dục sáng tạo dành cho giới trẻ. Báo cáo được xây dựng bằng Power BI, dựa trên dữ liệu từ các mảng marketing, bán hàng và vận chuyển, nhằm hỗ trợ CEO đưa ra quyết định chiến lược.

🧹 Xử lý dữ liệu
Dữ liệu gốc gồm 3 bảng:

Marketing: thông tin chi tiết về từng chiến dịch quảng cáo, ngân sách, kênh, chỉ số CR, CPA...

Sales: dữ liệu đơn hàng, doanh thu, sản phẩm

Vận đơn: trạng thái giao hàng, thời gian giao, mã vận đơn

Các bước xử lý chính:

Chuẩn hóa định dạng ngày/giờ

Chuyển đổi dữ liệu định tính thành định lượng

Loại bỏ trùng lặp, làm sạch dữ liệu thiếu

Nối bảng qua các khóa chung (order_id, product_id, v.v.)

🔍 Các phát hiện chính
1. Hiệu quả Marketing
Facebook chiếm gần như toàn bộ doanh thu (~3 tỷ), Google mang về ~300 triệu, TikTok gần như không có đơn

Chỉ một chiến dịch (CVS) hiệu quả; nhiều chiến dịch khác (Brand, Mess...) CR = 0, CPA rất cao

2. Nhân sự Marketing
Hiệu suất phân hóa mạnh: Top 1 (Ngọc Ngô) đạt >1.2 tỷ (30%), gấp 2.5 lần người thứ 2

Nhiều nhân sự doanh thu dưới 20 triệu hoặc không có đơn

Nguy cơ phụ thuộc cá nhân cao, thiếu cơ chế mentoring & phân bổ KPI hợp lý

3. Giao hàng và Logistics
Tỷ lệ giao thành công toàn hệ thống: 88% (~711 đơn thất bại)

Một số SKU chính (bộ sách TeenUp) dưới trung bình (87–88%)

Sản phẩm nhỏ như sách lẻ, quà tặng, cốc nguyệt san có tỷ lệ giao 100%

✅ Khuyến nghị chiến lược
Ngắn hạn

Cắt ngân sách các chiến dịch không hiệu quả

Ưu tiên Facebook CVS và Google Search

Trung hạn

Thiết lập hệ thống dashboard theo dõi hiệu suất theo thời gian thực

Triển khai thử nghiệm chiến dịch A/B định kỳ hàng tuần

Dài hạn

Phát triển hệ sinh thái nội dung đa kênh (FB, Google, TikTok, Zalo)

Áp dụng phân bổ ngân sách linh hoạt theo hiệu suất

Quản trị rủi ro

Xây dựng ít nhất 1 kênh marketing không phụ thuộc vào ads trả phí (email, cộng đồng, influencer...)

Chuẩn hóa quy trình từ top performer để đào tạo lại đội ngũ

🎯 Mục tiêu
Giúp TeenUp vận hành hiệu quả hơn dựa trên dữ liệu, giảm phụ thuộc vào một kênh hay cá nhân, đồng thời phát triển bền vững và linh hoạt hơn trong môi trường marketing thay đổi nhanh chóng.
