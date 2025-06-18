import Foundation

class SampleDataManager {
    
    // MARK: - 샘플 매장 정보
    static func createSampleStoreInfo() -> StoreInfo {
        return StoreInfo(
            name: "행복한 카페",
            address: "서울시 강남구 테헤란로 123",
            phone: "02-1234-5678",
            businessHours: "08:00 - 22:00",
            category: .cafe,
            description: "신선한 원두와 따뜻한 분위기의 동네 카페입니다. 고객 한 분 한 분께 정성스럽게 내린 커피를 제공합니다."
        )
    }
    
    // MARK: - 샘플 직원 데이터
    static func createSampleEmployees() -> [Employee] {
        let employees = [
            Employee(
                name: "김매니저",
                position: "매장 매니저",
                phone: "010-1234-5678",
                email: "manager@happycafe.com",
                salary: 3500000,
                workSchedule: createManagerSchedule(),
                notes: "5년 경력의 숙련된 매니저. 고객 서비스와 직원 관리에 탁월함."
            ),
            Employee(
                name: "이바리스타",
                position: "수석 바리스타",
                phone: "010-2345-6789",
                email: "barista1@happycafe.com",
                salary: 2800000,
                workSchedule: createMorningSchedule(),
                notes: "라떼아트 전문가. 3년 경력. 고객들에게 인기가 많음."
            ),
            Employee(
                name: "박서빙",
                position: "서빙 스태프",
                phone: "010-3456-7890",
                email: "staff1@happycafe.com",
                salary: 2200000,
                workSchedule: createAfternoonSchedule(),
                notes: "친절하고 꼼꼼한 성격. 주문 실수가 거의 없음."
            ),
            Employee(
                name: "최알바",
                position: "아르바이트",
                phone: "010-4567-8901",
                email: "parttime@happycafe.com",
                salary: 1500000,
                workSchedule: createWeekendSchedule(),
                notes: "대학생 아르바이트. 주말과 저녁 시간 근무 가능."
            ),
            Employee(
                name: "정퇴사",
                position: "전 바리스타",
                phone: "010-5678-9012",
                email: "former@happycafe.com",
                salary: 2500000,
                workSchedule: WorkSchedule(),
                notes: "개인 사정으로 퇴사. 성실했던 직원."
            )
        ]
        
        // 마지막 직원을 퇴사 처리
        var modifiedEmployees = employees
        modifiedEmployees[4].isActive = false
        
        return modifiedEmployees
    }
    
