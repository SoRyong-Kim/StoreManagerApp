// MARK: - ProductView.swift (알림 기능 포함)
import SwiftUI

struct ProductView: View {
    @EnvironmentObject var storeManager: StoreManager
    @ObservedObject var notificationManager = NotificationManager.shared
    @State private var showingAddProduct = false
    @State private var searchText = ""
    @State private var selectedProduct: Product?
    @State private var selectedCategory = "전체"
    @State private var showingLowStockAlert = false
    @State private var stockFilter: StockFilter = .all
    
    enum StockFilter: String, CaseIterable {
        case all = "전체"
        case lowStock = "재고 부족"
        case outOfStock = "품절"
        case sufficient = "재고 충분"
        
        var icon: String {
            switch self {
            case .all: return "square.grid.2x2"
            case .lowStock: return "exclamationmark.triangle"
            case .outOfStock: return "xmark.circle"
            case .sufficient: return "checkmark.circle"
            }
        }
        
        var color: Color {
            switch self {
            case .all: return .blue
            case .lowStock: return .orange
            case .outOfStock: return .red
            case .sufficient: return .green
            }
        }
    }
    
    var categories: [String] {
        let allCategories = ["전체"] + Array(Set(storeManager.products.map { $0.category })).sorted()
        return allCategories
    }
    
    var filteredProducts: [Product] {
        var products = storeManager.products
        
        // 재고 필터
        switch stockFilter {
        case .all:
            break
        case .lowStock:
            products = products.filter { $0.stock < 10 && $0.stock > 0 }
        case .outOfStock:
            products = products.filter { $0.stock == 0 }
        case .sufficient:
            products = products.filter { $0.stock >= 10 }
        }
        
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
                // 재고 상태 요약 바
                StockSummaryBar()
                
                // 검색 바
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // 필터 바
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        // 재고 필터
                        ForEach(StockFilter.allCases, id: \.rawValue) { filter in
                            FilterChip(
                                title: filter.rawValue,
                                icon: filter.icon,
                                color: filter.color,
                                isSelected: stockFilter == filter
                            ) {
                                stockFilter = filter
                            }
                        }
                        
                        // 구분선
                        Divider()
                            .frame(height: 20)
                        
                        // 카테고리 필터
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
                
                // 상품 리스트
                if filteredProducts.isEmpty {
                    EmptyStateView(
                        icon: getEmptyStateIcon(),
                        title: getEmptyStateTitle(),
                        subtitle: getEmptyStateSubtitle()
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingLowStockAlert = true
                    }) {
                        ZStack {
                            Image(systemName: "bell")
                            NotificationBadge(count: notificationManager.unreadCount)
                                .offset(x: 10, y: -8)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingAddProduct = true }) {
                            Label("새 상품 추가", systemImage: "plus")
                        }
                        
                        Button(action: { bulkStockUpdate() }) {
                            Label("재고 일괄 수정", systemImage: "square.and.pencil")
                        }
                        
                        Button(action: { showingLowStockAlert = true }) {
                            Label("재고 알림 보기", systemImage: "bell")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
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
            .sheet(isPresented: $showingLowStockAlert) {
                LowStockAlertView()
                    .environmentObject(storeManager)
            }
        }
        .onAppear {
            storeManager.loadProducts()
        }
    }
    
    // MARK: - Helper Methods
    private func deleteProduct(offsets: IndexSet) {
        for index in offsets {
            storeManager.removeProduct(filteredProducts[index])
        }
    }
    
    private func bulkStockUpdate() {
        let lowStockProducts = storeManager.getLowStockProducts()
        storeManager.bulkUpdateStock(for: lowStockProducts, amount: 20)
    }
    
    private func getEmptyStateIcon() -> String {
        switch stockFilter {
        case .all: return searchText.isEmpty ? "cube.box" : "magnifyingglass"
        case .lowStock: return "checkmark.circle"
        case .outOfStock: return "checkmark.circle"
        case .sufficient: return "cube.box"
        }
    }
    
    private func getEmptyStateTitle() -> String {
        switch stockFilter {
        case .all: return searchText.isEmpty ? "등록된 상품이 없습니다" : "검색 결과가 없습니다"
        case .lowStock: return "재고 부족 상품이 없습니다"
        case .outOfStock: return "품절된 상품이 없습니다"
        case .sufficient: return "재고가 충분한 상품이 없습니다"
        }
    }
    
    private func getEmptyStateSubtitle() -> String {
        switch stockFilter {
        case .all: return searchText.isEmpty ? "새 상품을 추가해보세요" : "다른 검색어를 시도해보세요"
        case .lowStock: return "모든 상품의 재고가 충분합니다!"
        case .outOfStock: return "현재 품절된 상품이 없습니다"
        case .sufficient: return "재고를 보충해주세요"
        }
    }
}

// MARK: - 재고 상태 요약 바
struct StockSummaryBar: View {
    @EnvironmentObject var storeManager: StoreManager
    
    var stockSummary: (total: Int, lowStock: Int, outOfStock: Int) {
        let total = storeManager.products.count
        let lowStock = storeManager.getLowStockProducts().count
        let outOfStock = storeManager.getOutOfStockProducts().count
        return (total, lowStock, outOfStock)
    }
    
    var body: some View {
        let summary = stockSummary
        
        HStack(spacing: 20) {
            StockSummaryItem(
                title: "전체",
                count: summary.total,
                color: .blue
            )
            
            StockSummaryItem(
                title: "재고부족",
                count: summary.lowStock,
                color: .orange
            )
            
            StockSummaryItem(
                title: "품절",
                count: summary.outOfStock,
                color: .red
            )
        }
        .padding()
        .background(Color.gray.opacity(0.05))
    }
}

struct StockSummaryItem: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - 필터 칩
struct FilterChip: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? color : Color.gray.opacity(0.2))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
        }
    }
}

//// MARK: - 카테고리 칩 (기존과 동일하지만 재사용을 위해 포함)
//struct CategoryChip: View {
//    let title: String
//    let isSelected: Bool
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            Text(title)
//                .font(.caption)
//                .fontWeight(.medium)
//                .padding(.horizontal, 12)
//                .padding(.vertical, 6)
//                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
//                .foregroundColor(isSelected ? .white : .primary)
//                .cornerRadius(16)
//        }
//    }
//}
//
//// MARK: - 검색 바 (기존과 동일하지만 재사용을 위해 포함)
//struct SearchBar: View {
//    @Binding var text: String
//    
//    var body: some View {
//        HStack {
//            Image(systemName: "magnifyingglass")
//                .foregroundColor(.secondary)
//            
//            TextField("상품명 또는 카테고리 검색", text: $text)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//        }
//    }
//}
//
//// MARK: - 빈 상태 뷰 (기존과 동일하지만 재사용을 위해 포함)
//struct EmptyStateView: View {
//    let icon: String
//    let title: String
//    let subtitle: String
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Image(systemName: icon)
//                .font(.system(size: 60))
//                .foregroundColor(.gray)
//            
//            Text(title)
//                .font(.title2)
//                .fontWeight(.bold)
//                .foregroundColor(.primary)
//            
//            Text(subtitle)
//                .font(.body)
//                .foregroundColor(.secondary)
//                .multilineTextAlignment(.center)
//        }
//        .padding()
//    }
//}
