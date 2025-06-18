// MARK: - LowStockAlertView.swift
import SwiftUI

struct LowStockAlertView: View {
    @ObservedObject var notificationManager = NotificationManager.shared
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                if notificationManager.lowStockAlerts.isEmpty {
                    EmptyAlertView()
                } else {
                    List {
                        ForEach(notificationManager.lowStockAlerts.sorted(by: { !$0.isRead && $1.isRead })) { alert in
                            LowStockAlertRowView(alert: alert)
                                .onTapGesture {
                                    notificationManager.markAsRead(alert)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button("삭제") {
                                        notificationManager.dismissAlert(alert)
                                    }
                                    .tint(.red)
                                    
                                    if !alert.isRead {
                                        Button("읽음") {
                                            notificationManager.markAsRead(alert)
                                        }
                                        .tint(.blue)
                                    }
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("재고 알림")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("닫기") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !notificationManager.lowStockAlerts.isEmpty {
                        Button("모두 읽음") {
                            notificationManager.markAllAsRead()
                        }
                    }
                }
            }
        }
    }
}

struct LowStockAlertRowView: View {
    let alert: StockAlert
    @EnvironmentObject var storeManager: StoreManager
    
    var product: Product? {
        storeManager.products.first { $0.id == alert.productId }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // 알림 아이콘
            Image(systemName: alert.alertType.icon)
                .font(.title2)
                .foregroundColor(alert.alertType.color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(alert.productName)
                        .font(.headline)
                        .fontWeight(alert.isRead ? .medium : .bold)
                    
                    Spacer()
                    
                    Text(alert.alertType.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(alert.alertType.color.opacity(0.2))
                        .foregroundColor(alert.alertType.color)
                        .cornerRadius(8)
                }
                
                Text("현재 재고: \(alert.currentStock)개")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text(RelativeDateTimeFormatter().localizedString(for: alert.timestamp, relativeTo: Date()))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if !alert.isRead {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            
            // 빠른 액션 버튼들
            if let product = product {
                VStack(spacing: 8) {
                    Button(action: {
                        var updatedProduct = product
                        updatedProduct.stock += 10
                        storeManager.updateProduct(updatedProduct)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.green)
                    }
                    
                    Button(action: {
                        var updatedProduct = product
                        updatedProduct.stock += 50
                        storeManager.updateProduct(updatedProduct)
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .background(alert.isRead ? Color.clear : Color.blue.opacity(0.05))
        .cornerRadius(8)
    }
}

struct EmptyAlertView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("모든 재고가 충분합니다!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("재고가 10개 미만이 되면\n알림을 받을 수 있습니다.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - 재고 알림 배너 (메인 화면에 표시)
struct LowStockBannerView: View {
    let alerts: [StockAlert]
    let onTap: () -> Void
    
    var body: some View {
        if !alerts.isEmpty {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("재고 부족 알림")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("\(alerts.count)개 상품의 재고 확인이 필요합니다")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
        }
    }
}

// MARK: - 알림 뱃지
struct NotificationBadge: View {
    let count: Int
    
    var body: some View {
        if count > 0 {
            ZStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 20, height: 20)
                
                Text("\(min(count, 99))")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
    }
}
