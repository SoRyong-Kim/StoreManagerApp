import SwiftUI

// MARK: - InfoSection 컴포넌트
struct InfoSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                content
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

// MARK: - InfoRow 컴포넌트
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

// MARK: - SearchBar 컴포넌트
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("검색...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button("취소") {
                    text = ""
                }
                .foregroundColor(.blue)
                .font(.caption)
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 36)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// MARK: - EmptyStateView 컴포넌트
struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
}

// MARK: - CustomTextField 컴포넌트 (향상된 버전)
struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String?
    let keyboardType: UIKeyboardType
    
    init(_ title: String, text: Binding<String>, placeholder: String? = nil, keyboardType: UIKeyboardType = .default) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            TextField(placeholder ?? title, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .keyboardType(keyboardType)
                .padding(.horizontal, 16)
                .frame(height: 50)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let short: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
}

// MARK: - Color Extension
extension Color {
    static let customBlue = Color(red: 0.0, green: 0.48, blue: 1.0)
    static let customGreen = Color(red: 0.2, green: 0.8, blue: 0.2)
    static let customOrange = Color(red: 1.0, green: 0.6, blue: 0.0)
    static let customRed = Color(red: 1.0, green: 0.23, blue: 0.19)
}
