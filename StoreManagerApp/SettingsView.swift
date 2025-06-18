// MARK: - SettingsView.swift
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var storeManager: StoreManager
    @State private var showingEditStore = false
    @State private var showingResetAlert = false
    @State private var showingSampleDataAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section("매장 정보") {
                    HStack {
                        Text("매장명")
                        Spacer()
                        Text(storeManager.storeInfo.name)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("업종")
                        Spacer()
                        Text(storeManager.storeInfo.category.rawValue)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("주소")
                        Spacer()
                        Text(storeManager.storeInfo.address)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    Button("매장 정보 수정") {
                        showingEditStore = true
                    }
                    .foregroundColor(.blue)
                }
                
                Section("데이터 관리") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("등록된 직원")
                            Spacer()
                            Text("\(storeManager.employees.count)명")
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("등록된 상품")
                            Spacer()
                            Text("\(storeManager.products.count)개")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button("샘플 데이터 불러오기") {
                        showingSampleDataAlert = true
                    }
                    .foregroundColor(.green)
                    
                    Button("모든 데이터 초기화") {
                        showingResetAlert = true
                    }
                    .foregroundColor(.red)
                }
                
                Section("앱 정보") {
                    HStack {
                        Text("버전")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("개발자")
                        Spacer()
                        Text("StoreManager Team")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("시연 도구") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("시연용 기능")
                            .font(.headline)
                        Text("프레젠테이션이나 데모를 위한 도구들입니다.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button("초기 설정으로 돌아가기") {
                        storeManager.isFirstRun = true
                        // 데이터는 유지하고 초기 화면만 보여줌
                    }
                    .foregroundColor(.orange)
                    
                    Button("완전 초기화 (처음부터 시작)") {
                        // 모든 데이터 삭제 후 처음부터
                        UserDefaults.standard.removeObject(forKey: "storeInfo")
                        UserDefaults.standard.removeObject(forKey: "employees")
                        UserDefaults.standard.removeObject(forKey: "products")
                        
                        storeManager.storeInfo = StoreInfo()
                        storeManager.employees = []
                        storeManager.products = []
                        storeManager.isFirstRun = true
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("설정")
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
