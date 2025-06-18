// MARK: - EmployeeView.swift (직원 관리)
import SwiftUI

struct EmployeeView: View {
    @EnvironmentObject var storeManager: StoreManager
    @State private var showingAddEmployee = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(storeManager.employees) { employee in
                    EmployeeRow(employee: employee)
                }
                .onDelete(perform: deleteEmployee)
            }
            .navigationTitle("직원 관리")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEmployee = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEmployee) {
                AddEmployeeView()
                    .environmentObject(storeManager)
            }
        }
    }
    
    func deleteEmployee(offsets: IndexSet) {
        for index in offsets {
            storeManager.removeEmployee(storeManager.employees[index])
        }
    }
}

struct EmployeeRow: View {
    let employee: Employee
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(employee.name)
                .font(.headline)
            Text(employee.position)
                .font(.subheadline)
                .foregroundColor(.secondary)
            if !employee.phone.isEmpty {
                Text(employee.phone)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
