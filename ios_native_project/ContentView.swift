import SwiftUI

struct ContentView: View {
    @StateObject private var notifManager = NotificationManager.shared
    
    @State private var appTitle: String = "Investing.com"
    @State private var notifBody: String = "+105%, +77%, +31%: Cổ phiếu \"kinh tế thực\" bứt phá khi kết quả Q3 mở rộng đà tăng thị trường"
    @State private var badgeCount: Int = 3
    @State private var delaySeconds: Double = 3
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            // Dark futuristic background
            Color(red: 0.03, green: 0.04, blue: 0.06)
                .ignoresSafeArea()
            
            // Atmospheric glow
            RadialGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.clear]),
                center: .bottom,
                startRadius: 50,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("iOS Thông Báo Demo")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            Text("Mô phỏng & Đẩy thông báo Investing.com")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // PREVIEW BANNER (Identical to screenshot)
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top, spacing: 14) {
                            // Icon with badge
                            ZStack(alignment: .topTrailing) {
                                RoundedRectangle(cornerRadius: 11, style: .continuous)
                                    .fill(Color(white: 0.12))
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        VStack(spacing: 0) {
                                            Text("Investi")
                                                .font(.system(size: 8, weight: .bold))
                                                .foregroundColor(.white)
                                            Path { path in
                                                path.move(to: CGPoint(x: 4, y: 16))
                                                path.addLine(to: CGPoint(x: 14, y: 8))
                                                path.addLine(to: CGPoint(x: 24, y: 12))
                                                path.addLine(to: CGPoint(x: 36, y: 4))
                                            }
                                            .stroke(Color.orange, lineWidth: 2)
                                            .frame(height: 18)
                                        }
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                                
                                // Badge 3
                                Text("\(badgeCount)")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(
                                        Capsule()
                                            .fill(Color(white: 0.18).opacity(0.95))
                                            .overlay(Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1))
                                    )
                                    .offset(x: 6, y: -6)
                            }
                            
                            // Content
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(appTitle)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("09:00")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(Color.white.opacity(0.55))
                                }
                                
                                Text(notifBody)
                                    .font(.system(size: 14.5, weight: .regular))
                                    .lineSpacing(2)
                                    .foregroundColor(Color.white.opacity(0.95))
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color(white: 0.15).opacity(0.85))
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.4), radius: 20, y: 10)
                        )
                    }
                    .padding(.horizontal)
                    
                    // Controls Card
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Cài Đặt Nội Dung")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Tên App:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("App Name", text: $appTitle)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(10)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Nội Dung Thông Báo:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextEditor(text: $notifBody)
                                .frame(height: 70)
                                .padding(6)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Số Badge:")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Stepper("\(badgeCount)", value: $badgeCount, in: 0...99)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Thời Gian Chờ:")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(Int(delaySeconds)) giây")
                                    .font(.body.bold())
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color(white: 0.1).opacity(0.8))
                            .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.white.opacity(0.1), lineWidth: 1))
                    )
                    .padding(.horizontal)
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            if !notifManager.isAuthorized {
                                notifManager.requestAuthorization()
                            }
                            notifManager.scheduleInvestingNotification(
                                title: appTitle,
                                body: notifBody,
                                badgeCount: badgeCount,
                                delaySeconds: delaySeconds
                            )
                            showingAlert = true
                        }) {
                            HStack {
                                Image(systemName: "bell.badge.fill")
                                Text("Gửi Thông Báo Sau \(Int(delaySeconds))s")
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(colors: [Color.orange, Color.red], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.orange.opacity(0.4), radius: 10, y: 4)
                        }
                        
                        Text("Mẹo: Sau khi bấm nút, bạn có thể khóa màn hình hoặc về màn hình chính để thấy thông báo xuất hiện y hệt như hình mẫu!")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Đã Lên Lịch Thông Báo! 🔔"),
                message: Text("Thông báo sẽ xuất hiện trên màn hình sau \(Int(delaySeconds)) giây. Bạn có thể vuốt về Home hoặc tắt màn hình để kiểm tra."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            notifManager.requestAuthorization()
        }
    }
}
