# Consistency Report — HealthSync

Qua đối chiếu quy trình đặt lịch và khám bệnh với cơ sở dữ liệu cũ, có ba điểm vênh nghiêm trọng:

**1. Trạng thái lịch hẹn không phản ánh được quy trình nghiệp vụ.** Bảng `Appointments` chỉ có cột `is_active` kiểu Boolean, nên chỉ biểu diễn được hai trạng thái đúng/sai. Trong khi đó, quy trình cần phân biệt `PENDING`, `CONFIRMED`, `CHECKED_IN`, `COMPLETED` và `CANCELLED`. Thiết kế mới thay cột này bằng `status` kiểu `ENUM`, giúp giới hạn các giá trị hợp lệ và hỗ trợ theo dõi vòng đời lịch hẹn.

**2. Thiếu dữ liệu tài chính và thông tin hủy lịch.** Bảng cũ không có `deposit_amount`, `penalty_fee` và `cancel_reason`. Vì vậy, hệ thống không thể xác định tiền cọc, ghi nhận khoản phạt khi hủy hoặc giải thích lý do hủy. Thiết kế mới dùng `DECIMAL(12,2)` cho các khoản tiền để tránh sai số làm tròn thường gặp với số dấu phẩy động; đồng thời bổ sung ràng buộc kiểm tra số tiền không âm và phí phạt không vượt tiền cọc.

**3. Không có nơi lưu đơn thuốc.** Quy trình yêu cầu bác sĩ kê đơn khi lịch hẹn hoàn tất, nhưng thiết kế cũ không có bảng `Prescriptions`. Bảng mới lưu nội dung đơn thuốc, ngày kê và khóa ngoại `appointment_id` tham chiếu lịch hẹn. Ràng buộc `UNIQUE` hiện tại quy định mỗi lịch hẹn có tối đa một đơn thuốc. Nhờ đó, cấu trúc dữ liệu phù hợp hơn với quy trình nghiệp vụ và hỗ trợ truy vấn đối soát.
