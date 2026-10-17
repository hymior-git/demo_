import SwiftUI

enum InputField: Hashable {
    case appName
    case notifBody
    case badge
}

struct ContentView: View {
    @StateObject private var notifManager = NotificationManager.shared
    @FocusState private var focusedField: InputField?
    
    @State private var appTitle: String = "Investing.com"
    @State private var notifBody: String = "+105%, +77%, +31%: Cổ phiếu \"kinh tế thực\" bứt phá khi kết quả Q3 mở rộng đà tăng thị trường"
    @State private var badgeCount: Int = 3
    @State private var delaySeconds: Double = 3
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            // Nền tối thích ứng toàn bộ viền màn hình (Full Safe Area)
            Color(red: 0.04, green: 0.05, blue: 0.08)
                .ignoresSafeArea(.all)
            
            // Hiệu ứng ánh sáng khí quyển vũ trụ bao phủ full màn hình
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.08, green: 0.25, blue: 0.55).opacity(0.35),
                    Color.clear
                ]),
                center: .bottom,
                startRadius: 80,
                endRadius: 550
            )
            .ignoresSafeArea(.all)
            
            // Chạm bất kỳ đâu ngoài ô nhập liệu để ẩn bàn phím ngay lập tức
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header thích ứng mọi dòng iPhone (Dynamic Island, Tai thỏ, iPhone SE)
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Thông Báo iOS")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("Tùy biến & Bắn thông báo Investing.com")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        // Nút ẩn bàn phím nhanh trên Header nếu bàn phím đang mở
                        if focusedField != nil {
                            Button(action: { hideKeyboard() }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "keyboard.chevron.compact.down")
                                    Text("Ẩn phím")
                                }
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.orange)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.12))
                                .cornerRadius(12)
                            }
                            .transition(.opacity.combined(with: .scale))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    
                    // PREVIEW BANNER THÔNG BÁO (Co giãn full màn hình tự động theo dòng máy)
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top, spacing: 13) {
                            // Icon với Badge 3 chuẩn iOS
                            ZStack(alignment: .topTrailing) {
                                RoundedRectangle(cornerRadius: 11, style: .continuous)
                                    .fill(Color(white: 0.1))
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        VStack(spacing: 1) {
                                            Text("Investi")
                                                .font(.system(size: 7.5, weight: .bold))
                                                .foregroundColor(.white)
                                            Path { path in
                                                path.move(to: CGPoint(x: 4, y: 15))
                                                path.addLine(to: CGPoint(x: 14, y: 7))
                                                path.addLine(to: CGPoint(x: 23, y: 11))
                                                path.addLine(to: CGPoint(x: 36, y: 3))
                                            }
                                            .stroke(Color.orange, lineWidth: 2)
                                            .frame(height: 16)
                                        }
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                                    .shadow(color: Color.black.opacity(0.3), radius: 4, y: 2)
                                
                                // Badge số lượng thông báo (ẩn nếu là 0)
                                if badgeCount > 0 {
                                    Text("\(badgeCount)")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 2)
                                        .background(
                                            Capsule()
                                                .fill(Color(white: 0.18).opacity(0.95))
                                                .overlay(Capsule().stroke(Color.white.opacity(0.25), lineWidth: 1))
                                        )
                                        .offset(x: 6, y: -6)
                                }
                            }
                            
                            // Nội dung chữ của thông báo
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(appTitle.isEmpty ? "Investing.com" : appTitle)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("09:00")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(Color.white.opacity(0.52))
                                }
                                
                                Text(notifBody.isEmpty ? "Nội dung thông báo..." : notifBody)
                                    .font(.system(size: 14.2, weight: .regular))
                                    .lineSpacing(2)
                                    .foregroundColor(Color.white.opacity(0.94))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color(white: 0.14).opacity(0.85))
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .stroke(Color.white.opacity(0.14), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.45), radius: 25, y: 10)
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    
                    // KHỐI ĐIỀU KHIỂN & NHẬP NỘI DUNG
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Cài Đặt Nội Dung")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        // Tên App
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Tên Ứng Dụng")
                                .font(.system(size: 12.5, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.6))
                            
                            TextField("Ví dụ: Investing.com", text: $appTitle)
                                .focused($focusedField, equals: .appName)
                                .submitLabel(.done)
                                .onSubmit { hideKeyboard() }
                                .padding(12)
                                .background(Color.black.opacity(0.35))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(focusedField == .appName ? Color.orange : Color.white.opacity(0.12), lineWidth: 1)
                                )
                                .foregroundColor(.white)
                        }
                        
                        // Nội Dung Thông Báo
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Nội Dung Thông Báo")
                                    .font(.system(size: 12.5, weight: .medium))
                                    .foregroundColor(Color.white.opacity(0.6))
                                Spacer()
                                if focusedField == .notifBody {
                                    Button("Xong") { hideKeyboard() }
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.orange)
                                }
                            }
                            
                            ZStack(alignment: .topLeading) {
                                if notifBody.isEmpty {
                                    Text("Nhập nội dung thông báo...")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.white.opacity(0.3))
                                        .padding(.top, 14)
                                        .padding(.leading, 12)
                                }
                                
                                TextEditor(text: $notifBody)
                                    .focused($focusedField, equals: .notifBody)
                                    .frame(minHeight: 75)
                                    .padding(8)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                    .foregroundColor(.white)
                            }
                            .background(Color.black.opacity(0.35))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(focusedField == .notifBody ? Color.orange : Color.white.opacity(0.12), lineWidth: 1)
                            )
                        }
                        
                        // Số Badge & Thời Gian Chờ
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Số Badge")
                                    .font(.system(size: 12.5, weight: .medium))
                                    .foregroundColor(Color.white.opacity(0.6))
                                
                                Stepper("\(badgeCount)", value: $badgeCount, in: 0...99)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 4)
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Hẹn Giờ Gửi")
                                    .font(.system(size: 12.5, weight: .medium))
                                    .foregroundColor(Color.white.opacity(0.6))
                                
                                HStack {
                                    Text("\(Int(delaySeconds)) giây")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.orange)
                                    Spacer()
                                    Button(action: {
                                        delaySeconds = (delaySeconds == 3) ? 5 : (delaySeconds == 5 ? 10 : 3)
                                    }) {
                                        Text("Đổi")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.white.opacity(0.15))
                                            .cornerRadius(8)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color(white: 0.1).opacity(0.85))
                            .overlay(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    
                    // NÚT BẤM KÍCH HOẠT THÔNG BÁO
                    VStack(spacing: 12) {
                        Button(action: {
                            hideKeyboard()
                            if !notifManager.isAuthorized {
                                notifManager.requestAuthorization()
                            }
                            notifManager.scheduleInvestingNotification(
                                title: appTitle.isEmpty ? "Investing.com" : appTitle,
                                body: notifBody,
                                badgeCount: badgeCount,
                                delaySeconds: delaySeconds
                            )
                            showingAlert = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "bell.badge.fill")
                                    .font(.system(size: 17))
                                Text("Gửi Thông Báo Sau \(Int(delaySeconds))s")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 1.0, green: 0.58, blue: 0.0), Color(red: 1.0, green: 0.35, blue: 0.0)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.orange.opacity(0.35), radius: 12, y: 5)
                        }
                        
                        Text("💡 Mẹo: Bấm nút xong, bạn có thể vuốt về màn hình chính hoặc khóa màn hình để thấy thông báo xuất hiện chuẩn iOS!")
                            .font(.system(size: 11.5, weight: .regular))
                            .foregroundColor(Color.white.opacity(0.55))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                }
                .padding(.bottom, 40)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        // Thanh công cụ trên bàn phím (Keyboard Toolbar) với nút "Xong" tiện lợi
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(action: { hideKeyboard() }) {
                    HStack(spacing: 4) {
                        Text("Xong")
                            .font(.system(size: 15, weight: .bold))
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                    .foregroundColor(.orange)
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Đã Lên Lịch Thông Báo! 🔔"),
                message: Text("Thông báo sẽ xuất hiện sau \(Int(delaySeconds)) giây. Bạn có thể vuốt về Home hoặc khóa màn hình để kiểm tra."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            notifManager.requestAuthorization()
        }
    }
    
    /// Hàm ẩn bàn phím ngay lập tức
    private func hideKeyboard() {
        focusedField = nil
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
