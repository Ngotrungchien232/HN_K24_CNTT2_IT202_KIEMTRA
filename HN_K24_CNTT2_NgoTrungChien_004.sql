create database thiketthucmon;
use thiketthucmon;

-- PHẦN 1: TẠO BẢNG VÀ CƠ SỞ DỮ LIỆU MẪU 
create table readers (
    reader_id int auto_increment primary key,
    full_name varchar(50) not null,
    email varchar(50) not null unique, -- email không trùng
    phone_number varchar(10) not null unique,
    created_at date not null default (curdate())-- ngày tạo tài khoản
);

create table membership_details (
    card_number varchar(10) primary key,
    reader_id int not null unique,
    ranks varchar(20) not null,-- hạng thẻ
    expiry_date date not null,-- ngày hết hạn
    citizen_id varchar(12) not null unique, -- giống như căn cước của mỗi người 
    foreign key (reader_id) references readers(reader_id)
);

create table categories (
    category_id int auto_increment primary key,
    category_name varchar(20) not null,
    descriptions varchar(255) not null
);

create table books (
    book_id int auto_increment primary key,
    -- mã sách
    title varchar(50) not null,
    -- tên sách
    author varchar(50) not null,
    -- tác giả
    category_id int not null,
    -- mã danh mục
    price decimal(10,2) not null check (price > 0),
    -- giá sách > 0
    stock_quantity int not null check (stock_quantity >= 0),
    -- số lượng tồn kho
    foreign key (category_id) references categories(category_id)
);

create table loan_records (
    loan_id int primary key,
    reader_id int not null,
    book_id int not null,
    borrow_date date not null,-- ngày mượn
    due_date date not null,-- ngày dự kiến trả
    return_date date,-- ngày trả thực tế
    check (due_date > borrow_date),-- ngày trả phải sau ngày mượn
    foreign key (reader_id) references readers(reader_id),-- khóa ngoại độc giả
    foreign key (book_id) references books(book_id)
  
);

insert into readers values
-- vì em để auto tự động tăng id mà k chỉ rõ cột add luôn cả bảng lên id ở đây để null nhưng thật chất vẫn là sinh id tự động 
(null,'nguyen van a','anv@gmail.com','0901234567','2022-01-15'),
(null,'tran thi b','btt@gmail.com','0912345678','2022-05-20'),
(null,'le van c','cle@yahoo.com','0922334455','2023-02-10'),
(null,'pham minh d','dpham@hotmail.com','0933445566','2023-11-05'),
(null,'hoang anh e','ehoang@gmail.com','0944556677','2024-01-12');

-- thêm dữ liệu độc giả
insert into membership_details values
('card001',1,'standard','2025-01-15','123456789012'),
('card002',2,'vip','2025-05-20','234567890123'),
('card003',3,'standard','2024-02-10','345678901234'),
('card004',4,'vip','2025-11-05','456789012345'),
('card005',5,'standard','2026-01-12','567890123456');

-- thêm dữ liệu thẻ thành viên
insert into categories values
(null,'it','sach cntt'),
(null,'kinh te','sach kinh doanh'),
(null,'van hoc','sach van hoc'),
(null,'ngoai ngu','sach ngoai ngu'),
(null,'lich su','sach lich su');

-- thêm danh mục sách
insert into books values
(null,'clean code','robert c martin',1,450000,10),
(null,'dac nhan tam','dale carnegie',2,150000,50),
(null,'harry potter 1','j k rowling',3,250000,5),
(null,'ielts reading','cambridge',4,180000,0),
(null,'dai viet su ky','le van huu',5,300000,20);

-- thêm sách
insert into loan_records values
-- còn null ở đây là người dùng độc giả của id 3,4,5 chưa trả lên giá trị ở đây sẽ là null 
(101,1,1,'2023-11-15','2023-11-22','2023-11-20'),
(102,2,2,'2023-12-01','2023-12-08','2023-12-05'),
(103,1,3,'2024-01-10','2024-01-17',null),
(104,3,4,'2023-05-20','2023-05-27',null),
(105,4,1,'2024-01-18','2024-01-25',null);

-- thêm hồ sơ mượn trả
update loan_records lr
join books b on lr.book_id = b.book_id
join categories c on b.category_id = c.category_id
set lr.due_date = date_add(lr.due_date, interval 7 day)
where c.category_name = 'van hoc'
and lr.return_date is null;
-- gia hạn 7 ngày cho sách văn học chưa trả

-- xóa sách sau 10/2023
delete from loan_records
where return_date is not null and borrow_date < '2023-10-01';

-- PHẦN 2: TRUY VẤN DỮ LIỆU CƠ BẢN 
-- câu 1
select b.book_id, b.title, b.price
from books b
join categories c on b.category_id = c.category_id
where c.category_name = 'it'
and b.price > 200000;

-- câu 2
select reader_id, full_name, email
from readers
where year(created_at) = 2022 and email like  '%@gmail.com';

-- câu 3
select book_id, title, price
from books
order by price desc
limit 5 offset 2;

-- PHẦN 3: TRUY VẤN NÂNG CAO 
-- cÂU 2
select c.category_name, sum(b.stock_quantity) total_stock
from categories c
join books b on c.category_id = b.category_id
group by c.category_id, c.category_name
having sum(b.stock_quantity) > 10;

-- cÂU 3: 
select r.full_name
from readers r
join membership_details m on r.reader_id = m.reader_id
where m.ranks = 'vip'
and r.reader_id not in (
    select lr.reader_id
    from loan_records lr
    join books b on lr.book_id = b.book_id
    where b.price > 300000
);


 -- pHẦN 4: INDEX VÀ VIEW
 -- câu 1
create index idx_loan_dates
on loan_records (borrow_date, return_date);
-- câu 2
create view vw_overdue_loans as
select lr.loan_id, r.full_name, b.title, lr.borrow_date, lr.due_date
from loan_records lr
join readers r on lr.reader_id = r.reader_id
join books b on lr.book_id = b.book_id
where lr.return_date is null
and curdate() > lr.due_date;

-- phần 5
-- câu 1
delimiter $$
create trigger trg_after_loan_insert
after insert on loan_records
for each row
begin
    update books
    set stock_quantity = stock_quantity - 1
    where book_id = new.book_id;
end$$

-- câu 2
create trigger trg_prevent_delete_active_reader
before delete on readers
for each row
begin
    if exists (
        select 1
        from loan_records
        where reader_id = old.reader_id
        and return_date is null
    ) then
        signal sqlstate '45000'
        set message_text = 'doc gia van dang muon sach';
    end if;
end$$

-- Phần 6: STORED PROCEDURE
-- CÂU 1
delimiter $$
create procedure sp_check_availability(
    in p_book_id int,
    out p_message varchar(50)
)
