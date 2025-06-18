// MARK: - SettingsView.swift (설정)
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var storeManager: StoreManager
    @State private var showingEditStore = false
    
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
                    
                    Button("매장 정보 수정") {
                        showingEditStore = true
                    }
                }
                
                Section("앱 정보") {
                    HStack {
                        Text("버전")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Button("초기 설정으로 돌아가기") {
                        storeManager.isFirstRun = true
                        UserDefaults.standard.removeObject(forKey: "storeInfo")
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("설정")
            .sheet(isPresented: $showingEditStore) {
                EditStoreView()
                    .environmentObject(storeManager)
            }
        }
    }
}
