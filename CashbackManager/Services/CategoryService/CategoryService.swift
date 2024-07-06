//
//  CategoryService.swift
//  CashbackApp
//
//  Created by Alexander on 30.06.2024.
//

final class CategoryService: ICategoryService {
	private let persistanceManager: IPersistanceManager
	
	private var categories: [Category] = [] {
		didSet {
			persistCategories()
		}
	}
	
	init(persistanceManager: IPersistanceManager) {
		self.persistanceManager = persistanceManager
		self.categories = persistanceManager.readModels(for: .categories) as? [Category] ?? []
	}
	
	func getCategories() -> [Category] {
		let predefinedCategories = PredefinedCategory.allCases.map(\.asCategory)
		let userCategories: [Category] = categories
		return predefinedCategories + userCategories
	}
	
	func save(categories: [Category]) {
		self.categories = categories
	}
	
	private func persistCategories() {
		persistanceManager.save(models: categories, for: .categories)
	}
}
