// MARK: - Updated DashboardView.swift (기존 DashboardView.swift 교체)
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
                    InfoSection(title: "매장 정보") {
                        VStack(spacing: 12) {
                            InfoRow(label: "매장명", value: storeManager.storeInfo.name)
                            InfoRow(label: "업종", value: storeManager.storeInfo.category.rawValue)
                            InfoRow(label: "주소", value: storeManager.storeInfo.address)
                            InfoRow(label: "영업시간", value: storeManager.storeInfo.businessHours)
                        }
                    }
                    
                    // 최근 활동 섹션 (추가 기능)
                    InfoSection(title: "최근 활동") {
                        VStack(spacing: 8) {
                            if storeManager.employees.isEmpty && storeManager.products.isEmpty {
                                Text("아직 등록된 데이터가 없습니다")
                                    .foregroundColor(.secondary)
                                    .italic()
                            } else {
                                if !storeManager.employees.isEmpty {
                                    HStack {
                                        Image(systemName: "person.badge.plus")
                                            .foregroundColor(.blue)
                                        Text("최근 등록된 직원: \(storeManager.employees.last?.name ?? "없음")")
                                        Spacer()
                                    }
                                }
                                
                                if !storeManager.products.isEmpty {
                                    HStack {
                                        Image(systemName: "cube.box")
                                            .foregroundColor(.green)
                                        Text("최근 등록된 상품: \(storeManager.products.last?.name ?? "없음")")
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("대시보드")
        }
    }
}
