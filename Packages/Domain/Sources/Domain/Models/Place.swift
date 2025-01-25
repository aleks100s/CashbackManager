//
//  Place.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import Foundation
import SwiftData

@Model
public final class Place: @unchecked Sendable {
	public var id: UUID
	public var name: String
	public var category: Category
	public var isFavorite: Bool = false
	
	public init(id: UUID = UUID(), name: String, category: Category, isFavorite: Bool = false) {
		self.id = id
		self.name = name
		self.category = category
		self.isFavorite = isFavorite
	}
}
