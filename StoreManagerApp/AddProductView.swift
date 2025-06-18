// MARK: - AddProductView.swift (Purple Theme Applied)
import SwiftUI

struct AddProductView: View {
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var price = ""
    @State private var category = ""
    @State private var stock = ""
    
    // 카테고리 옵션들
    private let categoryOptions = ["커피", "음료", "디저트", "브런치", "원두", "굿즈", "기타"]
    
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
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            )
                            .shadow(
                                color: Color.purple.opacity(0.3),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                        
                        Text("새 상품 추가")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 20)
                    
                    // 기본 정보 섹션
                    VStack(spacing: 16) {
                        ProductSectionHeaderView(title: "기본 정보", icon: "cube.box.fill")
                        
                        VStack(spacing: 12) {
                            ProductTextField(
                                title: "상품명",
                                text: $name,
                                icon: "cube.box.fill",
                                placeholder: "상품 이름을 입력하세요",
                                keyboardType: .default
                            )
                            
                            ProductTextField(
                                title: "가격",
                                text: $price,
                                icon: "won.sign.circle.fill",
                                placeholder: "가격을 입력하세요",
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
                    
                    // 카테고리 섹션
                    VStack(spacing: 16) {
                        ProductSectionHeaderView(title: "카테고리", icon: "tag.fill")
                        
                        VStack(spacing: 16) {
                            // 카테고리 선택 그리드
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                                ForEach(categoryOptions, id: \.self) { option in
                                    CategoryButton(
                                        title: option,
                                        isSelected: category == option,
                                        action: {
                                            category = option
                                        }
                                    )
                                }
                            }
                            
                            // 직접 입력 필드
                            ProductTextField(
                                title: "직접 입력",
                                text: $category,
                                icon: "pencil.circle.fill",
                                placeholder: "카테고리를 직접 입력하세요",
                                keyboardType: .default
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
                    
                    // 재고 섹션
                    VStack(spacing: 16) {
                        ProductSectionHeaderView(title: "재고", icon: "archivebox.fill")
                        
                        VStack(spacing: 16) {
                            ProductTextField(
                                title: "초기 재고",
                                text: $stock,
                                icon: "archivebox.fill",
                                placeholder: "재고 수량을 입력하세요",
                                keyboardType: .numberPad,
                                suffix: "개"
                            )
                            
                            // 빠른 재고 설정
                            VStack(alignment: .leading, spacing: 8) {
                                Text("빠른 설정")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                
                                HStack(spacing: 8) {
                                    QuickStockButton(value: "10", currentStock: $stock)
                                    QuickStockButton(value: "50", currentStock: $stock)
                                    QuickStockButton(value: "100", currentStock: $stock)
                                    QuickStockButton(value: "200", currentStock: $stock)
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
                    
                    // 안내 메시지
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "info.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            )
                        
                        Text("상품을 등록하면 바로 판매가 가능합니다.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                            )
                    )
                    
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
                            let product = Product(
                                name: name,
                                price: Double(price) ?? 0,
                                category: category.isEmpty ? "기타" : category,
                                stock: Int(stock) ?? 0
                            )
                            storeManager.addProduct(product)
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
                                        name.isEmpty || price.isEmpty ? Color.gray : Color.purple.opacity(0.8),
                                        name.isEmpty || price.isEmpty ? Color.gray : Color.pink.opacity(0.6)
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
                        .disabled(name.isEmpty || price.isEmpty)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                    
                    Spacer()
                }
            )
        }
    }
}

// MARK: - Supporting Views for Product
struct ProductSectionHeaderView: View {
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

struct ProductTextField: View {
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
                        .autocorrectionDisabled()
                    
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

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .purple)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
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
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    isSelected ? Color.clear : Color.purple.opacity(0.3),
                                    lineWidth: 1
                                )
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuickStockButton: View {
    let value: String
    @Binding var currentStock: String
    
    var body: some View {
        Button(action: {
            currentStock = value
        }) {
            Text("\(value)개")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(currentStock == value ? .white : .purple)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            currentStock == value ?
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
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    currentStock == value ? Color.clear : Color.purple.opacity(0.3),
                                    lineWidth: 1
                                )
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
