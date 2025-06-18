// MARK: - EditStoreView.swift (매장 정보 수정)
import SwiftUI

struct EditStoreView: View {
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.presentationMode) var presentationMode
    @State private var storeInfo: StoreInfo
    
    init() {
        self._storeInfo = State(initialValue: StoreInfo())
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("기본 정보") {
                    TextField("매장명", text: $storeInfo.name)
                    TextField("주소", text: $storeInfo.address)
                    TextField("전화번호", text: $storeInfo.phone)
                }
                
                Section("운영 정보") {
                    Picker("업종", selection: $storeInfo.category) {
                        ForEach(StoreCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    TextField("영업시간", text: $storeInfo.businessHours)
                }
                
                Section("매장 소개") {
                    TextField("설명", text: $storeInfo.description, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("매장 정보 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        storeManager.storeInfo = storeInfo
                        storeManager.saveStoreInfo()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .onAppear {
            storeInfo = storeManager.storeInfo
        }
    }
}
