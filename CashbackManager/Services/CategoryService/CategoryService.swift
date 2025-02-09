//
//  CategoryService.swift
//
//
//  Created by Alexander on 20.08.2024.
//

import Foundation
import SwiftData

@MainActor
struct CategoryService {
	private let context: ModelContext
	
	init(context: ModelContext) {
		self.context = context
	}
	
	func getAllCategories() -> [Category] {
		fetch(by: #Predicate<Category> { $0.isArchived == false })
	}
	
	func getCategory(by name: String) -> Category? {
		fetch(by: #Predicate<Category> { category in category.name.localizedStandardContains(name) ||
			category.synonyms?.localizedStandardContains(name) == true
		}).first
	}
	
	@discardableResult
	func createCategory(name: String, emoji: String? = nil, info: String? = nil) -> Category {
		let category = Category(name: name, emoji: emoji ?? String(name.first ?? "?"), info: info, isNative: false)
		context.insert(category)
		try? context.save()
		return category
	}
	
	func update(category: Category, name: String, emoji: String? = nil, info: String? = nil) {
		category.name = name
		category.emoji = emoji ?? String(name.first ?? "?")
		category.info = info
	}
	
	func archive(category: Category) {
		category.isArchived = true
		try? context.save()
	}
	
	func unarchive(categories: [Category]) {
		for category in categories {
			category.isArchived = false
		}
		try? context.save()
	}
	
	private func fetch(by predicate: Predicate<Category>) -> [Category] {
		let descriptor = FetchDescriptor(predicate: predicate)
		return (try? context.fetch(descriptor)) ?? []
	}
}
