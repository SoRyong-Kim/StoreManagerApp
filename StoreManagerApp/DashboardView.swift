// MARK: - DashboardView.swift (대시보드)
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var storeManager: StoreManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 통계 카드들
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatCard(
                            title: "총 직원 수",
                            value: "\(storeManager.employees.count)명",
                            icon: "person.2.fill",
                            color: .blue
                        )
                        
                        StatCard(
                            title: "등록 상품",
                            value: "\(storeManager.products.count)개",
                            icon: "cube.box.fill",
                            color: .green
                        )
                        
                        StatCard(
                            title: "오늘 매출",
                            value: "₩0",
                            icon: "chart.bar.fill",
                            color: .purple
                        )
                    }
                    
                    // 매장 정보 카드
                    VStack(alignment: .leading, spacing: 16) {
                        Text("매장 정보")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 12) {
                            InfoRow(label: "매장명", value: storeManager.storeInfo.name)
                            InfoRow(label: "업종", value: storeManager.storeInfo.category.rawValue)
                            InfoRow(label: "주소", value: storeManager.storeInfo.address)
                            InfoRow(label: "영업시간", value: storeManager.storeInfo.businessHours)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .padding()
            }
            .navigationTitle("대시보드")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}
