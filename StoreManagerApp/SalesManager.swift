import SwiftUI

class SalesManager: ObservableObject {
    @Published var salesRecords: [SalesRecord] = []
    
    init() {
        loadSampleData()
    }
    
    func addSale(productName: String, productCategory: String, quantity: Int, unitPrice: Double) {
        let record = SalesRecord(
            productName: productName,
            productCategory: productCategory,
            quantity: quantity,
            unitPrice: unitPrice,
            totalAmount: Double(quantity) * unitPrice,
            date: Date()
        )
        salesRecords.append(record)
    }
    
    func getMonthlySalesData() -> [MonthlySalesData] {
        let groupedByMonth = Dictionary(grouping: salesRecords) { $0.month }
        
        return groupedByMonth.map { (month, records) in
            let totalSales = records.reduce(0) { $0 + $1.totalAmount }
            let totalQuantity = records.reduce(0) { $0 + $1.quantity }
            
            // 상품별 판매 데이터
            let productGroups = Dictionary(grouping: records) { $0.productName }
            let productSales = productGroups.map { (productName, productRecords) in
                ProductSalesData(
                    productName: productName,
                    category: productRecords.first?.productCategory ?? "",
                    quantity: productRecords.reduce(0) { $0 + $1.quantity },
                    totalAmount: productRecords.reduce(0) { $0 + $1.totalAmount },
                    unitPrice: productRecords.first?.unitPrice ?? 0
                )
            }.sorted { $0.totalAmount > $1.totalAmount }
            
            // 카테고리별 판매 데이터
            let categoryGroups = Dictionary(grouping: records) { $0.productCategory }
            let categorySales = categoryGroups.map { (category, categoryRecords) in
                CategorySalesData(
                    category: category,
                    quantity: categoryRecords.reduce(0) { $0 + $1.quantity },
                    totalAmount: categoryRecords.reduce(0) { $0 + $1.totalAmount },
                    productCount: Set(categoryRecords.map { $0.productName }).count
                )
            }.sorted { $0.totalAmount > $1.totalAmount }
            
            return MonthlySalesData(
                month: month,
                monthYear: records.first?.monthYear ?? "",
                totalSales: totalSales,
                totalQuantity: totalQuantity,
                productSales: productSales,
                categorySales: categorySales
            )
        }.sorted { $0.month > $1.month }
    }
    
    private func loadSampleData() {
        // 최근 6개월 샘플 데이터 생성
        let calendar = Calendar.current
        let products = [
            ("아메리카노", "커피", 4500),
            ("카페라떼", "커피", 5500),
            ("카푸치노", "커피", 6000),
            ("치즈케이크", "디저트", 8500),
            ("크로와상", "디저트", 4500),
            ("클럽샌드위치", "브런치", 12000),
            ("레몬에이드", "음료", 5000),
            ("텀블러", "굿즈", 15000)
        ]
        
        for monthOffset in 0..<6 {
            guard let monthDate = calendar.date(byAdding: .month, value: -monthOffset, to: Date()) else { continue }
            
            for _ in 0..<Int.random(in: 50...120) {
                let product = products.randomElement()!
                let randomDay = Int.random(in: 1...28)
                let saleDate = calendar.date(byAdding: .day, value: randomDay - calendar.component(.day, from: monthDate), to: monthDate) ?? monthDate
                
                let record = SalesRecord(
                    productName: product.0,
                    productCategory: product.1,
                    quantity: Int.random(in: 1...5),
                    unitPrice: Double(product.2),
                    totalAmount: Double(Int.random(in: 1...5)) * Double(product.2),
                    date: saleDate
                )
                salesRecords.append(record)
            }
        }
    }
}
