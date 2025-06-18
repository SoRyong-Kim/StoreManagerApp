import SwiftUI
import Foundation

class AIRecommendationEngine: ObservableObject {
    
    // MARK: - 시간대별 분석
    func analyzeTimeSlots(from records: [SalesRecord]) -> [TimeSlotAnalysis] {
        let groupedByTimeSlot = Dictionary(grouping: records) { $0.timeSlot }
        let totalSales = records.reduce(0) { $0 + $1.totalAmount }
        
        return TimeSlot.allCases.compactMap { timeSlot in
            guard timeSlot != .other else { return nil }
            
            let slotRecords = groupedByTimeSlot[timeSlot] ?? []
            let slotSales = slotRecords.reduce(0) { $0 + $1.totalAmount }
            let slotQuantity = slotRecords.reduce(0) { $0 + $1.quantity }
            
            // 시간대별 인기 상품 분석
            let productGroups = Dictionary(grouping: slotRecords) { $0.productName }
            let topProducts = productGroups.map { (productName, productRecords) in
                ProductSalesData(
                    productName: productName,
                    category: productRecords.first?.productCategory ?? "",
                    quantity: productRecords.reduce(0) { $0 + $1.quantity },
                    totalAmount: productRecords.reduce(0) { $0 + $1.totalAmount },
                    unitPrice: productRecords.first?.unitPrice ?? 0
                )
            }.sorted { $0.totalAmount > $1.totalAmount }.prefix(3)
            
            let averageOrderValue = slotQuantity > 0 ? slotSales / Double(slotQuantity) : 0
            let salesPercentage = totalSales > 0 ? (slotSales / totalSales) * 100 : 0
            
            return TimeSlotAnalysis(
                timeSlot: timeSlot,
                totalSales: slotSales,
                totalQuantity: slotQuantity,
                topProducts: Array(topProducts),
                averageOrderValue: averageOrderValue,
                salesPercentage: salesPercentage
            )
        }.sorted { $0.totalSales > $1.totalSales }
    }
    
    // MARK: - 상품 추천 생성
    func generateProductRecommendations(
        from records: [SalesRecord],
        products: [Product],
        for monthYear: String
    ) -> [ProductRecommendation] {
        
        var recommendations: [ProductRecommendation] = []
        
        // 1. 인기 상승 상품 추천
        recommendations.append(contentsOf: getTrendingRecommendations(from: records, products: products))
        
        // 2. 시간대별 추천
        recommendations.append(contentsOf: getTimeSlotRecommendations(from: records, products: products))
        
        // 3. 재고 관리 추천
        recommendations.append(contentsOf: getInventoryRecommendations(products: products))
        
        // 4. 수익성 개선 추천
        recommendations.append(contentsOf: getMarginRecommendations(from: records, products: products))
        
        // 5. 계절성 추천
        recommendations.append(contentsOf: getSeasonalRecommendations(products: products, monthYear: monthYear))
        
        return Array(recommendations.prefix(8)) // 최대 8개 추천
    }
    
    // MARK: - 월별 종합 추천 생성
    func generateMonthlyRecommendation(
        from records: [SalesRecord],
        products: [Product],
        monthYear: String
    ) -> MonthlyRecommendation {
        
        let timeSlotAnalysis = analyzeTimeSlots(from: records)
        let productRecommendations = generateProductRecommendations(from: records, products: products, for: monthYear)
        
        // 전략 분석
        let overallStrategy = generateOverallStrategy(timeSlotAnalysis: timeSlotAnalysis, records: records)
        let keyInsights = generateKeyInsights(timeSlotAnalysis: timeSlotAnalysis, records: records)
        let actionItems = generateActionItems(recommendations: productRecommendations, timeSlotAnalysis: timeSlotAnalysis)
        
        // 신뢰도 점수 계산 (데이터 양에 따라)
        let confidenceScore = calculateConfidenceScore(recordCount: records.count)
        
        return MonthlyRecommendation(
            monthYear: monthYear,
            overallStrategy: overallStrategy,
            productRecommendations: productRecommendations,
            timeSlotAnalysis: timeSlotAnalysis,
            keyInsights: keyInsights,
            actionItems: actionItems,
            confidenceScore: confidenceScore
        )
    }
    
