import SwiftUI

class SalesManager: ObservableObject {
    @Published var salesRecords: [SalesRecord] = []
    private let aiEngine = AIRecommendationEngine()
    
    init() {
        loadSampleData()
    }
    
    func addSale(productName: String, productCategory: String, quantity: Int, unitPrice: Double, hour: Int? = nil) {
        let currentHour = hour ?? Calendar.current.component(.hour, from: Date())
        let record = SalesRecord(
            productName: productName,
            productCategory: productCategory,
            quantity: quantity,
            unitPrice: unitPrice,
            totalAmount: Double(quantity) * unitPrice,
            date: Date(),
            hour: currentHour
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
            
            // AI 분석 추가
            let timeSlotAnalysis = aiEngine.analyzeTimeSlots(from: records)
            let monthYear = records.first?.monthYear ?? ""
            
            // 상품 정보는 샘플 데이터에서 가져옴 (실제로는 StoreManager에서 가져와야 함)
            let sampleProducts = SampleDataManager.createSampleProducts()
            let recommendation = aiEngine.generateMonthlyRecommendation(
                from: records,
                products: sampleProducts,
                monthYear: monthYear
            )
            
            return MonthlySalesData(
                month: month,
                monthYear: monthYear,
                totalSales: totalSales,
                totalQuantity: totalQuantity,
                productSales: productSales,
                categorySales: categorySales,
                timeSlotAnalysis: timeSlotAnalysis,
                recommendation: recommendation
            )
        }.sorted { $0.month > $1.month }
    }
    
    // MARK: - 실시간 추천 기능
    func getCurrentTimeSlotRecommendation() -> TimeSlotAnalysis? {
        let currentHour = Calendar.current.component(.hour, from: Date())
        let currentTimeSlot: TimeSlot
        
        switch currentHour {
        case 7..<11: currentTimeSlot = .morning
        case 11..<14: currentTimeSlot = .lunch
        case 14..<17: currentTimeSlot = .afternoon
        case 17..<21: currentTimeSlot = .evening
        default: return nil
        }
        
        // 최근 1개월 데이터에서 현재 시간대 분석
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        let recentRecords = salesRecords.filter { $0.date >= oneMonthAgo }
        let timeSlotAnalysis = aiEngine.analyzeTimeSlots(from: recentRecords)
        
        return timeSlotAnalysis.first { $0.timeSlot == currentTimeSlot }
    }
    
    private func loadSampleData() {
        // 기존 샘플 데이터에 시간 정보 추가
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
        
        // 시간대별 가중치 (실제 카페 운영 패턴 반영)
        let timeWeights: [Int: Double] = [
            7: 0.5, 8: 1.5, 9: 2.0, 10: 1.8,  // 모닝
            11: 1.2, 12: 2.5, 13: 2.0,        // 런치
            14: 1.8, 15: 2.2, 16: 1.5,        // 애프터눈
            17: 1.0, 18: 1.3, 19: 1.8, 20: 1.2 // 이브닝
        ]
        
        for monthOffset in 0..<6 {
            guard let monthDate = calendar.date(byAdding: .month, value: -monthOffset, to: Date()) else { continue }
            
            for _ in 0..<Int.random(in: 80...150) { // 월별 판매 건수 증가
                let product = products.randomElement()!
                let randomDay = Int.random(in: 1...28)
                
                // 시간대별 가중치를 적용한 시간 선택
                let hour = selectWeightedHour(weights: timeWeights)
                
                var saleDate = calendar.date(byAdding: .day, value: randomDay - calendar.component(.day, from: monthDate), to: monthDate) ?? monthDate
                saleDate = calendar.date(bySettingHour: hour, minute: Int.random(in: 0...59), second: 0, of: saleDate) ?? saleDate
                
                let record = SalesRecord(
                    productName: product.0,
                    productCategory: product.1,
                    quantity: Int.random(in: 1...3),
                    unitPrice: Double(product.2),
                    totalAmount: Double(Int.random(in: 1...3)) * Double(product.2),
                    date: saleDate,
                    hour: hour
                )
                salesRecords.append(record)
            }
        }
    }
    
    private func selectWeightedHour(weights: [Int: Double]) -> Int {
        let totalWeight = weights.values.reduce(0, +)
        let randomValue = Double.random(in: 0...totalWeight)
        
        var currentWeight = 0.0
        for (hour, weight) in weights.sorted(by: { $0.key < $1.key }) {
            currentWeight += weight
            if randomValue <= currentWeight {
                return hour
            }
        }
        
        return 9 // 기본값
    }
}
