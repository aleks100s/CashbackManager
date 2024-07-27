//
//  Place.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import Foundation
import SwiftData

@Model
public final class Place {
	public let id: UUID
	public let name: String
	public let category: Category
	
	public init(id: UUID = UUID(), name: String, category: Category) {
		self.id = id
		self.name = name
		self.category = category
	}
}
