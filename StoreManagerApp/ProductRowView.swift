import SwiftUI

struct ProductRowView: View {
    let product: Product
    let onTap: () -> Void
    
    var stockStatus: (text: String, color: Color, bgColor: Color) {
        switch product.stock {
        case 0:
            return ("품절", .white, .red)
        case 1...10:
            return ("부족", .white, .orange)
        default:
            return ("충분", .white, .green)
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // 상단 그라데이션 배경
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.8),
                        Color.pink.opacity(0.6)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 60)
                .overlay(
                    HStack(spacing: 12) {
                        // 상품 아이콘 - 글래스모피즘 효과
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                            .overlay(
                                Image(systemName: iconForCategory(product.category))
                                    .font(.title3)
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(product.name)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .lineLimit(1)
                            
                            Text(product.category)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        // 재고 상태 배지
                        HStack(spacing: 4) {
                            Circle()
                                .fill(stockStatus.bgColor)
                                .frame(width: 8, height: 8)
                            
                            Text(stockStatus.text)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.2))
                        )
                    }
                    .padding(.horizontal, 16)
                )
                
                // 하단 정보 영역
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("가격")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("₩\(Int(product.price).formatted())")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        
                        HStack {
                            Text("재고")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Text("\(product.stock)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(stockStatus.bgColor)
                                
                                Text("개")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // 오른쪽 화살표
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title2)
                        .foregroundColor(.purple.opacity(0.7))
                }
                .padding(16)
                .background(Color(.systemBackground))
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.purple.opacity(0.15),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
        .padding(.horizontal, 2)
        .padding(.vertical, 4)
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
