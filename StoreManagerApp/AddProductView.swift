// MARK: - AddProductView.swift (상품 추가)
import SwiftUI

struct AddProductView: View {
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var price = ""
    @State private var category = ""
    @State private var stock = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("상품 정보") {
                    TextField("상품명", text: $name)
                    TextField("가격", text: $price)
                        .keyboardType(.decimalPad)
                    TextField("카테고리", text: $category)
                    TextField("재고", text: $stock)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("새 상품 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        let product = Product(
                            name: name,
                            price: Double(price) ?? 0,
                            category: category,
                            stock: Int(stock) ?? 0
                        )
                        storeManager.addProduct(product)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty || price.isEmpty)
                }
            }
        }
    }
}
