import SwiftUI

struct ProductRowView: View {
    let product: Product
    let onTap: () -> Void
    
    var stockStatus: (text: String, color: Color) {
        switch product.stock {
        case 0:
            return ("품절", .red)
        case 1...10:
            return ("부족", .orange)
        default:
            return ("충분", .green)
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // 상품 아이콘
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: iconForCategory(product.category))
                            .font(.title2)
                            .foregroundColor(.blue)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(product.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("₩\(Int(product.price).formatted())")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    
                    HStack {
                        Text(product.category)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Text("재고:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("\(product.stock)개")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(stockStatus.color)
                        }
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
    
    private func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "커피": return "cup.and.saucer.fill"
        case "음료": return "wineglass.fill"
        case "디저트": return "birthday.cake.fill"
        case "브런치": return "fork.knife"
        case "원두": return "leaf.fill"
        case "굿즈": return "bag.fill"
        default: return "cube.box.fill"
        }
    }
}
