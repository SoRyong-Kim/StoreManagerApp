import Foundation
import SwiftUI

struct SalesRecord: Identifiable, Codable {
    let id = UUID()
    let productName: String
    let productCategory: String
    let quantity: Int
    let unitPrice: Double
    let totalAmount: Double
    let date: Date
    let hour: Int // 새로 추가: 판매 시간 (0-23)
    
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
    
    var timeSlot: TimeSlot {
        switch hour {
        case 7..<11:
            return .morning
        case 11..<14:
            return .lunch
        case 14..<17:
            return .afternoon
        case 17..<21:
            return .evening
        default:
            return .other
        }
    }
    
    // 기존 생성자와의 호환성을 위한 초기화
    init(productName: String, productCategory: String, quantity: Int, unitPrice: Double, totalAmount: Double, date: Date, hour: Int? = nil) {
        self.productName = productName
        self.productCategory = productCategory
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.totalAmount = totalAmount
        self.date = date
        self.hour = hour ?? Calendar.current.component(.hour, from: date)
    }
}

// MARK: - 시간대 정의
enum TimeSlot: String, CaseIterable, Codable {
    case morning = "모닝"
    case lunch = "런치"
    case afternoon = "애프터눈"
    case evening = "이브닝"
    case other = "기타"
    
    var displayName: String {
        switch self {
        case .morning: return "모닝 (07:00-11:00)"
        case .lunch: return "런치 (11:00-14:00)"
        case .afternoon: return "애프터눈 (14:00-17:00)"
        case .evening: return "이브닝 (17:00-21:00)"
        case .other: return "기타 시간"
        }
    }
    
    var icon: String {
        switch self {
        case .morning: return "sunrise.fill"
        case .lunch: return "sun.max.fill"
        case .afternoon: return "sun.dust.fill"
        case .evening: return "moon.fill"
        case .other: return "clock.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .morning: return .orange
        case .lunch: return .yellow
        case .afternoon: return .blue
        case .evening: return .purple
        case .other: return .gray
        }
    }
}

// MARK: - AI 추천 관련 데이터 구조
struct TimeSlotAnalysis: Identifiable {
    let id = UUID()
    let timeSlot: TimeSlot
    let totalSales: Double
    let totalQuantity: Int
    let topProducts: [ProductSalesData]
    let averageOrderValue: Double
    let salesPercentage: Double
}

struct ProductRecommendation: Identifiable {
    let id = UUID()
    let product: Product
    let expectedSales: Int
    let salesProbability: Double
    let reason: String
    let recommendationType: RecommendationType
    let timeSlot: TimeSlot?
}

enum RecommendationType: String, CaseIterable {
    case trending = "인기 상승"
    case seasonal = "계절 추천"
    case timeSlot = "시간대 추천"
    case inventory = "재고 관리"
    case margin = "수익성 개선"
    
    var icon: String {
        switch self {
        case .trending: return "chart.line.uptrend.xyaxis"
        case .seasonal: return "leaf.fill"
        case .timeSlot: return "clock.fill"
        case .inventory: return "cube.box.fill"
        case .margin: return "dollarsign.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .trending: return .green
        case .seasonal: return .orange
        case .timeSlot: return .blue
        case .inventory: return .red
        case .margin: return .purple
        }
    }
}

struct MonthlyRecommendation: Identifiable {
    let id = UUID()
    let monthYear: String
    let overallStrategy: String
    let productRecommendations: [ProductRecommendation]
    let timeSlotAnalysis: [TimeSlotAnalysis]
    let keyInsights: [String]
    let actionItems: [String]
    let confidenceScore: Double
}

// MARK: - 업데이트된 MonthlySalesData (AI 분석 추가)
struct MonthlySalesData: Identifiable {
    let id = UUID()
    let month: String
    let monthYear: String
    let totalSales: Double
    let totalQuantity: Int
    let productSales: [ProductSalesData]
    let categorySales: [CategorySalesData]
    let timeSlotAnalysis: [TimeSlotAnalysis] // 새로 추가
    let recommendation: MonthlyRecommendation? // 새로 추가
}

// 기존 구조는 그대로 유지
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
