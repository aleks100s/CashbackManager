//
//  CategoryEntity.swift
//  CashbackManager
//
//  Created by Alexander on 13.10.2024.
//

import AppIntents

struct CategoryEntity: AppEntity {
	static var typeDisplayRepresentation: TypeDisplayRepresentation = "Category Entity"
	
	let id: UUID
	let category: Category
	
	var displayRepresentation: DisplayRepresentation {
		DisplayRepresentation(stringLiteral: category.name)
	}
	
	static var defaultQuery = CategoryQuery()
}

struct CategoryQuery: EntityQuery {
	@Dependency
	private var categoryService: CategoryService
	
	func entities(for identifiers: [UUID]) async throws -> [CategoryEntity] {
		await categoryService.getAllCategories().map {
			CategoryEntity(id: $0.id, category: $0)
		}
	}
}
