//
//  CategoryService.swift
//
//
//  Created by Alexander on 20.08.2024.
//

import Domain
import Foundation
import SwiftData

public struct CategoryService: ICategoryService, @unchecked Sendable {
	private let context: ModelContext
	
	public init(context: ModelContext) {
		self.context = context
	}
	
	public func getAllCategories() -> [Domain.Category] {
		fetch(by: #Predicate<Domain.Category> { !$0.name.isEmpty })
	}
	
	public func getCategory(by name: String) -> Domain.Category? {
		fetch(by: #Predicate<Domain.Category> { $0.name.localizedStandardContains(name) }).first
	}
	
	@discardableResult
	public func createCategory(name: String) -> Domain.Category {
		let category = Domain.Category(name: name, emoji: String(name.first ?? "?"))
		context.insert(category)
		return category
	}
	
	private func fetch(by predicate: Predicate<Domain.Category>) -> [Domain.Category] {
		let descriptor = FetchDescriptor(predicate: predicate)
		return (try? context.fetch(descriptor)) ?? []
	}
}
