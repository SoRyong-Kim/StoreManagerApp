import SwiftUI

struct EditProductView: View {
    @Binding var product: Product
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var price: String
    @State private var category: String
    @State private var stock: String
    
    // 카테고리 옵션들
    private let categoryOptions = ["커피", "음료", "디저트", "브런치", "원두", "굿즈", "기타"]
    
    init(product: Binding<Product>) {
        self._product = product
        self._name = State(initialValue: product.wrappedValue.name)
        self._price = State(initialValue: String(Int(product.wrappedValue.price)))
        self._category = State(initialValue: product.wrappedValue.category)
        self._stock = State(initialValue: String(product.wrappedValue.stock))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("기본 정보") {
                    TextField("상품명", text: $name)
                    
                    HStack {
                        Text("가격")
                        Spacer()
                        TextField("가격", text: $price)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("원")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("카테고리") {
                    Picker("카테고리", selection: $category) {
                        ForEach(categoryOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    // 직접 입력도 가능
                    TextField("또는 직접 입력", text: $category)
                }
                
                Section("재고 관리") {
                    HStack {
                        Text("현재 재고")
                        Spacer()
                        TextField("재고", text: $stock)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("개")
                            .foregroundColor(.secondary)
                    }
                    
                    // 재고 조절 버튼들
                    HStack {
                        Button("재고 0 (품절)") {
                            stock = "0"
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button("재고 +10") {
                            let currentStock = Int(stock) ?? 0
                            stock = String(currentStock + 10)
                        }
                        .foregroundColor(.green)
                        
                        Button("재고 +50") {
                            let currentStock = Int(stock) ?? 0
                            stock = String(currentStock + 50)
                        }
                        .foregroundColor(.blue)
                    }
                    .font(.caption)
                }
            }
            .navigationTitle("상품 정보 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        product.name = name
                        product.price = Double(price) ?? product.price
                        product.category = category
                        product.stock = Int(stock) ?? product.stock
                        
                        storeManager.updateProduct(product)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty || price.isEmpty || category.isEmpty)
                }
            }
        }
    }
}
