------------------------------------Clean & Transform Data
--------------- 1. BẢNG marketing

-- Tạo bảng marketing
  
CREATE TABLE marketing (
    date DATE,
    channel VARCHAR(50),
    mkter VARCHAR(50),
    chien_dich VARCHAR(100),
    chi_phi_marketing FLOAT,
    impression FLOAT,
    reach FLOAT,
    click INT,
    share INT,
    cmt INT,
    inbox INT,
    lead_mkt INT,
    don_hang INT,
    doanh_thu FLOAT,
    paid_revenue_1 FLOAT,
    gia_lead FLOAT,
    don_per_lead FLOAT,
    cpm FLOAT,
    cpc FLOAT,
    gia_mess FLOAT,
    me1 FLOAT
);

-- Kiểm tra giá trị NULL
SELECT 
    COUNT(*) AS tong_dong,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS null_date,
    SUM(CASE WHEN channel IS NULL THEN 1 ELSE 0 END) AS null_channel,
    ...
    SUM(CASE WHEN me1 IS NULL THEN 1 ELSE 0 END) AS null_me1
FROM marketing;

-- Xử lý dữ liệu trùng lặp
-- Kiểm tra bản ghi trùng
SELECT *, COUNT(*)
FROM marketing
GROUP BY ...
HAVING COUNT(*) > 1;

-- Xóa bản ghi trùng, giữ lại 1
WITH ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY ... ORDER BY NULL) AS rn
    FROM marketing
)
DELETE FROM marketing
WHERE (các_cột) IN (
    SELECT (các_cột)
    FROM ranked WHERE rn > 1
);

-- Check logic: giá trị âm
SELECT * FROM marketing
WHERE 
    chi_phi_marketing < 0 OR impression < 0 OR ... OR me1 < 0;

-- Tính toán các chỉ số marketing
UPDATE marketing
SET 
    cpc = CASE WHEN click > 0 THEN chi_phi_marketing / click ELSE 0 END,
    cpm = CASE WHEN impression > 0 THEN (chi_phi_marketing / impression) * 1000 ELSE 0 END,
    gia_lead = CASE WHEN lead_mkt > 0 THEN chi_phi_marketing / lead_mkt ELSE 0 END,
    gia_mess = CASE WHEN (cmt + inbox) > 0 THEN chi_phi_marketing / (cmt + inbox) ELSE 0 END,
    don_per_lead = CASE WHEN lead_mkt > 0 THEN don_hang * 1.0 / lead_mkt ELSE 0 END;

--  Gán cờ dữ liệu cần kiểm tra

ALTER TABLE marketing ADD COLUMN valid TEXT;

UPDATE marketing
SET valid = CASE
    WHEN chi_phi_marketing = 0 AND doanh_thu > 0 THEN 'Check'  -- NOTE:CẦN KIỂM TRA LẠI TÍNH HỢP LỆ doanh_thu
    ELSE 'OK'
END;

-- Tách bảng theo trạng thái kiểm tra
CREATE TABLE marketing_ok AS
SELECT * FROM marketing WHERE valid = 'OK';

CREATE TABLE marketing_check AS
SELECT * FROM marketing WHERE valid = 'Check';

--------------- 2. BẢNG sales

-- Tạo bảng sales
CREATE TABLE sales (
    ngay date,
    gio time,
    khach_hang TEXT,
    sdt TEXT,
    channel TEXT,
    chien_dich TEXT,
    content TEXT,
    marketer_2 TEXT,
    type_of_lead TEXT,
    type_of_lead_xac_nhan TEXT,
    sales TEXT,
    so_lan_tuong_tac INTEGER,
    ngay_goi date,  
    trang_thai TEXT,
    level TEXT,
    ngay_hen_goi_lai date,
    close_date date,
    tinh_tp TEXT,
    so_luong_bo_sach INTEGER,
    so_tien_giam_gia NUMERIC,
    tong_tien NUMERIC
);

-- Chuẩn hóa số điện thoại
UPDATE sales
SET sdt = regexp_replace(sdt, '\D', '', 'g')
WHERE sdt IS NOT NULL;

-- Thêm đầu '0' nếu thiếu
UPDATE sales
SET sdt = '0' || right(sdt, 9)
WHERE sdt IS NOT NULL AND (length(sdt) = 9 OR sdt ~ '^84\d{9}$');

-- Kiểm tra null cần thiết
SELECT COUNT(*) AS tong_dong,
       SUM(CASE WHEN sdt IS NULL THEN 1 ELSE 0 END) AS null_sdt,
       ...
FROM sales;

-- Xoá bản ghi thiếu sdt
DELETE FROM sales
WHERE sdt IS NULL;

 -- Loại bỏ bản ghi trùng
SELECT sdt, gio, ngay, COUNT(*)
FROM sales
GROUP BY sdt, ngay, gio
HAVING COUNT(*) > 1;

-- Chuẩn hóa cột text
UPDATE sales
SET khach_hang = initcap(khach_hang);

-- Check logic ngày & dữ liệu âm
-- Ngày chốt trước ngày tạo
SELECT * FROM sales WHERE close_date < ngay;

-- Tiền âm
SELECT * FROM sales WHERE tong_tien < 0 OR so_tien_giam_gia < 0;

-- Fix tiền âm
UPDATE sales
SET so_tien_giam_gia = ABS(so_tien_giam_gia)
WHERE so_tien_giam_gia < 0;

-- Dọn dẹp dữ liệu không rõ thông tin 
DELETE FROM sales
WHERE level IS NULL AND trang_thai IS NULL AND tong_tien = 0;

