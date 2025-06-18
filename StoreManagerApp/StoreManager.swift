// MARK: - StoreManager.swift (알림 기능 포함)
import Foundation
import Combine
import SwiftUI

class StoreManager: ObservableObject {
    @Published var isFirstRun: Bool = true
    @Published var storeInfo: StoreInfo = StoreInfo()
    @Published var employees: [Employee] = []
    @Published var products: [Product] = [] {
        didSet {
            // 상품이 변경될 때마다 재고 체크
            checkLowStockAlerts()
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let notificationManager = NotificationManager.shared
    
    init() {
        loadStoreInfo()
        loadProducts()
        loadEmployees()
    }
    
    // MARK: - 재고 부족 알림 체크
    private func checkLowStockAlerts() {
        notificationManager.checkLowStock(products: products)
    }
    
    // MARK: - Store Info 관리
    func saveStoreInfo() {
        if let encoded = try? JSONEncoder().encode(storeInfo) {
            userDefaults.set(encoded, forKey: "storeInfo")
            isFirstRun = false
        }
    }
    
    private func loadStoreInfo() {
        if let data = userDefaults.data(forKey: "storeInfo"),
           let decoded = try? JSONDecoder().decode(StoreInfo.self, from: data) {
            storeInfo = decoded
            isFirstRun = false
        }
    }
    
    // MARK: - Product 관리
    func addProduct(_ product: Product) {
        products.append(product)
        saveProducts()
    }
    
    func removeProduct(_ product: Product) {
        products.removeAll { $0.id == product.id }
        saveProducts()
    }
    
    func updateProduct(_ product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index] = product
            saveProducts()
        }
    }
    
    private func saveProducts() {
        if let encoded = try? JSONEncoder().encode(products) {
            UserDefaults.standard.set(encoded, forKey: "products")
        }
    }
    
    func loadProducts() {
        if let data = UserDefaults.standard.data(forKey: "products"),
           let decoded = try? JSONDecoder().decode([Product].self, from: data) {
            products = decoded
        }
    }
    
    // MARK: - Employee 관리
    func addEmployee(_ employee: Employee) {
        employees.append(employee)
        saveEmployees()
    }
    
    func removeEmployee(_ employee: Employee) {
        employees.removeAll { $0.id == employee.id }
        saveEmployees()
    }
    
    func updateEmployee(_ employee: Employee) {
        if let index = employees.firstIndex(where: { $0.id == employee.id }) {
            employees[index] = employee
            saveEmployees()
        }
    }
    
    func toggleEmployeeStatus(_ employee: Employee) {
        if let index = employees.firstIndex(where: { $0.id == employee.id }) {
            employees[index].isActive.toggle()
            saveEmployees()
        }
    }
    
    private func saveEmployees() {
        if let encoded = try? JSONEncoder().encode(employees) {
            UserDefaults.standard.set(encoded, forKey: "employees")
        }
    }
    
    func loadEmployees() {
        if let data = UserDefaults.standard.data(forKey: "employees"),
           let decoded = try? JSONDecoder().decode([Employee].self, from: data) {
            employees = decoded
        }
    }
    
    // MARK: - 검색 및 필터링
    func searchEmployees(query: String) -> [Employee] {
        if query.isEmpty {
            return employees
        }
        return employees.filter { employee in
            employee.name.localizedCaseInsensitiveContains(query) ||
            employee.position.localizedCaseInsensitiveContains(query) ||
            employee.phone.contains(query)
        }
    }
    
    func searchProducts(query: String) -> [Product] {
        if query.isEmpty {
            return products
        }
        return products.filter { product in
            product.name.localizedCaseInsensitiveContains(query) ||
            product.category.localizedCaseInsensitiveContains(query)
        }
    }
    
    func getActiveEmployees() -> [Employee] {
        return employees.filter { $0.isActive }
    }
    
    func getInactiveEmployees() -> [Employee] {
        return employees.filter { !$0.isActive }
    }
    
    func getProductsByCategory(_ category: String) -> [Product] {
        if category == "전체" {
            return products
        }
        return products.filter { $0.category == category }
    }
    
    func getLowStockProducts() -> [Product] {
        return products.filter { $0.stock < 10 }
    }
    
    func getOutOfStockProducts() -> [Product] {
        return products.filter { $0.stock == 0 }
    }
    
    func getCriticalStockProducts() -> [Product] {
        return products.filter { $0.stock <= 5 }
    }
    
    // MARK: - 재고 관리 헬퍼
    func bulkUpdateStock(for products: [Product], amount: Int) {
        for product in products {
            var updatedProduct = product
            updatedProduct.stock = max(0, updatedProduct.stock + amount)
            updateProduct(updatedProduct)
        }
    }
    
    func resetStockToDefault(for product: Product, defaultAmount: Int = 50) {
        var updatedProduct = product
        updatedProduct.stock = defaultAmount
        updateProduct(updatedProduct)
    }
    
    // MARK: - 샘플 데이터 관리
    func loadSampleData() {
        // 매장 정보가 비어있으면 샘플 데이터 로드
        if storeInfo.name.isEmpty {
            storeInfo = SampleDataManager.createSampleStoreInfo()
            saveStoreInfo()
            isFirstRun = false
        }
        
        // 직원 데이터가 비어있으면 샘플 데이터 로드
        if employees.isEmpty {
            employees = SampleDataManager.createSampleEmployees()
            saveEmployees()
        }
        
        // 상품 데이터가 비어있으면 샘플 데이터 로드
        if products.isEmpty {
            products = SampleDataManager.createSampleProducts()
            saveProducts()
        }
    }
    
    func resetToSampleData() {
        // 모든 데이터를 샘플 데이터로 리셋
        storeInfo = SampleDataManager.createSampleStoreInfo()
        employees = SampleDataManager.createSampleEmployees()
        products = SampleDataManager.createSampleProducts()
        
        // 저장
        saveStoreInfo()
        saveEmployees()
        saveProducts()
        
        isFirstRun = false
    }
    
    // MARK: - 통계 및 분석
    var totalProductValue: Double {
        products.reduce(0) { $0 + ($1.price * Double($1.stock)) }
    }
    
    var averageStockLevel: Double {
        guard !products.isEmpty else { return 0 }
        let totalStock = products.reduce(0) { $0 + $1.stock }
        return Double(totalStock) / Double(products.count)
    }
    
    var stockAlertSummary: (total: Int, critical: Int, outOfStock: Int) {
        let lowStock = getLowStockProducts()
        let critical = getCriticalStockProducts()
        let outOfStock = getOutOfStockProducts()
        
        return (
            total: lowStock.count,
            critical: critical.count,
            outOfStock: outOfStock.count
        )
    }
}
