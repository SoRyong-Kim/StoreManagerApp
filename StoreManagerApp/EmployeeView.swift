// MARK: - EmployeeView.swift (Purple Theme Applied)
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
            ScrollView {
                VStack(spacing: 24) {
                    // 헤더 섹션
                    VStack(spacing: 16) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.purple.opacity(0.8),
                                        Color.pink.opacity(0.6)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "person.2.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            )
                            .shadow(
                                color: Color.purple.opacity(0.3),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                        
                        Text("직원 관리")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 20)
                    
                    // 검색 바 및 통계
                    VStack(spacing: 16) {
                        HStack {
                            Circle()
                                .fill(Color.purple.opacity(0.1))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "magnifyingglass")
                                        .font(.caption)
                                        .foregroundColor(.purple)
                                )
                            
                            TextField("직원 검색", text: $searchText)
                                .font(.subheadline)
                                .padding(.vertical, 8)
                        }
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                                )
                        )
                        
                        // 직원 통계
                        HStack(spacing: 12) {
                            EmployeeStatCard(
                                title: "재직중",
                                count: activeEmployees.count,
                                icon: "person.fill",
                                color: .green
                            )
                            
                            EmployeeStatCard(
                                title: "퇴사",
                                count: inactiveEmployees.count,
                                icon: "person.slash.fill",
                                color: .red
                            )
                            
                            EmployeeStatCard(
                                title: "전체",
                                count: filteredEmployees.count,
                                icon: "person.2.fill",
                                color: .purple
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // 탭 선택
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            EmployeeTabButton(
                                title: "재직중",
                                count: activeEmployees.count,
                                isSelected: selectedTab == 0,
                                action: { selectedTab = 0 }
                            )
                            
                            EmployeeTabButton(
                                title: "퇴사",
                                count: inactiveEmployees.count,
                                isSelected: selectedTab == 1,
                                action: { selectedTab = 1 }
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // 직원 리스트
                        let employeesToShow = selectedTab == 0 ? activeEmployees : inactiveEmployees
                        
                        if employeesToShow.isEmpty {
                            EmptyEmployeeView(isActive: selectedTab == 0)
                                .padding(.horizontal, 20)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(employeesToShow) { employee in
                                    EmployeeRowCard(employee: employee) {
                                        selectedEmployee = employee
                                        showingEmployeeDetail = true
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.05),
                        Color.pink.opacity(0.03)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationBarHidden(true)
            .overlay(
                // 플로팅 추가 버튼
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showingAddEmployee = true }) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.purple.opacity(0.8),
                                            Color.pink.opacity(0.6)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 56, height: 56)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                )
                                .shadow(
                                    color: Color.purple.opacity(0.3),
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 30)
                    }
                }
            )
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
}

// MARK: - Supporting Views
struct EmployeeStatCard: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            color.opacity(0.8),
                            color.opacity(0.5)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundColor(.white)
                )
            
            Text("\(count)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(
                    color: color.opacity(0.1),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
    }
}

struct EmployeeTabButton: View {
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("(\(count))")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : .purple)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected ?
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.8),
                                Color.pink.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.1),
                                Color.purple.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color.clear : Color.purple.opacity(0.3),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(
                color: isSelected ? Color.purple.opacity(0.3) : Color.clear,
                radius: 4,
                x: 0,
                y: 2
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmployeeRowCard: View {
    let employee: Employee
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // 직원 아이콘
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                employee.isActive ? Color.green.opacity(0.8) : Color.gray.opacity(0.8),
                                employee.isActive ? Color.green.opacity(0.5) : Color.gray.opacity(0.5)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: employee.isActive ? "person.fill" : "person.slash.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(employee.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(employee.position)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.purple.opacity(0.1))
                            .foregroundColor(.purple)
                            .cornerRadius(8)
                    }
                    
                    HStack {
                        if !employee.phone.isEmpty {
                            HStack(spacing: 4) {
                                Image(systemName: "phone.fill")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                
                                Text(employee.phone)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        if employee.salary > 0 {
                            Text("₩\(Int(employee.salary).formatted())")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    // 상태 표시
                    HStack {
                        Circle()
                            .fill(employee.isActive ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        
                        Text(employee.isActive ? "재직중" : "퇴사")
                            .font(.caption)
                            .foregroundColor(employee.isActive ? .green : .red)
                        
                        Spacer()
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.purple.opacity(0.7))
            }
            .padding(16)
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.purple.opacity(0.1),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
    }
}

