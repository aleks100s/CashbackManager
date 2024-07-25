//
//  CategoryService.swift
//  CashbackManager
//
//  Created by Alexander on 30.06.2024.
//

import Domain

public final class CategoryService: ICategoryService {
	private var categories: [Domain.Category] = [] {
		didSet {
			persistCategories()
		}
	}
	
	public init() {}
	
	public func getCategories() -> [Domain.Category] {
		let predefinedCategories = PredefinedCategory.allCases.map(\.asCategory)
		let userCategories: [Domain.Category] = categories
		return predefinedCategories + userCategories
	}
	
	public func save(category: Domain.Category) {
		categories.append(category)
	}
	
	private func persistCategories() {
	}
}
