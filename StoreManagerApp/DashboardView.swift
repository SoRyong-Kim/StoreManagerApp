// MARK: - DashboardView.swift (알림 기능 포함)
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
            .background(Color(.systemGroupedBackground))
            .navigationTitle("대시보드")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingLowStockAlert = true
                    }) {
                        ZStack {
                            Image(systemName: "bell")
                                .font(.title2)
                            
                            NotificationBadge(count: notificationManager.unreadCount)
                                .offset(x: 10, y: -10)
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
        VStack(spacing: 8) {
            Text(storeManager.storeInfo.name)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(storeManager.storeInfo.category.rawValue)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("영업시간: \(storeManager.storeInfo.businessHours)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.1), lineWidth: 1)
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
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                StatCard(
                    title: "총 상품",
                    value: "\(storeManager.products.count)개",
                    icon: "cube.box.fill",
                    color: .blue
                )
                
                StatCard(
                    title: "활성 직원",
                    value: "\(storeManager.getActiveEmployees().count)명",
                    icon: "person.fill",
                    color: .green
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
        VStack(spacing: 12) {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
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
        .frame(height: 120)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
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
                Spacer()
            }
            
            HStack(spacing: 12) {
                QuickActionButton(
                    title: "상품 추가",
                    icon: "plus.circle.fill",
                    color: .blue
                ) {
                    showingAddProduct = true
                }
                
                QuickActionButton(
                    title: "상품 관리",
                    icon: "cube.box.fill",
                    color: .green
                ) {
                    showingProductView = true
                }
                
                QuickActionButton(
                    title: "직원 관리",
                    icon: "person.fill",
                    color: .purple
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
            VStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: icon)
                            .font(.title3)
                            .foregroundColor(.white)
                    )
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 90)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(color.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(color.opacity(0.1), lineWidth: 1)
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
                Spacer()
            }
            
            VStack(spacing: 12) {
                // 최근 재고 부족 상품들
                if !recentLowStockProducts.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("재고 부족 상품")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Spacer()
                        }
                        
                        ForEach(recentLowStockProducts, id: \.id) { product in
                            HStack {
                                // 기본 아이콘 사용
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Image(systemName: iconForCategory(product.category))
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    )
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(product.name)
                                        .font(.caption)
                                        .fontWeight(.medium)
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
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                }
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // 오늘의 요약
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("오늘의 요약")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("• 신규 알림: \(notificationManager.unreadCount)개")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("• 재고 확인 필요: \(storeManager.getLowStockProducts().count)개")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chart.bar.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }
}
