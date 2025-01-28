//
//  Place.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import Foundation
import SwiftData

@Model
final class Place: @unchecked Sendable {
	var id: UUID
	var name: String
	var category: Category
	var isFavorite: Bool = false
	
	init(id: UUID = UUID(), name: String, category: Category, isFavorite: Bool = false) {
		self.id = id
		self.name = name
		self.category = category
		self.isFavorite = isFavorite
	}
}
