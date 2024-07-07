//
//  CategoryService.swift
//  CashbackManager
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
	
	func save(category: Category) {
		categories.append(category)
	}
	
	private func persistCategories() {
		persistanceManager.save(models: categories, for: .categories)
	}
}
