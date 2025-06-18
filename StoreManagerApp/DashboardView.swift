// MARK: - DashboardView.swift (Purple Theme Applied)
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var storeManager: StoreManager
    @ObservedObject var notificationManager = NotificationManager.shared
    @State private var showingLowStockAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 매장 정보 헤더
                    StoreInfoHeaderView()
                    
                    // 재고 부족 알림 배너
                    LowStockBannerView(alerts: notificationManager.lowStockAlerts) {
                        showingLowStockAlert = true
                    }
                    
                    // 주요 통계
                    StatsOverviewView()
                    
                    // 빠른 액션
                    QuickActionsView()
                    
                    // 최근 활동
                    RecentActivityView()
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.05),
                        Color.pink.opacity(0.03)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationTitle("대시보드")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingLowStockAlert = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.purple.opacity(0.8),
                                            Color.pink.opacity(0.6)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "bell.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                            
                            NotificationBadge(count: notificationManager.unreadCount)
                                .offset(x: 12, y: -12)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingLowStockAlert) {
                LowStockAlertView()
                    .environmentObject(storeManager)
            }
        }
        .onAppear {
            // 앱 시작 시 재고 체크
            notificationManager.checkLowStock(products: storeManager.products)
        }
    }
}

struct StoreInfoHeaderView: View {
    @EnvironmentObject var storeManager: StoreManager
    
    var body: some View {
        VStack(spacing: 12) {
            // 상단 그라데이션 영역
            VStack(spacing: 8) {
                Text(storeManager.storeInfo.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(storeManager.storeInfo.category.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.8),
                        Color.pink.opacity(0.6)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 16)
            )
            
            // 하단 정보 영역
            VStack(spacing: 4) {
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.purple.opacity(0.7))
                    Text("영업시간")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(storeManager.storeInfo.businessHours)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.purple.opacity(0.15),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
    }
}

struct StatsOverviewView: View {
    @EnvironmentObject var storeManager: StoreManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("매장 현황")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                StatCard(
                    title: "총 상품",
                    value: "\(storeManager.products.count)개",
                    icon: "cube.box.fill",
                    color: .purple
                )
                
                StatCard(
                    title: "활성 직원",
                    value: "\(storeManager.getActiveEmployees().count)명",
                    icon: "person.fill",
                    color: .pink
                )
                
                StatCard(
                    title: "재고 부족",
                    value: "\(storeManager.getLowStockProducts().count)개",
                    icon: "exclamationmark.triangle.fill",
                    color: .orange
                )
                
                StatCard(
                    title: "품절 상품",
                    value: "\(storeManager.getOutOfStockProducts().count)개",
                    icon: "xmark.circle.fill",
                    color: .red
                )
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 16) {
            // 그라데이션 아이콘 배경
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            color.opacity(0.8),
                            color.opacity(0.5)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(.white)
                )
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 130)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(
                    color: color.opacity(0.15),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
    }
}

struct QuickActionsView: View {
    @State private var showingAddProduct = false
    @State private var showingProductView = false
    @State private var showingEmployeeView = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("빠른 실행")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            HStack(spacing: 12) {
                QuickActionButton(
                    title: "상품 추가",
                    icon: "plus.circle.fill",
                    color: .purple
                ) {
                    showingAddProduct = true
                }
                
                QuickActionButton(
                    title: "상품 관리",
                    icon: "cube.box.fill",
                    color: .pink
                ) {
                    showingProductView = true
                }
                
                QuickActionButton(
                    title: "직원 관리",
                    icon: "person.fill",
                    color: Color.purple.opacity(0.7)
                ) {
                    showingEmployeeView = true
                }
            }
        }
        .sheet(isPresented: $showingAddProduct) {
            AddProductView()
        }
        .sheet(isPresented: $showingProductView) {
            ProductView()
        }
        .sheet(isPresented: $showingEmployeeView) {
            EmployeeView()
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // 그라데이션 원형 버튼
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color.opacity(0.8),
                                color.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: icon)
                            .font(.title3)
                            .foregroundColor(.white)
                    )
                    .shadow(
                        color: color.opacity(0.3),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: color.opacity(0.1),
                        radius: 6,
                        x: 0,
                        y: 3
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RecentActivityView: View {
    @EnvironmentObject var storeManager: StoreManager
    @ObservedObject var notificationManager = NotificationManager.shared
    
    var recentLowStockProducts: [Product] {
        storeManager.getLowStockProducts().prefix(3).map { $0 }
    }
    
    // 카테고리별 아이콘 함수 추가
    private func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "커피": return "cup.and.saucer.fill"
        case "음료": return "wineglass.fill"
        case "디저트": return "birthday.cake.fill"
        case "브런치": return "fork.knife"
        case "원두": return "leaf.fill"
        case "굿즈": return "bag.fill"
        default: return "cube.box.fill"
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("최근 활동")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            VStack(spacing: 12) {
                // 최근 재고 부족 상품들
                if !recentLowStockProducts.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Image(systemName: "exclamationmark")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                )
                            
                            Text("재고 부족 상품")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        
                        ForEach(recentLowStockProducts, id: \.id) { product in
                            HStack(spacing: 12) {
                                // 상품 아이콘
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.purple.opacity(0.7),
                                                Color.pink.opacity(0.5)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Image(systemName: iconForCategory(product.category))
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    )
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(product.name)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    Text("재고: \(product.stock)개")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    var updatedProduct = product
                                    updatedProduct.stock += 10
                                    storeManager.updateProduct(updatedProduct)
                                }) {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 28, height: 28)
                                        .overlay(
                                            Image(systemName: "plus")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        )
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.orange.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
                
                // 오늘의 요약
                HStack(spacing: 16) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.purple.opacity(0.8),
                                    Color.pink.opacity(0.6)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "chart.bar.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("오늘의 요약")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        Text("• 신규 알림: \(notificationManager.unreadCount)개")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("• 재고 확인 필요: \(storeManager.getLowStockProducts().count)개")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(
                            color: Color.purple.opacity(0.1),
                            radius: 6,
                            x: 0,
                            y: 3
                        )
                )
            }
        }
    }
}
