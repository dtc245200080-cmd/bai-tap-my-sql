# ERD – Activity Diagram Mapping: AutoRide

Đối chiếu quy trình thuê và trả xe với cơ sở dữ liệu cũ cho thấy ba khoảng trống chính. Thứ nhất, cột `status` dạng `VARCHAR` không giới hạn các giá trị trạng thái, nên có thể lưu dữ liệu sai quy trình. Thiết kế mới dùng `ENUM` gồm `BOOKED`, `ACTIVE`, `COMPLETED` và `CANCELLED`.

Thứ hai, bảng `Rentals` thiếu `security_deposit`, `late_fee` và `damage_fee`. Nếu không lưu riêng phí phạt trễ và phí sửa chữa, hệ thống không thể tính chính xác tiền hoàn lại, đối soát doanh thu hoặc giải thích khoản khấu trừ cho khách. Các cột tiền dùng `DECIMAL(10,2)` để tránh sai số dấu phẩy động. Công thức hoàn tiền là tiền cọc trừ phí trễ và phí hư hỏng.

Thứ ba, hệ thống cũ không có bảng `Inspections` để ghi ngày kiểm tra, người kiểm tra và mô tả hư hỏng. Tách bảng này giúp lưu vết biên bản độc lập và có thể mở rộng nhiều lần kiểm tra cho một hợp đồng. Khóa ngoại `ON DELETE RESTRICT` ngăn xóa hợp đồng đang được biên bản tham chiếu. Vì vậy, ERD mới bao quát được nhánh kiểm tra xe và tính phí khi trả xe.
