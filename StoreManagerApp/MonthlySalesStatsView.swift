import SwiftUI

struct MonthlySalesStatsView: View {
    @StateObject private var salesManager = SalesManager()
    @State private var selectedMonth: String?
    @State private var showingPeriodSelector = false
    @State private var selectedPeriod = "최근 6개월"
    @State private var showingAIInsights = true // AI 추천 표시 토글
    
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
                VStack(spacing: 24) {
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
                                Image(systemName: "chart.bar.xaxis")
                                    .font(.title)
                                    .foregroundColor(.white)
                            )
                            .shadow(
                                color: Color.purple.opacity(0.3),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                        
                        Text("월별 판매 통계")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 20)
                    
                    // 기간 선택 및 AI 토글 헤더
                    HStack {
                        Button(action: { showingPeriodSelector = true }) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.purple.opacity(0.1))
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Image(systemName: "calendar")
                                            .font(.caption)
                                            .foregroundColor(.purple)
                                    )
                                
                                Text(selectedPeriod)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.purple)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(
                                        color: Color.purple.opacity(0.1),
                                        radius: 4,
                                        x: 0,
                                        y: 2
                                    )
                            )
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
                        
                        // AI 인사이트 토글
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showingAIInsights.toggle()
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "brain.head.profile")
                                    .font(.caption)
                                Text("AI")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                showingAIInsights ?
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
                                        Color.gray.opacity(0.2),
                                        Color.gray.opacity(0.1)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .foregroundColor(showingAIInsights ? .white : .primary)
                            .cornerRadius(12)
                            .shadow(
                                color: showingAIInsights ? Color.purple.opacity(0.3) : Color.clear,
                                radius: 4,
                                x: 0,
                                y: 2
                            )
                        }
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("총 \(monthlySalesData.count)개월")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Text("데이터 분석")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // 전체 요약 카드
                    SalesSummaryCard(data: monthlySalesData)
                        .padding(.horizontal, 20)
                    
                    // 월별 매출 차트
                    if !monthlySalesData.isEmpty {
                        MonthlySalesChart(data: monthlySalesData)
                            .padding(.horizontal, 20)
                    }
                    
                    // 실시간 추천 위젯 (최신 데이터가 있을 때만)
                    if showingAIInsights && !monthlySalesData.isEmpty {
                        RealtimeRecommendationWidget(salesManager: salesManager)
                            .padding(.horizontal, 20)
                    }
                    
                    // 월별 상세 데이터 및 AI 추천
                    LazyVStack(spacing: 12) {
                        ForEach(monthlySalesData, id: \.monthYear) { monthData in
                            VStack(spacing: 16) {
                                // 기존 월별 데이터 카드
                                MonthlyDataCard(
                                    data: monthData,
                                    isExpanded: selectedMonth == monthData.monthYear,
                                    showingAIInsights: showingAIInsights
                                ) {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        if selectedMonth == monthData.monthYear {
                                            selectedMonth = nil
                                        } else {
                                            selectedMonth = monthData.monthYear
                                        }
                                    }
                                }
                                
                                // AI 추천 섹션 (확장되어 있고 AI 표시가 켜져 있을 때만)
                                if selectedMonth == monthData.monthYear && showingAIInsights {
                                    AIRecommendationSection(recommendation: monthData.recommendation)
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical)
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
            HStack {
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
                        Image(systemName: "chart.pie.fill")
                            .font(.caption)
                            .foregroundColor(.white)
                    )
                
                Text("전체 요약")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    SummaryItem(
                        title: "총 매출",
                        value: "\(Int(totalSales).formattedWithComma)원",
                        icon: "creditcard.fill",
                        color: .purple
                    )
                    
                    SummaryItem(
                        title: "판매 수량",
                        value: "\(totalQuantity.formattedWithComma)개",
                        icon: "cube.box.fill",
                        color: .pink
                    )
                }
                
                HStack(spacing: 12) {
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
                        color: .green
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

struct SummaryItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            color.opacity(0.8),
                            color.opacity(0.5)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .center, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
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
            HStack {
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
                        Image(systemName: "chart.bar.fill")
                            .font(.caption)
                            .foregroundColor(.white)
                    )
                
                Text("월별 매출 추이")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom, spacing: 12) {
                    ForEach(data.reversed(), id: \.monthYear) { monthData in
                        VStack(spacing: 8) {
                            Text("\(Int(monthData.totalSales / 10000))만원")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.purple.opacity(0.8),
                                            Color.pink.opacity(0.4)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 30, height: CGFloat(monthData.totalSales / maxSales * 120))
                                .cornerRadius(6)
                                .shadow(
                                    color: Color.purple.opacity(0.3),
                                    radius: 2,
                                    x: 0,
                                    y: 1
                                )
                            
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

// MARK: - MonthlyDataCard (월별 상세 데이터 카드)
struct MonthlyDataCard: View {
    let data: MonthlySalesData
    let isExpanded: Bool
    let showingAIInsights: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // 헤더
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
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "calendar")
                            .font(.title3)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(data.monthYear)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        // AI 분석 완료 뱃지
                        if data.recommendation != nil && showingAIInsights {
                            HStack(spacing: 4) {
                                Image(systemName: "brain.head.profile")
                                    .font(.caption2)
                                Text("AI 분석")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(6)
                        }
                    }
                    
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
                
                VStack(spacing: 4) {
                    Circle()
                        .fill(Color.purple.opacity(0.1))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .font(.caption)
                                .foregroundColor(.purple)
                                .animation(.easeInOut(duration: 0.2), value: isExpanded)
                        )
                    
                    if showingAIInsights && data.recommendation != nil {
                        ConfidenceIndicator(score: data.recommendation?.confidenceScore ?? 0)
                    }
                }
            }
            .padding(20)
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }
            
            // 확장된 내용
            if isExpanded {
                VStack(spacing: 16) {
                    Divider()
                        .background(Color.purple.opacity(0.2))
                    
                    // 시간대별 분석 (AI 기능이 켜져 있을 때만)
                    if showingAIInsights && !data.timeSlotAnalysis.isEmpty {
                        TimeSlotQuickAnalysis(timeSlotAnalysis: data.timeSlotAnalysis)
                        Divider()
                            .background(Color.purple.opacity(0.2))
                    }
                    
                    // 카테고리별 매출
                    CategorySalesSection(categories: data.categorySales)
                    
                    Divider()
                        .background(Color.purple.opacity(0.2))
                    
                    // 상품별 매출 (상위 5개)
                    TopProductsSection(products: Array(data.productSales.prefix(5)))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
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

struct TimeSlotQuickAnalysis: View {
    let timeSlotAnalysis: [TimeSlotAnalysis]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color.purple.opacity(0.1))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "clock.fill")
                            .font(.caption)
                            .foregroundColor(.purple)
                    )
                
                Text("시간대별 매출 분석")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            HStack(spacing: 8) {
                ForEach(timeSlotAnalysis.prefix(4)) { analysis in
                    VStack(spacing: 6) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        analysis.timeSlot.color.opacity(0.8),
                                        analysis.timeSlot.color.opacity(0.5)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 28, height: 28)
                            .overlay(
                                Image(systemName: analysis.timeSlot.icon)
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            )
                        
                        Text(analysis.timeSlot.rawValue)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Text("\(Int(analysis.salesPercentage))%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(analysis.timeSlot.color)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(analysis.timeSlot.color.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(analysis.timeSlot.color.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
            }
        }
    }
}

