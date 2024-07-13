//
//  CategoryService.swift
//  CashbackManager
//
//  Created by Alexander on 30.06.2024.
//

import Domain
import Persistance

public final class CategoryService: ICategoryService {
	private let persistanceManager: IPersistanceManager
	
	private var categories: [Domain.Category] = [] {
		didSet {
			persistCategories()
		}
	}
	
	public init(persistanceManager: IPersistanceManager) {
		self.persistanceManager = persistanceManager
		self.categories = persistanceManager.readModels(for: .categories) as? [Domain.Category] ?? []
	}
	
	public func getCategories() -> [Domain.Category] {
		let predefinedCategories = PredefinedCategory.allCases.map(\.asCategory)
		let userCategories: [Domain.Category] = categories
		return predefinedCategories + userCategories
	}
	
	public func save(category: Domain.Category) {
		categories.append(category)
	}
	
	private func persistCategories() {
		persistanceManager.save(models: categories, for: .categories)
	}
}
