// MARK: - ContentView.swift (메인 앱 진입점)
import SwiftUI

struct ContentView: View {
    @StateObject private var storeManager = StoreManager()
    
    var body: some View {
        Group {
            if storeManager.isFirstRun {
                InitialSetupView()
                    .environmentObject(storeManager)
            } else {
                MainTabView()
                    .environmentObject(storeManager)
            }
        }
    }
}
