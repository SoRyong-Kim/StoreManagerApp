import SwiftUI

struct EmptyEmployeeView: View {
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(Color.purple.opacity(0.1))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: isActive ? "person.badge.plus" : "person.slash")
                        .font(.system(size: 32))
                        .foregroundColor(.purple.opacity(0.7))
                )
            
            VStack(spacing: 8) {
                Text(isActive ? "재직중인 직원이 없습니다" : "퇴사한 직원이 없습니다")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(isActive ? "새 직원을 추가해보세요" : "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.purple.opacity(0.1),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
    }
}