    // MARK: - Private Helper Methods
    
    private func getTrendingRecommendations(from records: [SalesRecord], products: [Product]) -> [ProductRecommendation] {
        let productSales = Dictionary(grouping: records) { $0.productName }
        
        return productSales.compactMap { (productName, sales) in
            guard let product = products.first(where: { $0.name == productName }) else { return nil }
            
            let totalQuantity = sales.reduce(0) { $0 + $1.quantity }
            let avgSales = Double(totalQuantity) / 30.0 // 일평균
            
            if avgSales > 2.0 { // 하루 평균 2개 이상 판매
                return ProductRecommendation(
                    product: product,
                    expectedSales: Int(avgSales * 7), // 주간 예상
                    salesProbability: min(avgSales / 5.0, 0.95),
                    reason: "최근 판매량이 꾸준히 증가하고 있습니다",
                    recommendationType: .trending,
                    timeSlot: nil
                )
            }
            return nil
        }.prefix(2).map { $0 }
    }
    
    private func getTimeSlotRecommendations(from records: [SalesRecord], products: [Product]) -> [ProductRecommendation] {
        let timeSlotAnalysis = analyzeTimeSlots(from: records)
        var recommendations: [ProductRecommendation] = []
        
        for analysis in timeSlotAnalysis.prefix(2) {
            if let topProduct = analysis.topProducts.first,
               let product = products.first(where: { $0.name == topProduct.productName }) {
                
                let recommendation = ProductRecommendation(
                    product: product,
                    expectedSales: Int(Double(analysis.totalQuantity) * 0.3), // 30% 증가 목표
                    salesProbability: analysis.salesPercentage / 100.0,
                    reason: "\(analysis.timeSlot.displayName) 시간대 최고 인기 상품입니다",
                    recommendationType: .timeSlot,
                    timeSlot: analysis.timeSlot
                )
                recommendations.append(recommendation)
            }
        }
        
        return recommendations
    }
    
    private func getInventoryRecommendations(products: [Product]) -> [ProductRecommendation] {
        return products.filter { $0.stock < 10 && $0.stock > 0 }.prefix(2).map { product in
            ProductRecommendation(
                product: product,
                expectedSales: 10 - product.stock,
                salesProbability: 0.8,
                reason: "재고가 부족합니다. 추가 주문을 고려하세요",
                recommendationType: .inventory,
                timeSlot: nil
            )
        }
    }
    
    private func getMarginRecommendations(from records: [SalesRecord], products: [Product]) -> [ProductRecommendation] {
        // 고마진 상품 중 판매량이 적은 것들 추천
        let highMarginProducts = products.filter { $0.price > 7000 } // 7000원 이상
        
        return highMarginProducts.prefix(2).map { product in
            ProductRecommendation(
                product: product,
                expectedSales: 15,
                salesProbability: 0.6,
                reason: "고마진 상품으로 수익성 개선에 도움됩니다",
                recommendationType: .margin,
                timeSlot: nil
            )
        }
    }
    
    private func getSeasonalRecommendations(products: [Product], monthYear: String) -> [ProductRecommendation] {
        let month = extractMonth(from: monthYear)
        
        var seasonalProducts: [Product] = []
        
        switch month {
        case 3, 4, 5: // 봄
            seasonalProducts = products.filter { $0.name.contains("딸기") || $0.name.contains("레몬") }
        case 6, 7, 8: // 여름
            seasonalProducts = products.filter { $0.name.contains("에이드") || $0.name.contains("아이스") }
        case 9, 10, 11: // 가을
            seasonalProducts = products.filter { $0.name.contains("라떼") || $0.name.contains("핫") }
        case 12, 1, 2: // 겨울
            seasonalProducts = products.filter { $0.name.contains("핫") || $0.name.contains("따뜻한") }
        default:
            seasonalProducts = []
        }
        
        return seasonalProducts.prefix(1).map { product in
            ProductRecommendation(
                product: product,
                expectedSales: 20,
                salesProbability: 0.75,
                reason: "계절에 맞는 인기 메뉴입니다",
                recommendationType: .seasonal,
                timeSlot: nil
            )
        }
    }
    
