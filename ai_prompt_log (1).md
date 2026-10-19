# AI Prompt Log — AutoRide

## 1. Phân tích Data Gaps
**Prompt:** Với bảng Rentals chỉ có trạng thái VARCHAR và không có trường tiền cọc, phí trễ, phí hư hỏng, những bước nào trong quy trình thuê-trả xe chưa thể ghi nhận?

**Điều rút ra:** Cần đối chiếu từng bước và nhánh rẽ nghiệp vụ với cột/bảng dữ liệu. Thiết kế cũ không lưu được khoản khấu trừ và biên bản kiểm tra.

## 2. Kiểu dữ liệu tiền tệ
**Prompt:** Vì sao nên dùng DECIMAL(10,2) thay vì FLOAT cho tiền cọc, phí trễ và phí sửa chữa?

**Điều rút ra:** DECIMAL biểu diễn số thập phân chính xác phù hợp với tiền. FLOAT có thể có sai số do cách biểu diễn số dấu phẩy động.

## 3. Quan hệ Rentals – Inspections
**Prompt:** Nên thiết kế quan hệ 1-1 hay 1-N giữa hợp đồng thuê xe và biên bản kiểm tra?

**Điều rút ra:** Nếu mỗi hợp đồng chỉ có một biên bản thì có thể đặt UNIQUE(rental_id). Nếu cần kiểm tra lúc giao xe và lúc nhận xe, hoặc ghi nhận nhiều lần kiểm tra, quan hệ 1-N linh hoạt hơn. Script mẫu chọn 1-N.

## 4. Khóa ngoại và xóa dữ liệu
**Prompt:** ON DELETE RESTRICT giúp gì cho quan hệ Inspections và Rentals?

**Điều rút ra:** RESTRICT ngăn xóa hợp đồng khi vẫn có biên bản kiểm tra tham chiếu, giúp giữ tính toàn vẹn lịch sử. Cần cân nhắc chính sách lưu trữ dữ liệu trước khi chọn hành vi xóa.

## 5. NULL trong phép tính hoàn tiền
**Prompt:** Làm sao xử lý NULL khi tính tiền hoàn lại bằng security_deposit - late_fee - damage_fee?

**Điều rút ra:** Nếu một toán hạng là NULL, phép trừ có thể trả về NULL. Dùng COALESCE để thay NULL bằng 0; đồng thời thiết kế NOT NULL và DEFAULT 0 để hạn chế tình huống này.

## 6. Ngăn kiểm tra xe trước khi nhận xe
**Prompt:** Làm thế nào ngăn tạo biên bản kiểm tra khi hợp đồng vẫn BOOKED?

**Điều rút ra:** Có thể dùng TRIGGER BEFORE INSERT trên Inspections để kiểm tra trạng thái hợp đồng được tham chiếu và từ chối nếu trạng thái chưa phù hợp. Cần kiểm thử trigger trên phiên bản MySQL đang dùng.

## Tự đánh giá
Nhật ký này là mẫu tham khảo. Người học cần sửa lại để phản ánh đúng các prompt đã hỏi, câu trả lời đã nhận và kết quả tự chạy thử trên MySQL Workbench.
