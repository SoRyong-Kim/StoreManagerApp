// MARK: - InitialSetupView.swift (Purple Theme Applied)
import SwiftUI

struct InitialSetupView: View {
    @EnvironmentObject var storeManager: StoreManager
    @State private var storeInfo = StoreInfo()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // 헤더 섹션
                    VStack(spacing: 20) {
                        // 메인 아이콘
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
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "storefront")
                                    .font(.system(size: 48))
                                    .foregroundColor(.white)
                            )
                            .shadow(
                                color: Color.purple.opacity(0.3),
                                radius: 12,
                                x: 0,
                                y: 6
                            )
                        
                        VStack(spacing: 8) {
                            Text("매장 관리 앱에")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("오신 것을 환영합니다!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        
                        Text("매장 정보를 설정하여 시작하세요")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    // 매장 정보 입력 섹션
                    VStack(spacing: 24) {
                        // 기본 정보
                        VStack(spacing: 16) {
                            SetupSectionHeaderView(title: "기본 정보", icon: "storefront")
                            
                            VStack(spacing: 12) {
                                SetupTextField(
                                    title: "매장명",
                                    text: $storeInfo.name,
                                    icon: "storefront",
                                    placeholder: "매장 이름을 입력하세요"
                                )
                                
                                SetupTextField(
                                    title: "주소",
                                    text: $storeInfo.address,
                                    icon: "location.fill",
                                    placeholder: "매장 주소를 입력하세요"
                                )
                                
                                SetupTextField(
                                    title: "전화번호",
                                    text: $storeInfo.phone,
                                    icon: "phone.fill",
                                    placeholder: "010-0000-0000",
                                    keyboardType: .phonePad
                                )
                            }
                            .padding(20)
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
                        
                        // 업종 및 운영 정보
                        VStack(spacing: 16) {
                            SetupSectionHeaderView(title: "운영 정보", icon: "clock.fill")
                            
                            VStack(spacing: 16) {
                                // 업종 선택
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(Color.purple.opacity(0.1))
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Image(systemName: "tag.fill")
                                                .font(.caption)
                                                .foregroundColor(.purple)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("업종")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        Picker("업종", selection: $storeInfo.category) {
                                            ForEach(StoreCategory.allCases, id: \.self) { category in
                                                Text(category.rawValue).tag(category)
                                            }
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .padding(.vertical, 4)
                                
                                SetupTextField(
                                    title: "영업시간",
                                    text: $storeInfo.businessHours,
                                    icon: "clock.fill",
                                    placeholder: "예: 09:00 - 22:00"
                                )
                            }
                            .padding(20)
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
                        
                        // 매장 소개
                        VStack(spacing: 16) {
                            SetupSectionHeaderView(title: "매장 소개", icon: "text.bubble.fill")
                            
                            VStack(spacing: 12) {
                                HStack(alignment: .top, spacing: 12) {
                                    Circle()
                                        .fill(Color.purple.opacity(0.1))
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Image(systemName: "text.bubble.fill")
                                                .font(.caption)
                                                .foregroundColor(.purple)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("소개글")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        TextEditor(text: $storeInfo.description)
                                            .frame(height: 100)
                                            .padding(12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.purple.opacity(0.05))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                                                    )
                                            )
                                    }
                                }
                            }
                            .padding(20)
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
                    
                    // 완료 버튼
                    Button(action: {
                        storeManager.storeInfo = storeInfo
                        storeManager.saveStoreInfo()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                            
                            Text("설정 완료")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    (storeInfo.name.isEmpty || storeInfo.address.isEmpty) ? Color.gray : Color.purple.opacity(0.8),
                                    (storeInfo.name.isEmpty || storeInfo.address.isEmpty) ? Color.gray : Color.pink.opacity(0.6)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(
                            color: Color.purple.opacity(0.3),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                    }
                    .disabled(storeInfo.name.isEmpty || storeInfo.address.isEmpty)
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
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
        }
    }
}

// MARK: - Supporting Views for Setup
struct SetupSectionHeaderView: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
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
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundColor(.white)
                )
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

struct SetupTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.purple.opacity(0.1))
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundColor(.purple)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
    }
}
