import Foundation

struct SalesRecord: Identifiable, Codable {
    let id = UUID()
    let productName: String
    let productCategory: String
    let quantity: Int
    let unitPrice: Double
    let totalAmount: Double
    let date: Date
    
    var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.string(from: date)
    }
    
    var monthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        return formatter.string(from: date)
    }
}

struct MonthlySalesData: Identifiable {
    let id = UUID()
    let month: String
    let monthYear: String
    let totalSales: Double
    let totalQuantity: Int
    let productSales: [ProductSalesData]
    let categorySales: [CategorySalesData]
}

struct ProductSalesData: Identifiable {
    let id = UUID()
    let productName: String
    let category: String
    let quantity: Int
    let totalAmount: Double
    let unitPrice: Double
}

struct CategorySalesData: Identifiable {
    let id = UUID()
    let category: String
    let quantity: Int
    let totalAmount: Double
    let productCount: Int
}
