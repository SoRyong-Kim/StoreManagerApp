import SwiftUI

struct MonthlySalesStatsView: View {
    @StateObject private var salesManager = SalesManager()
    @State private var selectedMonth: String? // ID 대신 String으로 변경
    @State private var showingPeriodSelector = false
    @State private var selectedPeriod = "최근 6개월"
    
    private let periodOptions = ["최근 3개월", "최근 6개월", "최근 12개월", "전체 기간"]
    
    var monthlySalesData: [MonthlySalesData] {
        let allData = salesManager.getMonthlySalesData()
        switch selectedPeriod {
        case "최근 3개월":
            return Array(allData.prefix(3))
        case "최근 6개월":
            return Array(allData.prefix(6))
        case "최근 12개월":
            return Array(allData.prefix(12))
        default:
            return allData
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 기간 선택 헤더
                    HStack {
                        Button(action: { showingPeriodSelector = true }) {
                            HStack {
                                Text(selectedPeriod)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.blue)
                            }
                        }
                        .actionSheet(isPresented: $showingPeriodSelector) {
                            ActionSheet(
                                title: Text("기간 선택"),
                                buttons: periodOptions.map { period in
                                    .default(Text(period)) {
                                        selectedPeriod = period
                                    }
                                } + [.cancel()]
                            )
                        }
                        
                        Spacer()
                        
                        Text("총 \(monthlySalesData.count)개월")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // 전체 요약 카드
                    SalesSummaryCard(data: monthlySalesData)
                        .padding(.horizontal)
                    
                    // 월별 매출 차트
                    if !monthlySalesData.isEmpty {
                        MonthlySalesChart(data: monthlySalesData)
                            .padding(.horizontal)
                    }
                    
                    // 월별 상세 데이터
                    LazyVStack(spacing: 12) {
                        ForEach(monthlySalesData, id: \.monthYear) { monthData in // id 명시적 지정
                            MonthlyDataCard(
                                data: monthData,
                                isExpanded: selectedMonth == monthData.monthYear // monthYear로 비교
                            ) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if selectedMonth == monthData.monthYear {
                                        selectedMonth = nil
                                    } else {
                                        selectedMonth = monthData.monthYear
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("월별 판매 통계")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SalesSummaryCard: View {
    let data: [MonthlySalesData]
    
    var totalSales: Double {
        data.reduce(0) { $0 + $1.totalSales }
    }
    
    var totalQuantity: Int {
        data.reduce(0) { $0 + $1.totalQuantity }
    }
    
    var averageMonthlySales: Double {
        guard !data.isEmpty else { return 0 }
        return totalSales / Double(data.count)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("전체 요약")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                SummaryItem(
                    title: "총 매출",
                    value: "\(Int(totalSales).formattedWithComma)원",
                    icon: "creditcard.fill",
                    color: .green
                )
                
                SummaryItem(
                    title: "판매 수량",
                    value: "\(totalQuantity.formattedWithComma)개",
                    icon: "cube.box.fill",
                    color: .blue
                )
            }
            
            HStack(spacing: 16) {
                SummaryItem(
                    title: "월평균 매출",
                    value: "\(Int(averageMonthlySales).formattedWithComma)원",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .orange
                )
                
                SummaryItem(
                    title: "분석 기간",
                    value: "\(data.count)개월",
                    icon: "calendar",
                    color: .purple
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct SummaryItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
}

// MARK: - MonthlySalesChart (월별 매출 차트)
struct MonthlySalesChart: View {
    let data: [MonthlySalesData]
    
    private var maxSales: Double {
        data.map { $0.totalSales }.max() ?? 1
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("월별 매출 추이")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom, spacing: 12) {
                    ForEach(data.reversed(), id: \.monthYear) { monthData in // id 명시적 지정
                        VStack(spacing: 8) {
                            Text("\(Int(monthData.totalSales / 10000))만원")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [.blue.opacity(0.8), .blue.opacity(0.4)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .frame(width: 30, height: CGFloat(monthData.totalSales / maxSales * 120))
                                .cornerRadius(4)
                            
                            Text(monthData.monthYear.replacingOccurrences(of: "년", with: "\n").replacingOccurrences(of: "월", with: ""))
                                .font(.caption2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - MonthlyDataCard (월별 상세 데이터 카드)
struct MonthlyDataCard: View {
    let data: MonthlySalesData
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // 헤더 - 클릭 영역 개선
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(data.monthYear)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 16) {
                        Text("매출: \(Int(data.totalSales).formattedWithComma)원")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("판매: \(data.totalQuantity.formattedWithComma)개")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.blue)
                    .animation(.easeInOut(duration: 0.2), value: isExpanded)
            }
            .padding()
            .contentShape(Rectangle()) // 전체 영역을 탭 가능하게 만듦
            .onTapGesture {
                onTap()
            }
            
            // 확장된 내용
            if isExpanded {
                VStack(spacing: 16) {
                    Divider()
                    
                    // 카테고리별 매출
                    CategorySalesSection(categories: data.categorySales)
                    
                    Divider()
                    
                    // 상품별 매출 (상위 5개)
                    TopProductsSection(products: Array(data.productSales.prefix(5)))
                }
                .padding(.horizontal)
                .padding(.bottom)
                .transition(.opacity.combined(with: .move(edge: .top))) // 부드러운 전환 효과
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

// MARK: - CategorySalesSection (카테고리별 매출 섹션)
struct CategorySalesSection: View {
    let categories: [CategorySalesData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("카테고리별 매출")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            ForEach(categories, id: \.category) { category in // id 명시적 지정
                HStack {
                    Text(category.category)
                        .font(.body)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(Int(category.totalAmount).formattedWithComma)원")
                            .font(.body)
                            .fontWeight(.medium)
                        
                        Text("\(category.quantity)개 (\(category.productCount)종류)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

// MARK: - TopProductsSection (인기 상품 섹션)
struct TopProductsSection: View {
    let products: [ProductSalesData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("인기 상품 TOP 5")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            ForEach(Array(products.enumerated()), id: \.element.productName) { index, product in // id 수정
                HStack {
                    Text("\(index + 1)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(rankColor(for: index))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(product.productName)
                            .font(.body)
                        Text(product.category)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(Int(product.totalAmount).formattedWithComma)원")
                            .font(.body)
                            .fontWeight(.medium)
                        
                        Text("\(product.quantity)개")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private func rankColor(for index: Int) -> Color {
        switch index {
        case 0: return .yellow
        case 1: return .gray
        case 2: return .orange
        default: return .blue
        }
    }
}

// MARK: - Extension (숫자 포맷팅)
extension Int {
    var formattedWithComma: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
