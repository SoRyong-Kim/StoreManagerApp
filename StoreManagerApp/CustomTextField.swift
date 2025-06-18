// MARK: - CustomTextField.swift (커스텀 텍스트 필드)
import SwiftUI

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            TextField(title, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 16)
                .frame(height: 50)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
}
