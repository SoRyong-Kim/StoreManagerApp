import SwiftUI

// MARK: - AI 추천 섹션 (MonthlySalesStatsView에 추가할 컴포넌트)
struct AIRecommendationSection: View {
    let recommendation: MonthlyRecommendation?
    @State private var selectedTab: RecommendationTab = .overview
    
    enum RecommendationTab: String, CaseIterable {
        case overview = "전략 개요"
        case products = "상품 추천"
        case timeSlots = "시간대 분석"
        case actions = "실행 계획"
        
        var icon: String {
            switch self {
            case .overview: return "lightbulb.fill"
            case .products: return "cube.box.fill"
            case .timeSlots: return "clock.fill"
            case .actions: return "list.bullet.clipboard.fill"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // 헤더
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text("AI 판매 전략 추천")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                if let recommendation = recommendation {
                    ConfidenceIndicator(score: recommendation.confidenceScore)
                }
            }
            
            if let recommendation = recommendation {
                // 탭 선택
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(RecommendationTab.allCases, id: \.rawValue) { tab in
                            RecommendationTabButton(
                                tab: tab,
                                isSelected: selectedTab == tab
                            ) {
                                selectedTab = tab
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // 선택된 탭 내용
                Group {
                    switch selectedTab {
                    case .overview:
                        OverviewTabView(recommendation: recommendation)
                    case .products:
                        ProductRecommendationsTabView(recommendations: recommendation.productRecommendations)
                    case .timeSlots:
                        TimeSlotAnalysisTabView(timeSlotAnalysis: recommendation.timeSlotAnalysis)
                    case .actions:
                        ActionItemsTabView(actionItems: recommendation.actionItems)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
                
            } else {
                // 데이터 부족 상태
                EmptyRecommendationView()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - 신뢰도 표시기
struct ConfidenceIndicator: View {
    let score: Double
    
    var confidenceText: String {
        switch score {
        case 0.0..<0.4: return "낮음"
        case 0.4..<0.7: return "보통"
        case 0.7..<0.9: return "높음"
        default: return "매우 높음"
        }
    }
    
    var confidenceColor: Color {
        switch score {
        case 0.0..<0.4: return .red
        case 0.4..<0.7: return .orange
        case 0.7..<0.9: return .blue
        default: return .green
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(confidenceColor)
                .frame(width: 8, height: 8)
            
            Text("신뢰도: \(confidenceText)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - 탭 버튼
struct RecommendationTabButton: View {
    let tab: AIRecommendationSection.RecommendationTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.caption)
                Text(tab.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
        }
    }
}

// MARK: - 전략 개요 탭
struct OverviewTabView: View {
    let recommendation: MonthlyRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 주요 전략
            VStack(alignment: .leading, spacing: 8) {
                Text("🎯 주요 전략")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(recommendation.overallStrategy)
                    .font(.body)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // 핵심 인사이트
            if !recommendation.keyInsights.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("💡 핵심 인사이트")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    ForEach(recommendation.keyInsights, id: \.self) { insight in
                        Text(insight)
                            .font(.body)
                            .padding(.vertical, 4)
                    }
                }
            }
        }
    }
}

// MARK: - 상품 추천 탭
struct ProductRecommendationsTabView: View {
    let recommendations: [ProductRecommendation]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(recommendations.prefix(5)) { recommendation in
                ProductRecommendationCard(recommendation: recommendation)
            }
            
            if recommendations.count > 5 {
                Text("+ \(recommendations.count - 5)개 더보기")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.top, 8)
            }
        }
    }
}

// MARK: - 상품 추천 카드
struct ProductRecommendationCard: View {
    let recommendation: ProductRecommendation
    
    var body: some View {
        HStack(spacing: 12) {
            // 추천 타입 아이콘
            Image(systemName: recommendation.recommendationType.icon)
                .font(.title2)
                .foregroundColor(recommendation.recommendationType.color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(recommendation.product.name)
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text(recommendation.recommendationType.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(recommendation.recommendationType.color.opacity(0.2))
                        .foregroundColor(recommendation.recommendationType.color)
                        .cornerRadius(6)
                }
                
                Text(recommendation.reason)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("예상 판매: \(recommendation.expectedSales)개")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("확률: \(Int(recommendation.salesProbability * 100))%")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(recommendation.salesProbability > 0.7 ? .green : .orange)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - 시간대 분석 탭
struct TimeSlotAnalysisTabView: View {
    let timeSlotAnalysis: [TimeSlotAnalysis]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(timeSlotAnalysis) { analysis in
                TimeSlotAnalysisCard(analysis: analysis)
            }
        }
    }
}

// MARK: - 시간대 분석 카드
struct TimeSlotAnalysisCard: View {
    let analysis: TimeSlotAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: analysis.timeSlot.icon)
                    .font(.title2)
                    .foregroundColor(analysis.timeSlot.color)
                
                Text(analysis.timeSlot.displayName)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(Int(analysis.salesPercentage))%")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(analysis.timeSlot.color)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("매출")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(Int(analysis.totalSales).formattedWithComma)원")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("판매량")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(analysis.totalQuantity)개")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("평균 주문가")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(Int(analysis.averageOrderValue).formattedWithComma)원")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Spacer()
            }
            
            if !analysis.topProducts.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("인기 상품 TOP 3")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        ForEach(Array(analysis.topProducts.prefix(3).enumerated()), id: \.element.id) { index, product in
                            Text("\(index + 1). \(product.productName)")
                                .font(.caption)
                                .foregroundColor(.primary)
                            
                            if index < 2 { Text("•").foregroundColor(.gray) }
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - 실행 계획 탭
struct ActionItemsTabView: View {
    let actionItems: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(actionItems.enumerated()), id: \.offset) { index, action in
                ActionItemRow(index: index + 1, action: action)
            }
        }
    }
}

// MARK: - 실행 계획 행
struct ActionItemRow: View {
    let index: Int
    let action: String
    @State private var isCompleted = false
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isCompleted.toggle()
                }
            }) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Step \(index)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(action)
                    .font(.body)
                    .strikethrough(isCompleted)
                    .foregroundColor(isCompleted ? .secondary : .primary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - 빈 추천 상태
struct EmptyRecommendationView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("분석할 데이터가 부족합니다")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("더 많은 판매 데이터가 쌓이면\n정확한 AI 추천을 제공할 수 있습니다")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - AI 대시보드 섹션 (메인 AI 버튼용)
struct AIDashboardSection: View {
    @ObservedObject var salesManager: SalesManager
    let monthlySalesData: [MonthlySalesData]
    @State private var selectedInsightTab: InsightTab = .realtime
    
    enum InsightTab: String, CaseIterable {
        case realtime = "실시간"
        case trends = "트렌드"
        case recommendations = "추천"
        case timeSlots = "시간대"
        
        var icon: String {
            switch self {
            case .realtime: return "clock.fill"
            case .trends: return "chart.line.uptrend.xyaxis"
            case .recommendations: return "lightbulb.fill"
            case .timeSlots: return "sun.and.horizon.fill"
            }
        }
    }
    
    var latestMonthData: MonthlySalesData? {
        monthlySalesData.first
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // AI 대시보드 헤더
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text("AI 인사이트 대시보드")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("실시간 분석")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.green)
                    .cornerRadius(8)
            }
            
            // 인사이트 탭 선택
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(InsightTab.allCases, id: \.rawValue) { tab in
                        InsightTabButton(
                            tab: tab,
                            isSelected: selectedInsightTab == tab
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedInsightTab = tab
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // 선택된 탭 내용
            Group {
                switch selectedInsightTab {
                case .realtime:
                    RealtimeInsightView(salesManager: salesManager)
                case .trends:
                    TrendAnalysisView(monthlySalesData: monthlySalesData)
                case .recommendations:
                    if let latestData = latestMonthData, let recommendation = latestData.recommendation {
                        QuickRecommendationsView(recommendation: recommendation)
                    } else {
                        EmptyRecommendationView()
                    }
                case .timeSlots:
                    if let latestData = latestMonthData {
                        TimeSlotOverviewView(timeSlotAnalysis: latestData.timeSlotAnalysis)
                    } else {
                        EmptyStateView(icon: "clock", title: "시간대 데이터 없음", subtitle: "")
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedInsightTab)
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.05), Color.purple.opacity(0.05)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - 인사이트 탭 버튼
struct InsightTabButton: View {
    let tab: AIDashboardSection.InsightTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.caption)
                Text(tab.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color.white)
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: isSelected ? 3 : 1, x: 0, y: 1)
        }
    }
}