    private func generateOverallStrategy(timeSlotAnalysis: [TimeSlotAnalysis], records: [SalesRecord]) -> String {
        guard let bestTimeSlot = timeSlotAnalysis.first else {
            return "데이터 분석을 통해 더 나은 전략을 수립해보세요."
        }
        
        let totalSales = records.reduce(0) { $0 + $1.totalAmount }
        let averageDailySales = totalSales / 30.0
        
        if bestTimeSlot.salesPercentage > 40 {
            return "\(bestTimeSlot.timeSlot.displayName) 시간대에 집중하여 매출을 극대화하세요. 이 시간대가 전체 매출의 \(Int(bestTimeSlot.salesPercentage))%를 차지합니다."
        } else {
            return "시간대별 매출이 균등합니다. 각 시간대에 맞는 다양한 메뉴 전략을 활용하세요."
        }
    }
    
    private func generateKeyInsights(timeSlotAnalysis: [TimeSlotAnalysis], records: [SalesRecord]) -> [String] {
        var insights: [String] = []
        
        // 가장 활발한 시간대
        if let bestSlot = timeSlotAnalysis.first {
            insights.append("💡 \(bestSlot.timeSlot.displayName) 시간대가 가장 활발합니다 (\(Int(bestSlot.salesPercentage))%)")
        }
        
        // 평균 주문 금액
        let totalOrders = records.count
        let totalSales = records.reduce(0) { $0 + $1.totalAmount }
        if totalOrders > 0 {
            let avgOrder = totalSales / Double(totalOrders)
            insights.append("📊 평균 주문 금액: \(Int(avgOrder).formatted())원")
        }
        
        // 인기 카테고리
        let categoryGroups = Dictionary(grouping: records) { $0.productCategory }
        if let topCategory = categoryGroups.max(by: { $0.value.count < $1.value.count }) {
            insights.append("🏆 가장 인기있는 카테고리: \(topCategory.key)")
        }
        
        return insights
    }
    
    private func generateActionItems(recommendations: [ProductRecommendation], timeSlotAnalysis: [TimeSlotAnalysis]) -> [String] {
        var actions: [String] = []
        
        // 재고 관련 액션
        let inventoryRecs = recommendations.filter { $0.recommendationType == .inventory }
        if !inventoryRecs.isEmpty {
            actions.append("📦 재고 부족 상품 \(inventoryRecs.count)개 보충 필요")
        }
        
        // 시간대별 액션
        if let bestTimeSlot = timeSlotAnalysis.first {
            actions.append("⏰ \(bestTimeSlot.timeSlot.displayName) 시간대 서비스 품질 향상")
        }
        
        // 마케팅 액션
        let trendingRecs = recommendations.filter { $0.recommendationType == .trending }
        if !trendingRecs.isEmpty {
            actions.append("📈 인기 상승 메뉴 프로모션 진행")
        }
        
        return actions
    }
    
    private func calculateConfidenceScore(recordCount: Int) -> Double {
        switch recordCount {
        case 0..<10: return 0.3
        case 10..<30: return 0.5
        case 30..<50: return 0.7
        case 50..<100: return 0.85
        default: return 0.95
        }
    }
    
    private func extractMonth(from monthYear: String) -> Int {
        let components = monthYear.components(separatedBy: "년 ")
        if components.count > 1 {
            let monthString = components[1].replacingOccurrences(of: "월", with: "")
            return Int(monthString) ?? 6
        }
        return 6
    }
}
