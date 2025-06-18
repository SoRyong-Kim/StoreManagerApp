// MARK: - MainTabView.swift (메인 탭 화면)
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var storeManager: StoreManager
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("대시보드")
                }
            
            EmployeeView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("직원 관리")
                }
            
            ProductView()
                .tabItem {
                    Image(systemName: "cube.box.fill")
                    Text("상품 관리")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("설정")
                }
        }
        .environmentObject(storeManager)
    }
}
