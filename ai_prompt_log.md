# AI Prompt Log — HealthSync

## 1. Tìm hiểu về trạng thái vòng đời

**Prompt đã sử dụng:** Vì sao dùng `is_active` kiểu BOOLEAN để quản lý vòng đời lịch hẹn là chưa phù hợp? Có thể thay thế bằng cách nào trong MySQL?

**Điều rút ra:** BOOLEAN chỉ biểu diễn hai trạng thái, trong khi quy trình có năm trạng thái. ENUM có thể giới hạn trạng thái vào danh sách giá trị đã quy định. Khi hệ thống cần trạng thái thay đổi thường xuyên hoặc cấu hình linh hoạt, có thể cân nhắc bảng trạng thái riêng.

## 2. Lựa chọn kiểu dữ liệu tiền tệ

**Prompt đã sử dụng:** Nên dùng FLOAT, DOUBLE hay DECIMAL để lưu tiền cọc và phí phạt? Vì sao?

**Điều rút ra:** DECIMAL là kiểu số thập phân chính xác, phù hợp cho dữ liệu tiền tệ. FLOAT và DOUBLE dùng biểu diễn dấu phẩy động nhị phân nên có thể phát sinh sai số khi tính toán.

## 3. Sửa cấu trúc bảng hiện có

**Prompt đã sử dụng:** Cú pháp ALTER TABLE để xóa cột cũ và thêm cột status kiểu ENUM trong MySQL là gì?

**Điều rút ra:** ALTER TABLE có thể thay đổi cấu trúc bảng mà không cần xóa và tạo lại toàn bộ bảng. Tuy nhiên, cần sao lưu và kiểm tra dữ liệu trước khi thay đổi schema.

## 4. Khóa ngoại và tính toàn vẹn dữ liệu

**Prompt đã sử dụng:** ON DELETE RESTRICT và ON DELETE CASCADE khác nhau như thế nào khi thiết kế khóa ngoại giữa Appointments và Prescriptions?

**Điều rút ra:** RESTRICT ngăn xóa bản ghi cha khi còn bản ghi con tham chiếu; CASCADE tự động xóa bản ghi con. Với hồ sơ khám bệnh, cần cân nhắc bảo toàn lịch sử nên không chọn CASCADE một cách máy móc.

## 5. Kiểm thử quy trình nghiệp vụ

**Prompt đã sử dụng:** Làm thế nào truy vấn JOIN giữa Appointments và Prescriptions để tìm các lịch đã hoàn tất và có đơn thuốc?

**Điều rút ra:** JOIN giúp kết hợp dữ liệu theo khóa liên kết. Điều kiện `status = 'COMPLETED'` lọc lịch hẹn đã hoàn tất. Khóa ngoại đảm bảo đơn thuốc tham chiếu lịch hẹn tồn tại, nhưng để ngăn kê đơn cho lịch chưa hoàn tất ở tầng cơ sở dữ liệu cần thêm TRIGGER hoặc cơ chế kiểm soát tương đương.

## Tự đánh giá

AI được sử dụng như công cụ tham khảo cú pháp và phản biện thiết kế. Người học cần tự chạy script, xem kết quả truy vấn, đối chiếu với yêu cầu nghiệp vụ và chỉnh sửa nếu phát hiện lỗi. Nhật ký này cần được điều chỉnh cho đúng với các câu hỏi và thao tác thực tế đã thực hiện.
