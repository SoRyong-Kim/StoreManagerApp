// MARK: - SettingsView.swift (Purple Theme Applied)
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var storeManager: StoreManager
    @State private var showingEditStore = false
    @State private var showingResetAlert = false
    @State private var showingSampleDataAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 헤더 섹션
                    VStack(spacing: 16) {
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
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "gearshape.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            )
                            .shadow(
                                color: Color.purple.opacity(0.3),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                        
                        Text("설정")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 20)
                    
                    // 매장 정보 섹션
                    VStack(spacing: 16) {
                        SettingsSectionHeaderView(title: "매장 정보", icon: "storefront")
                        
                        VStack(spacing: 12) {
                            SettingsInfoRow(
                                title: "매장명",
                                value: storeManager.storeInfo.name,
                                icon: "storefront"
                            )
                            
                            SettingsInfoRow(
                                title: "업종",
                                value: storeManager.storeInfo.category.rawValue,
                                icon: "tag.fill"
                            )
                            
                            SettingsInfoRow(
                                title: "주소",
                                value: storeManager.storeInfo.address,
                                icon: "location.fill"
                            )
                            
                            SettingsActionButton(
                                title: "매장 정보 수정",
                                icon: "pencil.circle.fill",
                                color: .purple,
                                action: {
                                    showingEditStore = true
                                }
                            )
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(
                                    color: Color.purple.opacity(0.1),
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                        )
                    }
                    
                    // 데이터 관리 섹션
                    VStack(spacing: 16) {
                        SettingsSectionHeaderView(title: "데이터 관리", icon: "externaldrive.fill")
                        
                        VStack(spacing: 12) {
                            SettingsInfoRow(
                                title: "등록된 직원",
                                value: "\(storeManager.employees.count)명",
                                icon: "person.fill"
                            )
                            
                            SettingsInfoRow(
                                title: "등록된 상품",
                                value: "\(storeManager.products.count)개",
                                icon: "cube.box.fill"
                            )
                            
                            Divider()
                                .background(Color.purple.opacity(0.2))
                            
                            SettingsActionButton(
                                title: "샘플 데이터 불러오기",
                                icon: "arrow.down.circle.fill",
                                color: .green,
                                action: {
                                    showingSampleDataAlert = true
                                }
                            )
                            
                            SettingsActionButton(
                                title: "모든 데이터 초기화",
                                icon: "trash.circle.fill",
                                color: .red,
                                action: {
                                    showingResetAlert = true
                                }
                            )
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(
                                    color: Color.purple.opacity(0.1),
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                        )
                    }
                    
                    // 앱 정보 섹션
                    VStack(spacing: 16) {
                        SettingsSectionHeaderView(title: "앱 정보", icon: "info.circle.fill")
                        
                        VStack(spacing: 12) {
                            SettingsInfoRow(
                                title: "버전",
                                value: "1.0.0",
                                icon: "app.badge.fill"
                            )
                            
                            SettingsInfoRow(
                                title: "개발자",
                                value: "StoreManager Team",
                                icon: "person.2.fill"
                            )
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(
                                    color: Color.purple.opacity(0.1),
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                        )
                    }
                    
                    // 시연 도구 섹션
                    VStack(spacing: 16) {
                        SettingsSectionHeaderView(title: "시연 도구", icon: "theatermasks.fill")
                        
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Circle()
                                        .fill(Color.orange.opacity(0.1))
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Image(systemName: "info.circle.fill")
                                                .font(.caption)
                                                .foregroundColor(.orange)
                                        )
                                    
                                    Text("시연용 기능")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                                
                                Text("프레젠테이션이나 데모를 위한 도구들입니다.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 32)
                            }
                            
                            Divider()
                                .background(Color.purple.opacity(0.2))
                            
                            SettingsActionButton(
                                title: "초기 설정으로 돌아가기",
                                icon: "arrow.clockwise.circle.fill",
                                color: .orange,
                                action: {
                                    storeManager.isFirstRun = true
                                }
                            )
                            
                            SettingsActionButton(
                                title: "완전 초기화 (처음부터 시작)",
                                icon: "exclamationmark.triangle.fill",
                                color: .red,
                                action: {
                                    UserDefaults.standard.removeObject(forKey: "storeInfo")
                                    UserDefaults.standard.removeObject(forKey: "employees")
                                    UserDefaults.standard.removeObject(forKey: "products")
                                    
                                    storeManager.storeInfo = StoreInfo()
                                    storeManager.employees = []
                                    storeManager.products = []
                                    storeManager.isFirstRun = true
                                }
                            )
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(
                                    color: Color.purple.opacity(0.1),
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                        )
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
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
            .navigationBarHidden(true)
            .sheet(isPresented: $showingEditStore) {
                EditStoreView()
                    .environmentObject(storeManager)
            }
            .alert("샘플 데이터 불러오기", isPresented: $showingSampleDataAlert) {
                Button("취소", role: .cancel) { }
                Button("불러오기", role: .destructive) {
                    storeManager.resetToSampleData()
                }
            } message: {
                Text("현재 데이터가 모두 삭제되고 샘플 데이터로 교체됩니다. 계속하시겠습니까?")
            }
            .alert("데이터 초기화", isPresented: $showingResetAlert) {
                Button("취소", role: .cancel) { }
                Button("초기화", role: .destructive) {
                    UserDefaults.standard.removeObject(forKey: "employees")
                    UserDefaults.standard.removeObject(forKey: "products")
                    
                    storeManager.employees = []
                    storeManager.products = []
                }
            } message: {
                Text("모든 직원과 상품 데이터가 삭제됩니다. 이 작업은 되돌릴 수 없습니다.")
            }
        }
    }
}

// MARK: - Supporting Views for Settings
struct SettingsSectionHeaderView: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
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
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundColor(.white)
                )
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

struct SettingsInfoRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.purple.opacity(0.1))
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundColor(.purple)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct SettingsActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
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
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: icon)
                            .font(.caption)
                            .foregroundColor(.white)
                    )
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(color.opacity(0.7))
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
