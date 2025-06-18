import SwiftUI

struct WorkScheduleView: View {
    @Binding var workSchedule: WorkSchedule
    
    var body: some View {
        List {
            ForEach(0..<7, id: \.self) { index in
                WorkDayRow(
                    dayName: workSchedule.weekDayNames[index],
                    workDay: binding(for: index)
                )
            }
        }
        .navigationTitle("근무 시간 설정")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func binding(for index: Int) -> Binding<WorkDay> {
        switch index {
        case 0: return $workSchedule.monday
        case 1: return $workSchedule.tuesday
        case 2: return $workSchedule.wednesday
        case 3: return $workSchedule.thursday
        case 4: return $workSchedule.friday
        case 5: return $workSchedule.saturday
        case 6: return $workSchedule.sunday
        default: return $workSchedule.monday
        }
    }
}

struct WorkDayRow: View {
    let dayName: String
    @Binding var workDay: WorkDay
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(dayName)
                    .font(.headline)
                Spacer()
                Toggle("", isOn: $workDay.isWorkDay)
            }
            
            if workDay.isWorkDay {
                HStack {
                    DatePicker("시작", selection: $workDay.startTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    
                    Text("-")
                        .foregroundColor(.secondary)
                    
                    DatePicker("종료", selection: $workDay.endTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    
                    Spacer()
                }
                .padding(.leading)
            }
        }
        .padding(.vertical, 4)
    }
}
