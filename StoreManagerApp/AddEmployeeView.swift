// MARK: - AddEmployeeView.swift (Purple Theme Applied)
import SwiftUI

struct AddEmployeeView: View {
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var position = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var salary = ""
    @State private var notes = ""
    @State private var workSchedule = WorkSchedule()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
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
                                Image(systemName: "person.badge.plus.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            )
                            .shadow(
                                color: Color.purple.opacity(0.3),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                        
                        Text("새 직원 추가")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 20)
                    
                    // 기본 정보 섹션
                    VStack(spacing: 16) {
                        SectionHeaderView(title: "기본 정보", icon: "person.fill")
                        
                        VStack(spacing: 12) {
                            CustomTextField(
                                title: "이름",
                                text: $name,
                                icon: "person.fill",
                                placeholder: "직원 이름을 입력하세요",
                                keyboardType: .default
                            )
                            
                            CustomTextField(
                                title: "직책",
                                text: $position,
                                icon: "briefcase.fill",
                                placeholder: "직책을 입력하세요",
                                keyboardType: .default
                            )
                            
                            CustomTextField(
                                title: "전화번호",
                                text: $phone,
                                icon: "phone.fill",
                                placeholder: "010-0000-0000",
                                keyboardType: .phonePad
                            )
                            
                            CustomTextField(
                                title: "이메일",
                                text: $email,
                                icon: "envelope.fill",
                                placeholder: "example@email.com",
                                keyboardType: .emailAddress
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
                    
                    // 급여 정보 섹션
                    VStack(spacing: 16) {
                        SectionHeaderView(title: "급여 정보", icon: "won.sign.circle.fill")
                        
                        VStack(spacing: 12) {
                            CustomTextField(
                                title: "급여",
                                text: $salary,
                                icon: "won.sign.circle.fill",
                                placeholder: "급여를 입력하세요",
                                keyboardType: .numberPad,
                                suffix: "원"
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
                    
                    // 근무 일정 섹션
                    VStack(spacing: 16) {
                        SectionHeaderView(title: "근무 일정", icon: "calendar.badge.clock")
                        
                        NavigationLink(destination: WorkScheduleView(workSchedule: $workSchedule)) {
                            HStack(spacing: 16) {
                                Circle()
                                    .fill(Color.purple.opacity(0.1))
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Image(systemName: "calendar.badge.clock")
                                            .font(.title3)
                                            .foregroundColor(.purple)
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("근무 시간 설정")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text("주간 근무 스케줄을 설정하세요")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.purple.opacity(0.7))
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
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // 메모 섹션
                    VStack(spacing: 16) {
                        SectionHeaderView(title: "메모", icon: "note.text")
                        
                        VStack(spacing: 12) {
                            HStack(alignment: .top, spacing: 12) {
                                Circle()
                                    .fill(Color.purple.opacity(0.1))
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Image(systemName: "note.text")
                                            .font(.caption)
                                            .foregroundColor(.purple)
                                    )
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("추가 정보")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    TextField("추가 정보나 메모를 입력하세요", text: $notes, axis: .vertical)
                                        .lineLimit(3...6)
                                        .textFieldStyle(PlainTextFieldStyle())
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
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
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
                // 커스텀 네비게이션 바
                VStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Circle()
                                .fill(Color(.systemBackground))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "xmark")
                                        .font(.title3)
                                        .foregroundColor(.primary)
                                )
                                .shadow(
                                    color: Color.black.opacity(0.1),
                                    radius: 4,
                                    x: 0,
                                    y: 2
                                )
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            let employee = Employee(
                                name: name,
                                position: position,
                                phone: phone,
                                email: email,
                                salary: Double(salary) ?? 0,
                                workSchedule: workSchedule,
                                notes: notes
                            )
                            storeManager.addEmployee(employee)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                Text("저장")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        name.isEmpty || position.isEmpty ? Color.gray : Color.purple.opacity(0.8),
                                        name.isEmpty || position.isEmpty ? Color.gray : Color.pink.opacity(0.6)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(
                                color: Color.purple.opacity(0.3),
                                radius: 4,
                                x: 0,
                                y: 2
                            )
                        }
                        .disabled(name.isEmpty || position.isEmpty)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                    
                    Spacer()
                }
            )
        }
    }
}

// MARK: - Supporting Views
struct SectionHeaderView: View {
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

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var suffix: String? = nil
    
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
                
                HStack {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                    
                    if let suffix = suffix {
                        Text(suffix)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
    }
}