// MARK: - 실시간 인사이트 뷰
struct RealtimeInsightView: View {
    @ObservedObject var salesManager: SalesManager
    
    var body: some View {
        VStack(spacing: 16) {
            // 현재 시간대 추천
            RealtimeRecommendationWidget(salesManager: salesManager)
            
            // 오늘의 핵심 지표
            TodayKeyMetrics()
            
            // 즉시 실행 가능한 액션
            QuickActionCards()
        }
    }
}

// MARK: - 오늘의 핵심 지표
struct TodayKeyMetrics: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📊 오늘의 핵심 지표")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            HStack(spacing: 12) {
                MetricCard(
                    title: "예상 매출",
                    value: "\(Int.random(in: 150...300))만원",
                    icon: "creditcard.fill",
                    color: .green,
                    trend: "+12%"
                )
                
                MetricCard(
                    title: "인기 메뉴",
                    value: "아메리카노",
                    icon: "cup.and.saucer.fill",
                    color: .orange,
                    trend: "🔥"
                )
            }
            
            HStack(spacing: 12) {
                MetricCard(
                    title: "평균 주문가",
                    value: "\(Int.random(in: 8...15))천원",
                    icon: "chart.bar.fill",
                    color: .blue,
                    trend: "+5%"
                )
                
                MetricCard(
                    title: "재고 알림",
                    value: "\(Int.random(in: 0...3))개",
                    icon: "exclamationmark.triangle.fill",
                    color: .red,
                    trend: "⚠️"
                )
            }
        }
    }
}

