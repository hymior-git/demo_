# Hướng Dẫn Sử Dụng & Xuất File IPA Thông Báo iOS

Bộ mã nguồn này được thiết kế chính xác theo ảnh mẫu thông báo thị trường của **Investing.com** trên iOS:
- Icon ứng dụng Investing.com kèm biểu tượng huy hiệu số thông báo (**Badge `3`**).
- Tiêu đề `Investing.com`, thời gian `09:00`.
- Nội dung: `+105%, +77%, +31%: Cổ phiếu "kinh tế thực" bứt phá khi kết quả Q3 mở rộng đà tăng thị trường`.
- Hiệu ứng kính mờ (Frosted Glass / Backdrop Blur), viền kim loại và hiệu ứng chuông chuẩn iOS.

---

## 📁 Danh Sách File Đã Tạo

1. **`index.html`**: 
   - Ứng dụng mô phỏng giao diện thông báo iOS 18 chân thực 100%.
   - Hỗ trợ đổi tên app, nội dung, badge, tải ảnh icon tùy chỉnh.
   - Phát âm thanh chuông iOS (Web Audio API) & hiệu ứng trượt mượt mà.
   - Nút xuất file ảnh PNG độ nét cao để làm video/bài viết truyền thông.
   - Hỗ trợ **Web Notification** và **PWA** để cài trực tiếp lên iPhone không cần máy tính.
2. **`investing_icon.jpg`**: Icon ứng dụng phong cách Investing.com chế độ Dark Mode sắc nét.
3. **`manifest.json` & `sw.js`**: Cấu hình PWA để đưa ứng dụng ra màn hình chính iPhone.
4. **`ios_native_project/`** (Mã nguồn Swift gốc cho Xcode):
   - `NotificationManager.swift`: Module xử lý `UserNotifications` của Apple (gửi banner, âm thanh, badge).
   - `ContentView.swift`: Giao diện SwiftUI điều khiển gửi thông báo.
   - `NotificationApp.swift`: Điểm khởi chạy app.
   - `Info.plist`: Cấu hình quyền thông báo.
5. **`.github/workflows/build-ipa.yml`**: Kịch bản tự động build file `.ipa` trên đám mây (Cloud CI/CD) hoàn toàn miễn phí.

---

## 🚀 3 Cách Cài Đặt & Sử Dụng Trên iPhone

### Cách 1: Cài đặt ngay lên iPhone qua Safari (Không cần máy tính, không cần tài khoản Apple)
> [!TIP]
> Đây là cách nhanh nhất để có biểu tượng app ngoài màn hình chính iPhone và nhận thông báo:

1. Đưa thư mục này lên GitHub Pages, Vercel hoặc Netlify (hoặc mở liên kết web của bạn).
2. Mở trình duyệt **Safari trên iPhone** và truy cập vào trang web `index.html`.
3. Bấm vào nút **Chia sẻ** (biểu tượng hình vuông có mũi tên trỏ lên `⬆️` ở thanh công cụ dưới cùng).
4. Cuộn xuống và chọn **"Thêm vào Màn hình chính" (Add to Home Screen)**.
5. Đặt tên (ví dụ: *Investing*) và bấm **Thêm (Add)**.
6. Lúc này màn hình iPhone sẽ có biểu tượng app riêng. Khi mở lên, app sẽ chạy toàn màn hình y hệt như một app native cài từ App Store và có thể bật thông báo!

---

### Cách 2: Tự Động Xuất File `.ipa` Qua GitHub Actions (Miễn phí, không cần Mac)
> [!NOTE]
> Hệ điều hành Windows không có trình biên dịch Xcode của Apple. Để tạo file `.ipa` thật 100%, bạn có thể tận dụng máy chủ Mac miễn phí của GitHub:

1. Đẩy (push) toàn bộ thư mục này lên một kho lưu trữ (**repository**) mới trên GitHub của bạn.
2. Vào tab **Actions** trên GitHub repository của bạn.
3. Chọn workflow **"Build iOS IPA"** và bấm **Run workflow**.
4. GitHub sẽ khởi động một máy chủ macOS ảo, tự động chạy Xcode để biên dịch dự án Swift và đóng gói thành file **`NotificationApp.ipa`**.
5. Khi tiến trình hoàn tất (khoảng 2-3 phút), bạn bấm vào bản build vừa xong và tải file `.ipa` trong mục **Artifacts** về máy tính!

---

### Cách 3: Cài File `.ipa` Vào iPhone (Sideloading)
Sau khi có file `.ipa`, vì iOS có cơ chế bảo mật nghiêm ngặt (không thể bấm mở trực tiếp như file APK Android), bạn cài vào iPhone theo 1 trong các cách sau:

- **Sử dụng Sideloadly (Khuyên dùng trên Windows):**
  1. Tải phần mềm **Sideloadly** (miễn phí) trên máy tính Windows.
  2. Cắm cáp kết nối iPhone với máy tính (chọn "Tin cậy máy tính này").
  3. Kéo thả file `NotificationApp.ipa` vào Sideloadly.
  4. Nhập Apple ID của bạn để Sideloadly tự ký chứng chỉ miễn phí và bấm **Start**.
  5. Sau khi cài xong, trên iPhone vào: **Cài đặt > Cài đặt chung > Quản lý VPN & Thiết bị** > Bấm **Tin cậy** chứng chỉ là mở app sử dụng bình thường!

- **Sử dụng AltStore hoặc TrollStore:**
  - Nếu máy bạn đã cài AltStore hoặc TrollStore, chỉ cần gửi file `.ipa` qua AirDrop/Telegram/Zalo rồi chọn "Mở bằng AltStore" để cài đặt trực tiếp.
