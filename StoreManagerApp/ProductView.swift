// MARK: - ProductView.swift (상품 관리)
import SwiftUI

struct ProductView: View {
    @EnvironmentObject var storeManager: StoreManager
    @State private var showingAddProduct = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(storeManager.products) { product in
                    ProductRow(product: product)
                }
                .onDelete(perform: deleteProduct)
            }
            .navigationTitle("상품 관리")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddProduct = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddProduct) {
                AddProductView()
                    .environmentObject(storeManager)
            }
        }
    }
    
    func deleteProduct(offsets: IndexSet) {
        for index in offsets {
            storeManager.removeProduct(storeManager.products[index])
        }
    }
}

struct ProductRow: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(product.name)
                    .font(.headline)
                Spacer()
                Text("₩\(Int(product.price).formatted())")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            HStack {
                Text(product.category)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("재고: \(product.stock)개")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
