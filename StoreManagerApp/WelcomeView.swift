import Foundation
import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var storeManager: StoreManager
    @State private var showingSampleDataAlert = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // 로고와 제목
            VStack(spacing: 20) {
                Image(systemName: "storefront")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("매장 관리 앱")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("매장 운영을 더욱 스마트하게")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 버튼들
            VStack(spacing: 16) {
                Button(action: {
                    storeManager.loadSampleData()
                }) {
                    Label("샘플 데이터로 시작하기", systemImage: "play.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    storeManager.isFirstRun = false
                }) {
                    Label("직접 설정하기", systemImage: "gear")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            Text("시연용 샘플 데이터에는 카페 매장 정보, 직원 5명, 상품 35개가 포함되어 있습니다.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
