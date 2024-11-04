//
//  CategoryService.swift
//
//
//  Created by Alexander on 20.08.2024.
//

import Domain
import Foundation
import SwiftData

@MainActor
public struct CategoryService {
	private let context: ModelContext
	
	public init(context: ModelContext) {
		self.context = context
	}
	
	public func getAllCategories() -> [Domain.Category] {
		fetch(by: #Predicate<Domain.Category> { $0.isArchived == false })
	}
	
	public func getCategory(by name: String) -> Domain.Category? {
		fetch(by: #Predicate<Domain.Category> { category in category.name.localizedStandardContains(name) ||
			category.synonyms?.localizedStandardContains(name) == true
		}).first
	}
	
	@discardableResult
	public func createCategory(name: String) -> Domain.Category {
		let category = Domain.Category(name: name, emoji: String(name.first ?? "?"))
		context.insert(category)
		try? context.save()
		return category
	}
	
	public func archive(category: Domain.Category) {
		category.isArchived = true
		try? context.save()
	}
	
	private func fetch(by predicate: Predicate<Domain.Category>) -> [Domain.Category] {
		let descriptor = FetchDescriptor(predicate: predicate)
		return (try? context.fetch(descriptor)) ?? []
	}
}
