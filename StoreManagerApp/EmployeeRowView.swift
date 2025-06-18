import SwiftUI

struct EmployeeRowView: View {
    let employee: Employee
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // 프로필 이미지
                Circle()
                    .fill(employee.isActive ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(String(employee.name.prefix(1)))
                            .font(.headline)
                            .foregroundColor(employee.isActive ? .blue : .gray)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(employee.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        if !employee.isActive {
                            Text("퇴사")
                                .font(.caption)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.red.opacity(0.2))
                                .foregroundColor(.red)
                                .cornerRadius(4)
                        }
                        
                        Spacer()
                    }
                    
                    Text(employee.position)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if !employee.phone.isEmpty {
                        Text(employee.phone)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
