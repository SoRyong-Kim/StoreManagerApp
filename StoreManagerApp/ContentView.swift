// MARK: - ContentView.swift (메인 앱 진입점)
import SwiftUI

struct ContentView: View {
    @StateObject private var storeManager = StoreManager()
    @State private var showingSampleDataAlert = false
    
    var body: some View {
        Group {
            if storeManager.isFirstRun {
                WelcomeView()
                    .environmentObject(storeManager)
            } else {
                MainTabView()
                    .environmentObject(storeManager)
            }
        }
        .onAppear {
            // 앱 시작 시 샘플 데이터 확인
            checkForSampleData()
        }
    }
    
    private func checkForSampleData() {
        // 모든 데이터가 비어있으면 샘플 데이터 로드 제안
        if storeManager.storeInfo.name.isEmpty &&
           storeManager.employees.isEmpty &&
           storeManager.products.isEmpty {
            showingSampleDataAlert = true
        }
    }
}