// MARK: - CategorySalesSection (카테고리별 매출 섹션)
struct CategorySalesSection: View {
    let categories: [CategorySalesData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color.purple.opacity(0.1))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "tag.fill")
                            .font(.caption)
                            .foregroundColor(.purple)
                    )
                
                Text("카테고리별 매출")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            ForEach(categories, id: \.category) { category in
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: 8, height: 8)
                    
                    Text(category.category)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(Int(category.totalAmount).formattedWithComma)원")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Text("\(category.quantity)개 (\(category.productCount)종류)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
}

// MARK: - TopProductsSection (인기 상품 섹션)
struct TopProductsSection: View {
    let products: [ProductSalesData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color.purple.opacity(0.1))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "trophy.fill")
                            .font(.caption)
                            .foregroundColor(.purple)
                    )
                
                Text("인기 상품 TOP 5")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            ForEach(Array(products.enumerated()), id: \.element.productName) { index, product in
                HStack(spacing: 12) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    rankColor(for: index).opacity(0.8),
                                    rankColor(for: index).opacity(0.6)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text("\(index + 1)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(product.productName)
                            .font(.body)
                            .foregroundColor(.primary)
                        Text(product.category)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(Int(product.totalAmount).formattedWithComma)원")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Text("\(product.quantity)개")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
    
    private func rankColor(for index: Int) -> Color {
        switch index {
        case 0: return .yellow
        case 1: return .gray
        case 2: return .orange
        default: return .purple
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
