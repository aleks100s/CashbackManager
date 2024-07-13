//
//  CategoryService.swift
//  CashbackManager
//
//  Created by Alexander on 30.06.2024.
//

import Domain

final class CategoryService: ICategoryService {
	private let persistanceManager: IPersistanceManager
	
	private var categories: [Domain.Category] = [] {
		didSet {
			persistCategories()
		}
	}
	
	init(persistanceManager: IPersistanceManager) {
		self.persistanceManager = persistanceManager
		self.categories = persistanceManager.readModels(for: .categories) as? [Domain.Category] ?? []
	}
	
	func getCategories() -> [Domain.Category] {
		let predefinedCategories = PredefinedCategory.allCases.map(\.asCategory)
		let userCategories: [Domain.Category] = categories
		return predefinedCategories + userCategories
	}
	
	func save(category: Domain.Category) {
		categories.append(category)
	}
	
	private func persistCategories() {
		persistanceManager.save(models: categories, for: .categories)
	}
}
