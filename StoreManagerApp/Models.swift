// MARK: - Models.swift (데이터 모델)
import Foundation

struct StoreInfo: Codable {
    var name: String = ""
    var address: String = ""
    var phone: String = ""
    var businessHours: String = ""
    var category: StoreCategory = .other
    var description: String = ""
}

enum StoreCategory: String, CaseIterable, Codable {
    case restaurant = "음식점"
    case retail = "소매점"
    case cafe = "카페"
    case beauty = "미용실"
    case clothing = "의류점"
    case convenience = "편의점"
    case other = "기타"
}

struct Employee: Identifiable, Codable {
    let id = UUID()
    var name: String
    var position: String
    var phone: String
}

struct Product: Identifiable, Codable {
    let id = UUID()
    var name: String
    var price: Double
    var category: String
    var stock: Int
}
