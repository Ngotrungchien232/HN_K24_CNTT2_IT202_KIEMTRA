-- tạo cơ sở dữ liệu mới 
create database ThiKetThucMon;
use ThiKetThucMon;

-- PHẦN 1: TẠO BẢNG THEO ĐỀ BÀI YÊU CẦU 
-- 1. bảng độc giả 
create table Readers (
	reader_id int auto_increment primary key,
    full_name varchar(50) not null,
    email varchar(50) not null unique,
    phone_number varchar(10) not null unique,
    created_at date not null -- ngày tạo tài khoản của người dùng 
);
-- 2. bảng chi tiết thẻ thành viên 
create table Membership_Details (
	card_number varchar(10)  primary key,
    reader_id int , -- là khóa ngoại 
    ranks varchar(20) not null, -- LƯU Ý LÀ THÊM S ĐỂ TRÁNH TRÙNG VỚI CÁC BIẾN CÓ TRONG MY SQL
    expiry_date date not null, -- hạn sử dụng tài khoản 
    citizen_id int not null unique, -- gần như căn cước định danh 
    -- tiến hành viết khóa phụ 
     foreign key (reader_id) references Readers(reader_id)
);
-- 3. bảng danh mục 
create table Categories (
	category_id int auto_increment primary key,
    category_name varchar(20) not null,
    descriptions varchar(255) not null
);
-- 4. bảng sách 
create table Books (
	book_id int auto_increment primary key,
    title varchar(20) not null, -- tên sách 
    author varchar(50) not null, -- tên tác giả 
    category_id int , -- mã danh mục là khóa phụ
    price decimal(10,2) not null check(price > 0),
    stock_quantity int not null check(stock_quantity >= 0),
    -- tiến hành viết khóa phụ
    foreign key (category_id) references Categories(category_id)
);
-- 5. bảng hồ sơ mượn trả sách 
create table Loan_Records (
	loan_id int not null primary key, -- mã phiếu mượn 
    reader_id int not null,
    book_id int not null, 
    borrow_date date not null, -- ngày mượn 
    due_date date not null, -- đến hạn 
    return_date date, -- ngày trả sách , có thể là k thèm chả luôn lên k có not null
    -- tiến hành viết khóa phụ 
    foreign key (reader_id) references Readers(reader_id),
    foreign key (book_id) references Books(book_id)
);

-- THÊM DỮ LIỆU MẪU CHO CÁC BẢNG 
-- 1. bảng dành cho độc giả ( người dùng ) 
insert into Readers (full_name, email, phone_number, created_at) values
('Nguyen Van A', 'anv@gmail.com', '901234567', '1/15/2022'),
('Tran Thi B', 'btt@gmail.com', '912345678', '5/20/2022'),
('Le Van C', 'cle@yahoo.com', '922334455', '2/10/2023'),
('Pham Minh D', 'dpham@hotmail.com', '933445566', '11/5/2023'),
('Hoang Anh E', 'ehoang@gmail.com', '944556677', '1/12/2024');
-- 2. bảng chi tiết thẻ thành viên
insert into Membership_Details (card_number, reader_id, ranks, exprity_date, citizen_id) values
('CARD-001', '1', 'Standard', '1/15/2025', '123456789'),
('CARD-002', '2', 'VIP', '5/20/2025', '234567890'),
('CARD-003', '3', 'Standard', '2/10/2024', '345678901'),
('CARD-004', '4', 'VIP', '11/5/2025', '456789012'),
('CARD-005', '5', 'Standard', '1/12/2026', '567890123');
-- 3. bảng danh mục sách 
insert into Categories (category_name, descriptions) values
('IT', 'Sách về công nghệ thông tin và lập trình'),
('Kinh Te', 'Sách kinh doanh, tài chính, khởi nghiệp'),
('Van Hoc', 'Tiểu thuyết, truyện ngắn, thơ'),
('Ngoai Ngu', 'Sách học tiếng Anh, Nhật, Hàn'),
('Lich Su', 'Sách nghiên cứu lịch sử, văn hóa');
-- 4. bảng sách 
insert into Books (title, author, category_id,  price, stock_quantity) values
('Clean Code', 'Robert C. Martin', '1', '450000', '10'),
('Dac Nhan Tam', 'Dale Carnegie', '2', '150000', '50'),
('Harry Potter 1', 'J.K. Rowling', '3', '250000', '5'),
('IELTS Reading', 'Cambridge', '4', '180000', '0'),
('Dai Viet Su Ky', 'Le Van Huu','5', '300000', '20');
-- 5. bảng hồ sơ mượn trả 
insert into Loan_Records (loan_id, reader_id, book_id, borrow_date, due_date, return_date) values
('101', '1', '1', '11/15/2023', '11/22/2023', '11/20/2023'),
('102', '2', '2', '12/1/2023', '12/8/2023', '12/5/2023'),
('103', '1', '3', '1/10/2024', '1/17/2024' ),
('104', '3', '4', '5/20/2023', '5/27/2023'),
('105', '4', '1', '1/18/2024', '1/25/2024');

