import SwiftUI

struct ProductDetailView: View {
    @State var product: Product
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.presentationMode) var presentationMode
    @State private var isEditing = false
    
    var stockStatus: (text: String, color: Color, icon: String) {
        switch product.stock {
        case 0:
            return ("품절", .red, "xmark.circle.fill")
        case 1...5:
            return ("재고 부족", .red, "exclamationmark.triangle.fill")
        case 6...10:
            return ("재고 주의", .orange, "exclamationmark.circle.fill")
        default:
            return ("재고 충분", .green, "checkmark.circle.fill")
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 상품 헤더
                    VStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: iconForCategory(product.category))
                                    .font(.system(size: 40))
                                    .foregroundColor(.blue)
                            )
                        
                        VStack(spacing: 8) {
                            Text(product.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(product.category)
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("₩\(Int(product.price).formatted())")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    
                    // 재고 정보
                    InfoSection(title: "재고 현황") {
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: stockStatus.icon)
                                    .foregroundColor(stockStatus.color)
                                
                                Text(stockStatus.text)
                                    .font(.headline)
                                    .foregroundColor(stockStatus.color)
                                
                                Spacer()
                                
                                Text("\(product.stock)개")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            if product.stock <= 10 {
                                HStack {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                    
                                    Text(product.stock == 0 ? "주문이 불가능합니다" : "재고 보충이 필요합니다")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                    
                    // 상품 정보
                    InfoSection(title: "상품 정보") {
                        VStack(spacing: 8) {
                            InfoRow(label: "상품명", value: product.name)
                            InfoRow(label: "카테고리", value: product.category)
                            InfoRow(label: "판매가격", value: "₩\(Int(product.price).formatted())")
                            InfoRow(label: "등록일", value: "오늘") // 실제로는 등록일 필드 추가 필요
                        }
                    }
                    
                    // 판매 통계 (가상 데이터)
                    InfoSection(title: "판매 통계") {
                        VStack(spacing: 8) {
                            InfoRow(label: "오늘 판매", value: "\(Int.random(in: 0...15))개")
                            InfoRow(label: "이번 주 판매", value: "\(Int.random(in: 5...50))개")
                            InfoRow(label: "이번 달 판매", value: "\(Int.random(in: 20...200))개")
                        }
                    }
                    
                    // 액션 버튼들
                    VStack(spacing: 12) {
                        Button(action: {
                            isEditing = true
                        }) {
                            Label("상품 정보 수정", systemImage: "pencil")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                updateStock(-1)
                            }) {
                                Label("재고 -1", systemImage: "minus.circle")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }
                            .disabled(product.stock <= 0)
                            
                            Button(action: {
                                updateStock(1)
                            }) {
                                Label("재고 +1", systemImage: "plus.circle")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
                        }
                        
                        Button(action: {
                            showStockUpdateAlert()
                        }) {
                            Label("재고 일괄 수정", systemImage: "square.and.pencil")
                                .font(.headline)
                                .foregroundColor(.orange)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("상품 상세")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(isPresented: $isEditing) {
                EditProductView(product: $product)
                    .environmentObject(storeManager)
            }
        }
    }
    
    private func updateStock(_ change: Int) {
        let newStock = max(0, product.stock + change)
        product.stock = newStock
        storeManager.updateProduct(product)
    }
    
    private func showStockUpdateAlert() {
        // 재고 일괄 수정 알림 (간단한 버전)
        // 실제로는 더 복잡한 입력 창이 필요
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
