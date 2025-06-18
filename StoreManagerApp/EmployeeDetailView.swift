import SwiftUI

struct EmployeeDetailView: View {
    @State var employee: Employee
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.presentationMode) var presentationMode
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 프로필 헤더
                    VStack(spacing: 16) {
                        Circle()
                            .fill(employee.isActive ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text(String(employee.name.prefix(1)))
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(employee.isActive ? .blue : .gray)
                            )
                        
                        VStack(spacing: 4) {
                            Text(employee.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(employee.position)
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Text(employee.isActive ? "재직중" : "퇴사")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(employee.isActive ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                                    .foregroundColor(employee.isActive ? .green : .red)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    
                    // 연락처 정보
                    InfoSection(title: "연락처") {
                        InfoRow(label: "전화번호", value: employee.phone.isEmpty ? "등록되지 않음" : employee.phone)
                        InfoRow(label: "이메일", value: employee.email.isEmpty ? "등록되지 않음" : employee.email)
                    }
                    
                    // 근무 정보
                    InfoSection(title: "근무 정보") {
                        InfoRow(label: "입사일", value: DateFormatter.short.string(from: employee.hireDate))
                        InfoRow(label: "급여", value: employee.salary > 0 ? "₩\(Int(employee.salary).formatted())" : "미설정")
                    }
                    
                    // 근무 시간
                    InfoSection(title: "근무 시간") {
                        VStack(spacing: 8) {
                            ForEach(0..<7, id: \.self) { index in
                                HStack {
                                    Text(employee.workSchedule.weekDayNames[index])
                                        .frame(width: 30, alignment: .leading)
                                    Spacer()
                                    Text(employee.workSchedule.workDays[index].timeString)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    
                    // 메모
                    if !employee.notes.isEmpty {
                        InfoSection(title: "메모") {
                            Text(employee.notes)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    // 액션 버튼들
                    VStack(spacing: 12) {
                        Button(action: {
                            isEditing = true
                        }) {
                            Label("직원 정보 수정", systemImage: "pencil")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            storeManager.toggleEmployeeStatus(employee)
                            employee.isActive.toggle()
                        }) {
                            Label(employee.isActive ? "퇴사 처리" : "복직 처리",
                                  systemImage: employee.isActive ? "person.badge.minus" : "person.badge.plus")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(employee.isActive ? Color.orange : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("직원 상세")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(isPresented: $isEditing) {
                EditEmployeeView(employee: $employee)
                    .environmentObject(storeManager)
            }
        }
    }
}