-- PHẦN 2: 
-- câu 1: 
























PHẦN 1: THIẾT KẾ CSDL & CHÈN DỮ LIỆU (25 ĐIỂM)
1. Thiết kế bảng (15 điểm): Dựa vào mô tả nghiệp vụ dưới đây, anh/chị hãy viết câu lệnh DDL để tạo CSDL với 5 bảng. Yêu cầu xác định đúng kiểu dữ liệu và thiết lập đầy đủ các ràng buộc (Khóa chính, Khóa ngoại, Check, Unique, Default).
  - Bảng 1: Readers (Độc giả)
    - Gồm: Mã độc giả (PK), Họ tên, Email (Unique), Số điện thoại, Ngày tạo tài khoản (Default là ngày hiện tại).
  - Bảng 2: Membership_Details (Chi tiết thẻ thành viên)
    - Gồm: Mã thẻ (PK), Mã độc giả (FK - Unique), Hạng thẻ (Ví dụ: 'Standard', 'VIP'), Ngày hết hạn thẻ, Số CCCD (Unique).
    - Lưu ý: Mỗi độc giả chỉ có duy nhất một hồ sơ thẻ thành viên chi tiết.
  - Bảng 3: Categories (Danh mục sách)
    - Gồm: Mã danh mục (PK), Tên danh mục (Ví dụ: 'IT', 'Kinh tế', 'Văn học'), Mô tả.
  - Bảng 4: Books (Sách) - Sản phẩm
    - Gồm: Mã sách (PK), Tên sách, Tác giả, Mã danh mục (FK), Giá sách (>0), Số lượng tồn kho (>=0).
  - Bảng 5: Loan_Records (Hồ sơ mượn trả)
    - Gồm: Mã phiếu mượn (PK), Mã độc giả (FK), Mã sách (FK), Ngày mượn, Ngày dự kiến trả, Ngày thực trả (cho phép NULL nếu chưa trả).
    - Ràng buộc: Ngày dự kiến trả phải sau Ngày mượn.
2. DML (15 điểm): Viết Script chèn dữ liệu:

---
  1. Bảng Độc giả (Readers)
This content is only supported in a Lark Docs
  2. Bảng Chi tiết thẻ thành viên (Membership_Details)
This content is only supported in a Lark Docs
  3. Bảng Danh mục sách (Categories)
This content is only supported in a Lark Docs
  4. Bảng Sách (Books)
This content is only supported in a Lark Docs
  5. Bảng Hồ sơ mượn trả (Loan_Records)
This content is only supported in a Lark Docs
  - Viết script INSERT để chèn dữ liệu mẫu vào 5 bảng (Sử dụng dữ liệu mẫu ở trên hoặc tự thêm sao cho đủ tối thiểu 5 bản ghi mỗi bảng).
  - Gia hạn thêm 7 ngày cho due_date (Ngày dự kiến trả) đối với tất cả các phiếu mượn sách thuộc danh mục 'Van Hoc' mà chưa được trả (return_date IS NULL).
  - Xóa các hồ sơ mượn trả (Loan_Records) đã hoàn tất trả sách (return_date KHÔNG NULL) và có ngày mượn trước tháng 10/2023.

