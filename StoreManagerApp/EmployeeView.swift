// MARK: - EmployeeView.swift (직원 관리)
import SwiftUI

struct EmployeeView: View {
    @EnvironmentObject var storeManager: StoreManager
    @State private var showingAddEmployee = false
    @State private var searchText = ""
    @State private var selectedEmployee: Employee?
    @State private var showingEmployeeDetail = false
    @State private var selectedTab = 0
    
    var filteredEmployees: [Employee] {
        storeManager.searchEmployees(query: searchText)
    }
    
    var activeEmployees: [Employee] {
        filteredEmployees.filter { $0.isActive }
    }
    
    var inactiveEmployees: [Employee] {
        filteredEmployees.filter { !$0.isActive }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 검색 바
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // 탭 선택
                Picker("직원 상태", selection: $selectedTab) {
                    Text("재직중 (\(activeEmployees.count))").tag(0)
                    Text("퇴사 (\(inactiveEmployees.count))").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // 직원 리스트
                List {
                    let employeesToShow = selectedTab == 0 ? activeEmployees : inactiveEmployees
                    
                    if employeesToShow.isEmpty {
                        EmptyEmployeeView(isActive: selectedTab == 0)
                    } else {
                        ForEach(employeesToShow) { employee in
                            EmployeeRowView(employee: employee) {
                                selectedEmployee = employee
                                showingEmployeeDetail = true
                            }
                        }
                        .onDelete(perform: deleteEmployee)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("직원 관리")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEmployee = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddEmployee) {
                AddEmployeeView()
                    .environmentObject(storeManager)
            }
            .sheet(item: $selectedEmployee) { employee in
                EmployeeDetailView(employee: employee)
                    .environmentObject(storeManager)
            }
        }
        .onAppear {
            storeManager.loadEmployees()
        }
    }
    
    func deleteEmployee(offsets: IndexSet) {
        let employeesToShow = selectedTab == 0 ? activeEmployees : inactiveEmployees
        for index in offsets {
            storeManager.removeEmployee(employeesToShow[index])
        }
    }
}