-- NOTE: Gán "Chưa rõ" nếu còn thiếu, CẦN KIỂM TRA LẠI TÍNH HỢP LỆ
UPDATE sales
SET trang_thai = 'Chưa rõ', level = 'Chưa rõ'
WHERE level IS NULL AND trang_thai IS NULL AND tong_tien > 0;

-- Đồng bộ trang_thai và level
-- Gán level dựa trên trang_thai
UPDATE sales
SET level = CASE trang_thai
    WHEN 'Hủy đơn sau khi chốt' THEN 'L7.2 - Hủy đơn sau khi chốt'
    ...
    ELSE level
END
WHERE level IS NULL AND trang_thai IS NOT NULL;

-- Ngược lại
UPDATE sales
SET trang_thai = CASE level
    WHEN 'L7.2 - Hủy đơn sau khi chốt' THEN 'Hủy đơn sau khi chốt'
    ...
    ELSE trang_thai
END
WHERE trang_thai IS NULL AND level IS NOT NULL;

--------------- 3. BẢNG van_don

 --Tạo bảng van_don
CREATE TABLE van_don (
    stt INT,
    ma_don_hang VARCHAR(50),
    ghi_chu_don_hang TEXT,
    tags_don_hang TEXT,
    nhan_vien_tao_don VARCHAR(100),
    chi_nhanh VARCHAR(100),
    nguon VARCHAR(100),
    ma_van_don VARCHAR(100),
    tinh_trang_goi_hang VARCHAR(100),
    trang_thai_doi_tac VARCHAR(100),
    ly_do_huy_don TEXT,
    ngay_dong_goi TEXT,
    ngay_hen_giao TEXT,
    ngay_xuat_kho TEXT,
    ngay_giao_hang TEXT,
    doi_tac_giao_hang VARCHAR(100),
    dich_vu_giao_hang VARCHAR(100),
    khoi_luong NUMERIC,
    kich_thuoc VARCHAR(50),
    ten_nguoi_nhan VARCHAR(100),
    sdt_nguoi_nhan VARCHAR(20),
    dia_chi_giao_hang TEXT,
    tinh_thanh VARCHAR(100),
    quan_huyen VARCHAR(100),
    phuong_xa VARCHAR(100),
    trang_thai_doi_soat VARCHAR(100),
    tien_khach_phai_tra TEXT,
    khach_hang_da_tra TEXT,
    hinh_thuc_thanh_toan VARCHAR(50),
    tong_tien_thu_ho TEXT,
    phi_van_chuyen TEXT,
    nguoi_tra_phi VARCHAR(50),
    phi_tra_doi_tac TEXT,
    ghi_chu_don_giao TEXT,
    ma_san_pham VARCHAR(100),
    ten_san_pham VARCHAR(255),
    ghi_chu_san_pham TEXT,
    so_luong INT,
    serial VARCHAR(100),
    don_vi_tinh VARCHAR(50),
    don_gia TEXT,
    chiet_khau_san_pham TEXT,
    chiet_khau_tong_don_hang TEXT,
    thue_san_pham TEXT,
    tong_tien_hang TEXT
);

-- Chuyển đổi định dạng ngày giờ
ALTER TABLE van_don
ALTER COLUMN ngay_dong_goi TYPE TIMESTAMP USING TO_TIMESTAMP(ngay_dong_goi, 'DD/MM/YYYY HH24:MI');
-- Lặp lại với các cột ngày khác

--  Chuyển đổi dữ liệu tiền tệ thành số
ALTER TABLE van_don
ALTER COLUMN tien_khach_phai_tra TYPE NUMERIC USING REPLACE(tien_khach_phai_tra, '.', '')::NUMERIC;
-- Các cột tiền tương tự...

-- Chuẩn hóa số điện thoại người nhận
UPDATE van_don
SET sdt_nguoi_nhan = regexp_replace(sdt_nguoi_nhan, '\D', '', 'g');

UPDATE van_don
SET sdt_nguoi_nhan = 
    CASE 
        WHEN sdt_nguoi_nhan ~ '^84\d{9}$' THEN '0' || RIGHT(sdt_nguoi_nhan, 9)
        WHEN sdt_nguoi_nhan ~ '^\d{9}$' THEN '0' || sdt_nguoi_nhan
        ELSE sdt_nguoi_nhan
    END;

-- Kiểm tra và xử lý dữ liệu NULL
SELECT * FROM van_don WHERE ma_don_hang IS NULL;
DELETE FROM van_don WHERE ma_don_hang IS NULL;

-- Kiểm tra null ở cột chính
SELECT 
    COUNT(*) FILTER (WHERE don_gia IS NULL) AS don_gia_null,
    ...
FROM van_don;

-- Tính toán tổng tiền đơn hàng và COD
UPDATE van_don
SET tong_tien_thu_ho = tien_khach_phai_tra - khach_hang_da_tra;

-- Gán phương thức thanh toán
UPDATE van_don
SET hinh_thuc_thanh_toan = 
    CASE 
        WHEN tong_tien_thu_ho = 0 THEN 'Chuyển khoản'
        ELSE 'COD'
    END;

-- Tính tổng tiền hàng
UPDATE van_don
SET tong_tien_hang = 
    (COALESCE(don_gia, 0) * COALESCE(so_luong, 0))
    - COALESCE(chiet_khau_san_pham, 0)
    - COALESCE(chiet_khau_tong_don_hang, 0)
    + COALESCE(thue_san_pham, 0);

-- Chuẩn hóa văn bản
UPDATE van_don
SET 
    nhan_vien_tao_don = initcap(nhan_vien_tao_don),
    ten_nguoi_nhan = initcap(ten_nguoi_nhan);



