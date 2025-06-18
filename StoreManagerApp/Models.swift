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
    var email: String
    var hireDate: Date
    var salary: Double
    var workSchedule: WorkSchedule
    var isActive: Bool
    var profileImage: String? // 프로필 이미지 URL 또는 이름
    var notes: String
    
    init(name: String, position: String, phone: String, email: String = "", salary: Double = 0, workSchedule: WorkSchedule = WorkSchedule(), notes: String = "") {
        self.name = name
        self.position = position
        self.phone = phone
        self.email = email
        self.hireDate = Date()
        self.salary = salary
        self.workSchedule = workSchedule
        self.isActive = true
        self.notes = notes
    }
}

struct WorkSchedule: Codable {
    var monday: WorkDay
    var tuesday: WorkDay
    var wednesday: WorkDay
    var thursday: WorkDay
    var friday: WorkDay
    var saturday: WorkDay
    var sunday: WorkDay
    
    init() {
        self.monday = WorkDay()
        self.tuesday = WorkDay()
        self.wednesday = WorkDay()
        self.thursday = WorkDay()
        self.friday = WorkDay()
        self.saturday = WorkDay()
        self.sunday = WorkDay()
    }
    
    var workDays: [WorkDay] {
        [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
    }
    
    var weekDayNames: [String] {
        ["월", "화", "수", "목", "금", "토", "일"]
    }
}

struct WorkDay: Codable {
    var isWorkDay: Bool
    var startTime: Date
    var endTime: Date
    
    init(isWorkDay: Bool = true, startTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date(), endTime: Date = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date()) {
        self.isWorkDay = isWorkDay
        self.startTime = startTime
        self.endTime = endTime
    }
    
    var timeString: String {
        if !isWorkDay {
            return "휴무"
        }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime))"
    }
}


struct Product: Identifiable, Codable {
    let id = UUID()
    var name: String
    var price: Double
    var category: String
    var stock: Int
}
