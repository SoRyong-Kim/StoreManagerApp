
# 🏪 StoreManagerApp

**StoreManagerApp**는 소상공인을 위한 SwiftUI 기반 **매장 관리 애플리케이션**입니다.  
직원, 제품, 근무 일정, 매출 통계를 통합하여 간편하게 관리할 수 있으며,  
AI 기반 재고 알림 및 추천 기능도 지원합니다.

---

## 🎥 시연 영상

아래 영상에서 **StoreManagerApp**의 전체 기능 흐름과 사용 방식을 확인하실 수 있습니다.

[![StoreManagerApp 시연 영상](https://youtu.be/bT4u3JBkUF4.jpg)](https://youtu.be/bT4u3JBkUF4)

> 📌 영상이 재생되지 않을 경우 [여기서 바로 보기](https://youtu.be/bT4u3JBkUF4)

---

## ✨ 주요 기능

- 👥 직원 등록, 조회, 편집, 삭제 기능
- 📦 제품 등록 및 재고 상태 실시간 관리
- 📈 월간 매출 통계 및 시각화
- 🔔 재고 부족 알림 및 AI 추천
- 🗓️ 근무 스케줄 설정 및 알림
- 🏪 초기 매장 셋업 및 설정 관리
- 🧠 AIRecommendationEngine 기반 기능 탑재 예정

---

## 🖼️ 화면 (View) 구성 요소

### ◾ 제품 관련
- `AddProductView` – 제품 추가 화면  
- `EditProductView` – 제품 수정 화면  
- `ProductView` – 전체 제품 리스트 화면  
- `ProductDetailView` – 제품 상세 정보 보기  
- `ProductRowView` – 개별 제품 행 컴포넌트  

### ◾ 직원 관련
- `AddEmployeeView` – 직원 추가  
- `EditEmployeeView` – 직원 수정  
- `EmployeeView` – 직원 목록  
- `EmployeeDetailView` – 직원 상세  
- `EmployeeRowView` – 직원 행 컴포넌트  
- `EmptyEmployeeView` – 직원이 없을 때 보여줄 뷰  

### ◾ 매장 설정 및 초기 구성
- `EditStoreView` – 매장 정보 수정  
- `InitialSetupView` – 앱 첫 실행 시 설정 화면  
- `SettingsView` – 설정 탭 화면  

### ◾ 스케줄 / 근무
- `WorkScheduleView` – 근무 스케줄 관리  

### ◾ 통계 / 알림
- `MonthlySalesStatsView` – 월간 매출 통계  
- `LowStockAlertView` – 재고 부족 알림  

### ◾ 기타 메인화면 / 탭
- `MainTabView` – 메인 탭 네비게이션  
- `DashboardView` – 대시보드  
- `WelcomeView` – 앱 시작 인트로/환영 화면  
- `ContentView` – 앱의 메인 진입점  

---

## 🧩 내부 구조 및 모듈 구성

| 구성요소 | 설명 |
|----------|------|
| `AIRecommendationEngine` | 재고 추천, 스마트 알림 등의 AI 기반 로직 |
| `AIRecommendationViews` | AI 기능과 연동된 UI 컴포넌트 |
| `CategoryChip` | 제품 분류 UI 요소 |
| `CommonComponents` | 공통 컴포넌트 모음 |
| `NotificationManager` | 로컬 알림 트리거 및 관리 |
| `SalesData` / `SalesManager` | 매출 데이터 모델 및 매니저 |
| `SampleDataManager` | 테스트 및 시연용 샘플 데이터 생성기 |
| `Persistence` | 로컬 데이터 저장 처리 (CoreData 또는 UserDefaults 예상) |
| `Models` | 데이터 모델 구조 (직원, 제품, 매장 등) |
| `StoreManager` | 전체 매장 기능 통합 관리 |
| `StoreManagerApp` / `StoreManagerAppApp` | SwiftUI 진입점 및 앱 선언 |

---

## 🧠 AI 인사이트 대시보드

**StoreManagerApp**는 AI 분석 기반의 실시간 인사이트 기능을 제공합니다.  
매출, 재고, 추천 메뉴 등의 정보를 종합하여 경영 전략을 빠르게 파악할 수 있습니다.

### 📊 AI 인사이트 대시보드 구성

4개의 탭으로 구성된 종합 분석 화면입니다:

#### 🕐 실시간 탭
- **현재 시간대 추천**: “지금 추천 메뉴” 위젯 표시
- **오늘의 핵심 지표**:  
  - 예상 매출  
  - 인기 메뉴  
  - 평균 주문가  
  - 재고 알림
- **즉시 실행 액션**:  
  - 재고 보충  
  - 프로모션 시작  
  - 메뉴 준비 알림

#### 📈 트렌드 탭
- **매출 증감률**: 전월 대비 성장률 (예: `+12% ↗️`)
- **카테고리별 성과**:  
  - 커피, 디저트, 음료 등 카테고리별 트렌드
- **성장세/주의 필요 상태** 표시

#### 💡 추천 탭
- **이번 달 핵심 전략**: AI가 종합적으로 제시하는 전략
- **추천 상품 TOP 3**: 주요 추천 제품
- **추천 이유 및 성공 확률** 표시

#### ⏰ 시간대 탭
- **시간대별 매출 현황**:  
  - 모닝 / 런치 / 애프터눈 / 이브닝 분석
- **최고 성과 시간대**: 하이라이트로 강조
- **시간대별 매출 비중** 시각화

### 🔄 실시간 업데이트 기능

- 현재 시간대에 따라 **추천 메뉴** 자동 갱신  
- **오늘의 예상 지표** 및 중요 알림 표시  
- 사용자에게 **즉시 실행 가능한 액션** 제안

### 🖼️ 시각적 표현 요소

- 🎨 **그라데이션 배경**: 파란색 → 보라색 톤 적용  
- 📱 **카드 기반 UI**: 각 정보를 독립된 카드로 시각화  
- 🏷️ **컬러 코딩**: 시간대별, 카테고리별 색상 적용  
- 📊 **트렌드 아이콘**: 증감률을 화살표 및 퍼센트로 표시  

---

## 🚀 실행 방법

1. 이 저장소를 클론합니다.
   ```bash
   git clone https://github.com/SoRyong-Kim/StoreManagerApp.git
   ```
2. Xcode로 `StoreManagerApp.xcodeproj` 또는 `.xcworkspace` 파일을 엽니다.
3. 시뮬레이터 또는 연결된 디바이스에서 실행합니다.

---

## 🛠️ 사용 기술

- **언어**: Swift (SwiftUI)
- **UI**: SwiftUI, MVVM 아키텍처
- **저장소**: CoreData 또는 Custom Persistence Layer
- **기능**: Local Notification, Chart/Graph UI, Custom TabView
- **AI 연동**: `AIRecommendationEngine` (개발 중)

---

## 📌 향후 업데이트 예정

- [ ] Firebase 연동 (Auth, Firestore, Remote Config 등)
- [ ] 사용자별 데이터 백업 기능
- [ ] Dark Mode 대응
- [ ] 다국어(한국어/영어) 지원
- [ ] AI 기반 자동 발주 추천

---

## 📄 라이선스

본 프로젝트는 MIT License 하에 배포됩니다.  
자세한 내용은 [LICENSE](./LICENSE)를 참고해주세요.

---

## 👤 개발자

**김소룡 (SoRyong Kim)**  
[GitHub 프로필](https://github.com/SoRyong-Kim)
