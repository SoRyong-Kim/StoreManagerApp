// MARK: - StoreManager.swift (데이터 관리)
import Foundation
import Combine
import SwiftUI

class StoreManager: ObservableObject {
    @Published var isFirstRun: Bool = true
    @Published var storeInfo: StoreInfo = StoreInfo()
    @Published var employees: [Employee] = []
    @Published var products: [Product] = []
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadStoreInfo()
    }
    
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
    
    func addEmployee(_ employee: Employee) {
        employees.append(employee)
    }
    
    func removeEmployee(_ employee: Employee) {
        employees.removeAll { $0.id == employee.id }
    }
    
    func addProduct(_ product: Product) {
        products.append(product)
    }
    
    func removeProduct(_ product: Product) {
        products.removeAll { $0.id == product.id }
    }
}
