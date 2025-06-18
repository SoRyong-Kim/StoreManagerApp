// MARK: - InitialSetupView.swift (초기 설정 화면)
import SwiftUI

struct InitialSetupView: View {
    @EnvironmentObject var storeManager: StoreManager
    @State private var storeInfo = StoreInfo()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 헤더
                    VStack(spacing: 16) {
                        Image(systemName: "storefront")
                            .font(.system(size: 64))
                            .foregroundColor(.blue)
                        
                        Text("매장 관리 앱에 오신 것을\n환영합니다!")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("매장 정보를 설정하여 시작하세요")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    // 입력 폼
                    VStack(spacing: 20) {
                        CustomTextField("매장명", text: $storeInfo.name)
                        CustomTextField("주소", text: $storeInfo.address)
                        
                        HStack(spacing: 12) {
                            CustomTextField("전화번호", text: $storeInfo.phone)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("업종")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Picker("업종", selection: $storeInfo.category) {
                                    ForEach(StoreCategory.allCases, id: \.self) { category in
                                        Text(category.rawValue).tag(category)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 16)
                                .frame(height: 50)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                        }
                        
                        CustomTextField("영업시간 (예: 09:00 - 22:00)", text: $storeInfo.businessHours)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("매장 소개")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextEditor(text: $storeInfo.description)
                                .frame(height: 100)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                    }
                    
                    // 완료 버튼
                    Button(action: {
                        storeManager.storeInfo = storeInfo
                        storeManager.saveStoreInfo()
                    }) {
                        Text("설정 완료")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                (storeInfo.name.isEmpty || storeInfo.address.isEmpty)
                                ? Color.gray : Color.blue
                            )
                            .cornerRadius(12)
                    }
                    .disabled(storeInfo.name.isEmpty || storeInfo.address.isEmpty)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .navigationBarHidden(true)
        }
    }
}
