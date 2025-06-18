import SwiftUI

struct EditEmployeeView: View {
    @Binding var employee: Employee
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var position: String
    @State private var phone: String
    @State private var email: String
    @State private var salary: String
    @State private var notes: String
    @State private var workSchedule: WorkSchedule
    
    init(employee: Binding<Employee>) {
        self._employee = employee
        self._name = State(initialValue: employee.wrappedValue.name)
        self._position = State(initialValue: employee.wrappedValue.position)
        self._phone = State(initialValue: employee.wrappedValue.phone)
        self._email = State(initialValue: employee.wrappedValue.email)
        self._salary = State(initialValue: employee.wrappedValue.salary > 0 ? String(Int(employee.wrappedValue.salary)) : "")
        self._notes = State(initialValue: employee.wrappedValue.notes)
        self._workSchedule = State(initialValue: employee.wrappedValue.workSchedule)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // 그라데이션 배경
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.1),
                        Color.pink.opacity(0.1),
                        Color.blue.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                Form {
                    Section {
                        // 프로필 아이콘
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.purple, Color.pink]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                    .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .listRowBackground(Color.clear)
                    }
                    
                    Section {
                        // 이름 필드
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.pink, Color.purple]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 30, height: 30)
                                
                                Image(systemName: "person")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                            
                            TextField("이름", text: $name)
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                        )
                        
                        // 직책 필드
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 30, height: 30)
                                
                                Image(systemName: "briefcase")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                            
                            TextField("직책", text: $position)
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                        )
                        
                        // 전화번호 필드
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.green, Color.blue]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 30, height: 30)
                                
                                Image(systemName: "phone")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                            
                            TextField("전화번호", text: $phone)
                                .keyboardType(.phonePad)
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                        )
                        
                        // 이메일 필드
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.orange, Color.pink]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 30, height: 30)
                                
                                Image(systemName: "envelope")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                            
                            TextField("이메일", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                        )
                    } header: {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.purple, Color.blue]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 25, height: 25)
                                    .shadow(color: Color.purple.opacity(0.3), radius: 3, x: 0, y: 1)
                                
                                Image(systemName: "person.circle")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                            
                            Text("기본 정보")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Section {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 30, height: 30)
                                
                                Image(systemName: "wonsign")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                            
                            TextField("급여 (원)", text: $salary)
                                .keyboardType(.numberPad)
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                        )
                    } header: {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 25, height: 25)
                                    .shadow(color: Color.orange.opacity(0.3), radius: 3, x: 0, y: 1)
                                
                                Image(systemName: "won.circle")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                            
                            Text("급여 정보")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Section {
                        NavigationLink("근무 시간 설정") {
                            WorkScheduleView(workSchedule: $workSchedule)
                        }
                        .overlay(
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 30, height: 30)
                                    
                                    Image(systemName: "clock")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                            }
                        )
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                        )
                    } header: {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 25, height: 25)
                                    .shadow(color: Color.blue.opacity(0.3), radius: 3, x: 0, y: 1)
                                
                                Image(systemName: "calendar.circle")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                            
                            Text("근무 일정")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Section {
                        HStack(alignment: .top) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.orange, Color.red]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 30, height: 30)
                                
                                Image(systemName: "note.text")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                            
                            TextField("추가 정보나 메모", text: $notes, axis: .vertical)
                                .lineLimit(3...6)
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                        )
                    } header: {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.orange, Color.red]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 25, height: 25)
                                    .shadow(color: Color.orange.opacity(0.3), radius: 3, x: 0, y: 1)
                                
                                Image(systemName: "note.text")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                            
                            Text("메모")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("직원 정보 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.purple)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        employee.name = name
                        employee.position = position
                        employee.phone = phone
                        employee.email = email
                        employee.salary = Double(salary) ?? 0
                        employee.notes = notes
                        employee.workSchedule = workSchedule
                        
                        storeManager.updateEmployee(employee)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty || position.isEmpty)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: name.isEmpty || position.isEmpty ?
                                [Color.gray.opacity(0.3)] : [Color.purple, Color.pink]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(color: Color.purple.opacity(0.3), radius: 5, x: 0, y: 2)
                }
            }
        }
    }
}