    // MARK: - 샘플 상품 데이터
    static func createSampleProducts() -> [Product] {
        return [
            // 커피류
            Product(name: "아메리카노", price: 4500, category: "커피", stock: 100),
            Product(name: "카페라떼", price: 5500, category: "커피", stock: 80),
            Product(name: "카푸치노", price: 6000, category: "커피", stock: 60),
            Product(name: "에스프레소", price: 4000, category: "커피", stock: 50),
            Product(name: "바닐라라떼", price: 6500, category: "커피", stock: 45),
            Product(name: "카라멜마키아토", price: 7000, category: "커피", stock: 40),
            Product(name: "모카라떼", price: 6500, category: "커피", stock: 35),
            Product(name: "아이스드립", price: 5500, category: "커피", stock: 25),
            
            // 음료류
            Product(name: "녹차라떼", price: 5500, category: "음료", stock: 30),
            Product(name: "초콜릿라떼", price: 6000, category: "음료", stock: 25),
            Product(name: "딸기라떼", price: 6500, category: "음료", stock: 20),
            Product(name: "레몬에이드", price: 5000, category: "음료", stock: 40),
            Product(name: "자몽에이드", price: 5500, category: "음료", stock: 35),
            Product(name: "오렌지주스", price: 4500, category: "음료", stock: 30),
            Product(name: "사과주스", price: 4500, category: "음료", stock: 25),
            
            // 디저트류
            Product(name: "치즈케이크", price: 8500, category: "디저트", stock: 15),
            Product(name: "초콜릿케이크", price: 9000, category: "디저트", stock: 12),
            Product(name: "티라미수", price: 8000, category: "디저트", stock: 10),
            Product(name: "마카롱 세트", price: 12000, category: "디저트", stock: 20),
            Product(name: "크로와상", price: 4500, category: "디저트", stock: 25),
            Product(name: "머핀", price: 3500, category: "디저트", stock: 30),
            Product(name: "쿠키", price: 2500, category: "디저트", stock: 40),
            Product(name: "스콘", price: 4000, category: "디저트", stock: 18),
            
            // 브런치류
            Product(name: "클럽샌드위치", price: 12000, category: "브런치", stock: 15),
            Product(name: "아보카도토스트", price: 9500, category: "브런치", stock: 20),
            Product(name: "팬케이크", price: 11000, category: "브런치", stock: 12),
            Product(name: "프렌치토스트", price: 10000, category: "브런치", stock: 15),
            Product(name: "그릭요거트", price: 8500, category: "브런치", stock: 25),
            Product(name: "아침식사세트", price: 15000, category: "브런치", stock: 10),
            
            // 원두/기타
            Product(name: "원두 500g (에티오피아)", price: 25000, category: "원두", stock: 8),
            Product(name: "원두 500g (콜롬비아)", price: 23000, category: "원두", stock: 12),
            Product(name: "원두 500g (과테말라)", price: 27000, category: "원두", stock: 6),
            Product(name: "텀블러", price: 15000, category: "굿즈", stock: 30),
            Product(name: "머그컵", price: 12000, category: "굿즈", stock: 25),
            Product(name: "에코백", price: 8000, category: "굿즈", stock: 20)
        ]
    }
    
    // MARK: - 근무 스케줄 샘플
    private static func createManagerSchedule() -> WorkSchedule {
        var schedule = WorkSchedule()
        let startTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date()
        let endTime = Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date()) ?? Date()
        
        schedule.monday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.tuesday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.wednesday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.thursday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.friday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.saturday = WorkDay(isWorkDay: true, startTime: startTime, endTime: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date()) ?? Date())
        schedule.sunday = WorkDay(isWorkDay: false, startTime: startTime, endTime: endTime)
        
        return schedule
    }
    
    private static func createMorningSchedule() -> WorkSchedule {
        var schedule = WorkSchedule()
        let startTime = Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date()) ?? Date()
        let endTime = Calendar.current.date(bySettingHour: 15, minute: 30, second: 0, of: Date()) ?? Date()
        
        schedule.monday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.tuesday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.wednesday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.thursday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.friday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.saturday = WorkDay(isWorkDay: false, startTime: startTime, endTime: endTime)
        schedule.sunday = WorkDay(isWorkDay: false, startTime: startTime, endTime: endTime)
        
        return schedule
    }
    
    private static func createAfternoonSchedule() -> WorkSchedule {
        var schedule = WorkSchedule()
        let startTime = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date()) ?? Date()
        let endTime = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date()) ?? Date()
        
        schedule.monday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.tuesday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.wednesday = WorkDay(isWorkDay: false, startTime: startTime, endTime: endTime)
        schedule.thursday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.friday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.saturday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.sunday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        
        return schedule
    }
    
    private static func createWeekendSchedule() -> WorkSchedule {
        var schedule = WorkSchedule()
        let startTime = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date()) ?? Date()
        let endTime = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date()
        
        schedule.monday = WorkDay(isWorkDay: false, startTime: startTime, endTime: endTime)
        schedule.tuesday = WorkDay(isWorkDay: false, startTime: startTime, endTime: endTime)
        schedule.wednesday = WorkDay(isWorkDay: false, startTime: startTime, endTime: endTime)
        schedule.thursday = WorkDay(isWorkDay: false, startTime: startTime, endTime: endTime)
        schedule.friday = WorkDay(isWorkDay: false, startTime: startTime, endTime: endTime)
        schedule.saturday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        schedule.sunday = WorkDay(isWorkDay: true, startTime: startTime, endTime: endTime)
        
        return schedule
    }
}
