// MARK: - Updated DashboardView.swift (기존 DashboardView.swift 교체)
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var storeManager: StoreManager
    
    // 오늘 요일 구하기 (0: 월요일, 1: 화요일, ..., 6: 일요일)
    private var todayIndex: Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        // Calendar의 weekday는 1(일요일)부터 시작하므로 변환
        return weekday == 1 ? 6 : weekday - 2
    }
    
    // 오늘 근무하는 직원들
    private var todayWorkingEmployees: [Employee] {
        return storeManager.employees.filter { employee in
            guard employee.isActive else { return false }
            
            let workDay = employee.workSchedule.workDays[todayIndex]
            return workDay.isWorkDay
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 통계 카드들
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatCard(
                            title: "총 직원 수",
                            value: "\(storeManager.employees.count)명",
                            icon: "person.2.fill",
                            color: .blue
                        )
                        
                        StatCard(
                            title: "등록 상품",
                            value: "\(storeManager.products.count)개",
                            icon: "cube.box.fill",
                            color: .green
                        )
                        
                        StatCard(
                            title: "오늘 근무자",
                            value: "\(todayWorkingEmployees.count)명",
                            icon: "person.crop.circle.badge.clock",
                            color: .orange
                        )
                    }
                    
                    // 매장 정보 카드
                    InfoSection(title: "매장 정보") {
                        VStack(spacing: 12) {
                            InfoRow(label: "매장명", value: storeManager.storeInfo.name)
                            InfoRow(label: "업종", value: storeManager.storeInfo.category.rawValue)
                            InfoRow(label: "주소", value: storeManager.storeInfo.address)
                            InfoRow(label: "영업시간", value: storeManager.storeInfo.businessHours)
                        }
                    }
                    
                    // 오늘 근무표
                    InfoSection(title: "오늘 근무표 (\(getCurrentDayName()))") {
                        if todayWorkingEmployees.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "person.slash")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                
                                Text("오늘 근무하는 직원이 없습니다")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(todayWorkingEmployees.sorted(by: { getStartTime($0) < getStartTime($1) })) { employee in
                                    TodayEmployeeRow(employee: employee, todayIndex: todayIndex)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("대시보드")
        }
    }
    
    // 현재 요일 이름 가져오기
    private func getCurrentDayName() -> String {
        let dayNames = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
        return dayNames[todayIndex]
    }
    
    // 직원의 오늘 시작 시간 가져오기 (정렬용)
    private func getStartTime(_ employee: Employee) -> Date {
        return employee.workSchedule.workDays[todayIndex].startTime
    }
}

// MARK: - 오늘 근무 직원 행 컴포넌트
struct TodayEmployeeRow: View {
    let employee: Employee
    let todayIndex: Int
    
    private var todayWorkDay: WorkDay {
        employee.workSchedule.workDays[todayIndex]
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // 직원 프로필
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(employee.name.prefix(1)))
                        .font(.headline)
                        .foregroundColor(.blue)
                )
            
            // 직원 정보
            VStack(alignment: .leading, spacing: 2) {
                Text(employee.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(employee.position)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 근무 시간
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(timeFormatter.string(from: todayWorkDay.startTime)) - \(timeFormatter.string(from: todayWorkDay.endTime))")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(getWorkStatusText())
                    .font(.caption)
                    .foregroundColor(getWorkStatusColor())
            }
        }
        .padding(.vertical, 4)
    }
    
    // 현재 근무 상태 텍스트
    private func getWorkStatusText() -> String {
        let now = Date()
        let calendar = Calendar.current
        
        let startTime = todayWorkDay.startTime
        let endTime = todayWorkDay.endTime
        
        // 현재 시간을 오늘 날짜로 조정
        let todayStart = calendar.date(bySettingHour: calendar.component(.hour, from: startTime),
                                     minute: calendar.component(.minute, from: startTime),
                                     second: 0,
                                     of: now) ?? now
        let todayEnd = calendar.date(bySettingHour: calendar.component(.hour, from: endTime),
                                   minute: calendar.component(.minute, from: endTime),
                                   second: 0,
                                   of: now) ?? now
        
        if now < todayStart {
            let timeDiff = todayStart.timeIntervalSince(now)
            let hours = Int(timeDiff / 3600)
            let minutes = Int((timeDiff.truncatingRemainder(dividingBy: 3600)) / 60)
            
            if hours > 0 {
                return "\(hours)시간 \(minutes)분 후 출근"
            } else {
                return "\(minutes)분 후 출근"
            }
        } else if now >= todayStart && now <= todayEnd {
            return "근무 중"
        } else {
            return "근무 종료"
        }
    }
    
    // 근무 상태 색상
    private func getWorkStatusColor() -> Color {
        let now = Date()
        let calendar = Calendar.current
        
        let startTime = todayWorkDay.startTime
        let endTime = todayWorkDay.endTime
        
        let todayStart = calendar.date(bySettingHour: calendar.component(.hour, from: startTime),
                                     minute: calendar.component(.minute, from: startTime),
                                     second: 0,
                                     of: now) ?? now
        let todayEnd = calendar.date(bySettingHour: calendar.component(.hour, from: endTime),
                                   minute: calendar.component(.minute, from: endTime),
                                   second: 0,
                                   of: now) ?? now
        
        if now < todayStart {
            return .orange  // 출근 전
        } else if now >= todayStart && now <= todayEnd {
            return .green   // 근무 중
        } else {
            return .gray    // 근무 종료
        }
    }
}
