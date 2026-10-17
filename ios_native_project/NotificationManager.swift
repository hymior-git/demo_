import Foundation
import UserNotifications
import UIKit

/// Quản lý thông báo cục bộ (Local Notifications) trên iOS
class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    @Published var isAuthorized: Bool = false
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        checkAuthorization()
    }
    
    /// Yêu cầu cấp quyền gửi thông báo từ người dùng (Alert, Badge, Sound)
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
                if let error = error {
                    print("Lỗi cấp quyền thông báo: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Kiểm tra trạng thái cấp quyền hiện tại
    func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = (settings.authorizationStatus == .authorized)
            }
        }
    }
    
    /// Tạo và kích hoạt thông báo giống hệt hình ảnh Investing.com
    /// - Parameters:
    ///   - title: Tiêu đề (mặc định: Investing.com)
    ///   - body: Nội dung thị trường
    ///   - badgeCount: Số thông báo (mặc định: 3 như trong hình)
    ///   - delaySeconds: Thời gian chờ trước khi hiện thông báo (giây)
    func scheduleInvestingNotification(
        title: String = "Investing.com",
        body: String = "+105%, +77%, +31%: Cổ phiếu \"kinh tế thực\" bứt phá khi kết quả Q3 mở rộng đà tăng thị trường",
        badgeCount: Int = 3,
        delaySeconds: Double = 5
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = NSNumber(value: badgeCount)
        content.sound = UNNotificationSound.default
        
        // Thêm thông tin mở rộng (UserInfo) nếu cần điều hướng vào ứng dụng
        content.userInfo = [
            "article_id": "market_q3_rally_2026",
            "source": "Investing.com"
        ]
        
        // Trigger hẹn giờ (tối thiểu 1 giây)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(delaySeconds, 1), repeats: false)
        let request = UNNotificationRequest(
            identifier: "investing_alert_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Lỗi gửi thông báo: \(error.localizedDescription)")
            } else {
                print("Đã lên lịch thông báo thành công sau \(delaySeconds)s")
            }
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    // Cho phép hiển thị banner thông báo ngay cả khi người dùng đang mở ứng dụng (Foreground)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Hiển thị banner trên đầu màn hình và phát chuông
        completionHandler([.banner, .sound, .badge, .list])
    }
    
    // Bắt sự kiện khi người dùng bấm vào thông báo
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        print("Người dùng đã nhấn vào thông báo: \(userInfo)")
        completionHandler()
    }
}