// MARK: - 지표 카드
struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                
                Spacer()
                
                Text(trend)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - 빠른 액션 카드들
struct QuickActionCards: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("⚡ 즉시 실행")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            VStack(spacing: 8) {
                QuickActionRow(
                    icon: "plus.circle.fill",
                    title: "인기 메뉴 재고 보충",
                    subtitle: "아메리카노 원두 +50개",
                    color: .green
                )
                
                QuickActionRow(
                    icon: "megaphone.fill",
                    title: "오후 프로모션 시작",
                    subtitle: "디저트 2+1 이벤트 추천",
                    color: .orange
                )
                
                QuickActionRow(
                    icon: "bell.fill",
                    title: "저녁 메뉴 준비",
                    subtitle: "따뜻한 음료 재료 체크",
                    color: .blue
                )
            }
        }
    }
}

// MARK: - 빠른 액션 행
struct QuickActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("실행") {
                // 액션 실행 로직
            }
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
    }
}

// MARK: - 트렌드 분석 뷰
struct TrendAnalysisView: View {
    let monthlySalesData: [MonthlySalesData]
    
    var salesTrend: Double {
        guard monthlySalesData.count >= 2 else { return 0 }
        let current = monthlySalesData[0].totalSales
        let previous = monthlySalesData[1].totalSales
        return ((current - previous) / previous) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📈 매출 트렌드 분석")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            // 매출 증감률
            HStack {
                VStack(alignment: .leading) {
                    Text("전월 대비")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: salesTrend >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .foregroundColor(salesTrend >= 0 ? .green : .red)
                        
                        Text("\(abs(salesTrend), specifier: "%.1f")%")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(salesTrend >= 0 ? .green : .red)
                    }
                }
                
                Spacer()
                
                Text(salesTrend >= 0 ? "📈 성장세" : "📉 주의 필요")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background((salesTrend >= 0 ? Color.green : Color.red).opacity(0.2))
                    .foregroundColor(salesTrend >= 0 ? .green : .red)
                    .cornerRadius(8)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            
            // 카테고리별 트렌드
            CategoryTrendCards(monthlySalesData: monthlySalesData)
        }
    }
}

