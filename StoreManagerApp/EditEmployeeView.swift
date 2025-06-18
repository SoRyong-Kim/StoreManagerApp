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
            Form {
                Section("기본 정보") {
                    TextField("이름", text: $name)
                    TextField("직책", text: $position)
                    TextField("전화번호", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("이메일", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section("급여 정보") {
                    TextField("급여 (원)", text: $salary)
                        .keyboardType(.numberPad)
                }
                
                Section("근무 일정") {
                    NavigationLink("근무 시간 설정") {
                        WorkScheduleView(workSchedule: $workSchedule)
                    }
                }
                
                Section("메모") {
                    TextField("추가 정보나 메모", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("직원 정보 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        presentationMode.wrappedValue.dismiss()
                    }
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
                }
            }
        }
    }
}
