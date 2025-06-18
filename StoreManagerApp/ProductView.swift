// MARK: - ProductView.swift (상품 관리)
import SwiftUI

struct ProductView: View {
    @EnvironmentObject var storeManager: StoreManager
    @State private var showingAddProduct = false
    @State private var searchText = ""
    @State private var selectedProduct: Product?
    @State private var selectedCategory = "전체"
    
    var categories: [String] {
        let allCategories = ["전체"] + Array(Set(storeManager.products.map { $0.category })).sorted()
        return allCategories
    }
    
    var filteredProducts: [Product] {
        var products = storeManager.products
        
        // 카테고리 필터
        if selectedCategory != "전체" {
            products = products.filter { $0.category == selectedCategory }
        }
        
        // 검색 필터
        if !searchText.isEmpty {
            products = products.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return products.sorted { $0.name < $1.name }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 검색 바
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // 카테고리 필터
                if categories.count > 1 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                CategoryChip(
                                    title: category,
                                    isSelected: selectedCategory == category
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                }
                
                // 상품 리스트
                if filteredProducts.isEmpty {
                    EmptyStateView(
                        icon: "cube.box",
                        title: searchText.isEmpty ? "등록된 상품이 없습니다" : "검색 결과가 없습니다",
                        subtitle: searchText.isEmpty ? "새 상품을 추가해보세요" : "다른 검색어를 시도해보세요"
                    )
                } else {
                    List {
                        ForEach(filteredProducts) { product in
                            ProductRowView(product: product) {
                                selectedProduct = product
                            }
                        }
                        .onDelete(perform: deleteProduct)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("상품 관리")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddProduct = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddProduct) {
                AddProductView()
                    .environmentObject(storeManager)
            }
            .sheet(item: $selectedProduct) { product in
                ProductDetailView(product: product)
                    .environmentObject(storeManager)
            }
        }
        .onAppear {
            storeManager.loadProducts()
        }
    }
    
    func deleteProduct(offsets: IndexSet) {
        for index in offsets {
            storeManager.removeProduct(filteredProducts[index])
        }
    }
}
