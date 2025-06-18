// MARK: - AddEmployeeView.swift (직원 추가)
import SwiftUI

struct AddEmployeeView: View {
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var position = ""
    @State private var phone = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("직원 정보") {
                    TextField("이름", text: $name)
                    TextField("직책", text: $position)
                    TextField("전화번호", text: $phone)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("새 직원 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        let employee = Employee(name: name, position: position, phone: phone)
                        storeManager.addEmployee(employee)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty || position.isEmpty)
                }
            }
        }
    }
}