---
PHẦN 2: TRUY VẤN DỮ LIỆU CƠ BẢN (15 ĐIỂM)
- Câu 1 (5đ): Viết câu lệnh lấy ra danh sách các cuốn sách (book_id, title, price) thuộc danh mục 'IT' và có giá bán lớn hơn 200.000 VNĐ.
- Câu 2 (5đ): Lấy ra thông tin độc giả (reader_id, full_name, email) đã đăng ký tài khoản trong năm 2022 và có địa chỉ Email thuộc tên miền '@gmail.com'.
- Câu 3 (5đ): Hiển thị danh sách 5 cuốn sách có giá trị cao nhất, sắp xếp theo thứ tự giảm dần. Yêu cầu sử dụng LIMIT và OFFSET để bỏ qua 2 cuốn sách đắt nhất đầu tiên (lấy từ cuốn thứ 3 đến thứ 7).

---
PHẦN 3: TRUY VẤN DỮ LIỆU NÂNG CAO (20 ĐIỂM)
- Câu 1 (6đ): Viết truy vấn để hiển thị các thông tin gômg: Mã phiếu, Tên độc giả, Tên sách, Ngày mượn, Ngày trả. Chỉ hiển thị các đơn mượn chưa trả sách.
- Câu 2 (7đ): Tính tổng số lượng sách đang tồn kho (stock_quantity) của từng danh mục (category_name). Chỉ hiển thị những danh mục có tổng tồn kho lớn hơn 10.
- Câu 3 (7đ): Tìm ra thông tin độc giả (full_name) có hạng thẻ là 'VIP' nhưng chưa từng mượn cuốn sách nào có giá trị lớn hơn 300.000 VNĐ.

---
PHẦN 4: INDEX VÀ VIEW (10 ĐIỂM)
- Câu 1 (5đ): Tạo một Composite Index đặt tên là idx_loan_dates trên bảng Loan_Records bao gồm hai cột: borrow_date và return_date để tăng tốc độ truy vấn lịch sử mượn.
- Câu 2 (5đ): Tạo một View tên là vw_overdue_loans hiển thị: Mã phiếu, Tên độc giả, Tên sách, Ngày mượn, Ngày dự kiến trả. View này chỉ chứa các bản ghi mà ngày hiện tại (CURDATE) đã vượt quá ngày dự kiến trả và sách chưa được trả.

---
PHẦN 5: TRIGGER (10 ĐIỂM)
- Câu 1 (5đ): Viết Trigger trg_after_loan_insert. Khi một phiếu mượn mới được thêm vào bảng Loan_Records, hãy tự động trừ số lượng tồn kho (stock_quantity) của cuốn sách tương ứng trong bảng Books đi 1 đơn vị.
- Câu 2 (5đ): Viết Trigger trg_prevent_delete_active_reader. Ngăn chặn việc xóa thông tin độc giả trong bảng Readers nếu độc giả đó vẫn còn sách đang mượn (tức là tồn tại bản ghi trong Loan_Records mà return_date là NULL). Gợi ý: Sử dụng SIGNAL SQLSTATE.

---
PHẦN 6: STORED PROCEDURE (20 ĐIỂM)
- Câu 1 (10đ): Viết Procedure sp_check_availability nhận vào Mã sách (p_book_id). Procedure trả về thông báo qua tham số OUT p_message:
  - 'Hết hàng' nếu tồn kho = 0.
  - 'Sắp hết' nếu 0 < tồn kho <= 5.
  - 'Còn hàng' nếu tồn kho > 5.
- Câu 2 (10đ): Viết Procedure sp_return_book_transaction để xử lý trả sách an toàn với Transaction:
  - Input: p_loan_id.
  - B1: Bắt đầu giao dịch (START TRANSACTION).
  - B2: Kiểm tra xem phiếu mượn này đã được trả chưa. Nếu return_date không NULL, Rollback và báo lỗi "Sách đã trả rồi".
  - B3: Cập nhật ngày trả (return_date) là ngày hiện tại trong bảng Loan_Records.
  - B4: Cộng lại số lượng tồn kho (stock_quantity) lên 1 trong bảng Books (dựa vào book_id lấy từ phiếu mượn).
  - B5: COMMIT nếu thành công. ROLLBACK nếu có lỗi xảy ra.

---
