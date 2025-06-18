import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var lowStockAlerts: [StockAlert] = []
    @Published var showingLowStockAlert = false
    
    private init() {
        requestNotificationPermission()
        loadAlerts()
    }
    
    // MARK: - 알림 권한 요청
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("알림 권한이 허용되었습니다.")
            } else {
                print("알림 권한이 거부되었습니다.")
            }
        }
    }
    
    // MARK: - 재고 부족 체크 및 알림
    func checkLowStock(products: [Product]) {
        let currentLowStockProducts = products.filter { $0.stock < 10 }
        
        // 새로운 재고 부족 상품들 확인
        for product in currentLowStockProducts {
            if !lowStockAlerts.contains(where: { $0.productId == product.id }) {
                let alert = StockAlert(
                    productId: product.id,
                    productName: product.name,
                    currentStock: product.stock,
                    alertType: product.stock == 0 ? .outOfStock : .lowStock
                )
                addAlert(alert)
                
                // 로컬 알림 발송
                scheduleLocalNotification(for: alert)
            } else {
                // 기존 알림 업데이트
                updateAlert(productId: product.id, currentStock: product.stock)
            }
        }
        
        // 재고가 회복된 상품들의 알림 제거
        lowStockAlerts.removeAll { alert in
            !currentLowStockProducts.contains { $0.id == alert.productId }
        }
        
        saveAlerts()
    }
    
    // MARK: - 알림 추가
    private func addAlert(_ alert: StockAlert) {
        lowStockAlerts.append(alert)
        showingLowStockAlert = true
    }
    
    // MARK: - 알림 업데이트
    private func updateAlert(productId: UUID, currentStock: Int) {
        if let index = lowStockAlerts.firstIndex(where: { $0.productId == productId }) {
            lowStockAlerts[index].currentStock = currentStock
            lowStockAlerts[index].alertType = currentStock == 0 ? .outOfStock : .lowStock
            lowStockAlerts[index].timestamp = Date()
        }
    }
    
    // MARK: - 로컬 알림 스케줄링
    private func scheduleLocalNotification(for alert: StockAlert) {
        let content = UNMutableNotificationContent()
        content.title = "재고 부족 알림"
        
        switch alert.alertType {
        case .outOfStock:
            content.body = "\(alert.productName)이(가) 품절되었습니다!"
        case .lowStock:
            content.body = "\(alert.productName) 재고가 \(alert.currentStock)개 남았습니다. 보충이 필요합니다."
        }
        
        content.sound = .default
        content.badge = NSNumber(value: lowStockAlerts.count)
        
        // 즉시 알림
        let request = UNNotificationRequest(
            identifier: "lowStock_\(alert.productId)",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - 알림 읽음 처리
    func markAsRead(_ alert: StockAlert) {
        if let index = lowStockAlerts.firstIndex(where: { $0.id == alert.id }) {
            lowStockAlerts[index].isRead = true
            saveAlerts()
        }
    }
    
    // MARK: - 알림 삭제
    func dismissAlert(_ alert: StockAlert) {
        lowStockAlerts.removeAll { $0.id == alert.id }
        saveAlerts()
        
        // 로컬 알림도 제거
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["lowStock_\(alert.productId)"])
    }
    
    // MARK: - 모든 알림 읽음 처리
    func markAllAsRead() {
        for index in lowStockAlerts.indices {
            lowStockAlerts[index].isRead = true
        }
        saveAlerts()
    }
    
    // MARK: - 읽지 않은 알림 개수
    var unreadCount: Int {
        lowStockAlerts.filter { !$0.isRead }.count
    }
    
    // MARK: - 데이터 저장/로드
    private func saveAlerts() {
        if let encoded = try? JSONEncoder().encode(lowStockAlerts) {
            UserDefaults.standard.set(encoded, forKey: "lowStockAlerts")
        }
    }
    
    private func loadAlerts() {
        if let data = UserDefaults.standard.data(forKey: "lowStockAlerts"),
           let decoded = try? JSONDecoder().decode([StockAlert].self, from: data) {
            lowStockAlerts = decoded
        }
    }
}

// MARK: - StockAlert 모델
struct StockAlert: Identifiable, Codable {
    let id = UUID()
    let productId: UUID
    var productName: String
    var currentStock: Int
    var alertType: AlertType
    var timestamp: Date = Date()
    var isRead: Bool = false
    
    enum AlertType: String, Codable {
        case lowStock = "재고 부족"
        case outOfStock = "품절"
        
        var color: Color {
            switch self {
            case .lowStock: return .orange
            case .outOfStock: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .lowStock: return "exclamationmark.triangle.fill"
            case .outOfStock: return "xmark.circle.fill"
            }
        }
    }
}