// MARK: - 카테고리 트렌드 카드
struct CategoryTrendCards: View {
    let monthlySalesData: [MonthlySalesData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("카테고리별 성과")
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let latestData = monthlySalesData.first {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(latestData.categorySales.prefix(4)) { category in
                        CategoryTrendCard(category: category)
                    }
                }
            }
        }
    }
}

struct CategoryTrendCard: View {
    let category: CategorySalesData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(category.category)
                .font(.caption)
                .fontWeight(.medium)
            
            Text("\(Int(category.totalAmount).formattedWithComma)원")
                .font(.subheadline)
                .fontWeight(.bold)
            
            Text("\(category.quantity)개")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
    }
}

// MARK: - 빠른 추천 뷰
struct QuickRecommendationsView: View {
    let recommendation: MonthlyRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("💡 이번 달 핵심 추천")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            // 주요 전략
            VStack(alignment: .leading, spacing: 8) {
                Text("🎯 주요 전략")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(recommendation.overallStrategy)
                    .font(.body)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // 상위 3개 추천 상품
            VStack(alignment: .leading, spacing: 8) {
                Text("🏆 추천 상품 TOP 3")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                ForEach(Array(recommendation.productRecommendations.prefix(3).enumerated()), id: \.element.id) { index, rec in
                    HStack(spacing: 12) {
                        Text("\(index + 1)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .background(rec.recommendationType.color)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(rec.product.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text(rec.reason)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("\(Int(rec.salesProbability * 100))%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(rec.recommendationType.color)
                    }
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
                }
            }
        }
    }
}

// MARK: - 시간대 개요 뷰
struct TimeSlotOverviewView: View {
    let timeSlotAnalysis: [TimeSlotAnalysis]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⏰ 시간대별 매출 현황")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(timeSlotAnalysis) { analysis in
                    TimeSlotOverviewCard(analysis: analysis)
                }
            }
            
            // 최고 성과 시간대
            if let bestSlot = timeSlotAnalysis.first {
                VStack(alignment: .leading, spacing: 8) {
                    Text("🏆 최고 성과 시간대")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: bestSlot.timeSlot.icon)
                            .foregroundColor(bestSlot.timeSlot.color)
                        
                        Text("\(bestSlot.timeSlot.displayName)이 전체 매출의 \(Int(bestSlot.salesPercentage))%를 차지합니다")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding()
                    .background(bestSlot.timeSlot.color.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct TimeSlotOverviewCard: View {
    let analysis: TimeSlotAnalysis
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: analysis.timeSlot.icon)
                    .foregroundColor(analysis.timeSlot.color)
                
                Text(analysis.timeSlot.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            
            Text("\(Int(analysis.salesPercentage))%")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(analysis.timeSlot.color)
            
            Text("\(Int(analysis.totalSales).formattedWithComma)원")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
struct RealtimeRecommendationWidget: View {
    @ObservedObject var salesManager: SalesManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.orange)
                
                Text("지금 추천 메뉴")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(getCurrentTimeSlotName())
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
            
            if let currentRecommendation = salesManager.getCurrentTimeSlotRecommendation() {
                VStack(alignment: .leading, spacing: 8) {
                    if let topProduct = currentRecommendation.topProducts.first {
                        HStack {
                            Text("🏆 \(topProduct.productName)")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text("\(Int(currentRecommendation.salesPercentage))% 인기")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        
                        Text("\(currentRecommendation.timeSlot.displayName) 시간대 최고 인기 메뉴입니다")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                Text("현재 시간대 추천 데이터가 없습니다")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func getCurrentTimeSlotName() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 7..<11: return "모닝"
        case 11..<14: return "런치"
        case 14..<17: return "애프터눈"
        case 17..<21: return "이브닝"
        default: return "기타"
        }
    }
}
