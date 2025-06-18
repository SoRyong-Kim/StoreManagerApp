import SwiftUI

struct EmptyEmployeeView: View {
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: isActive ? "person.badge.plus" : "person.badge.minus")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text(isActive ? "등록된 직원이 없습니다" : "퇴사한 직원이 없습니다")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(isActive ? "새 직원을 추가해보세요" : "")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
}
