//
//  PlaceService.swift
//
//
//  Created by Alexander on 19.08.2024.
//

import Domain
import SwiftData

public struct PlaceService: IPlaceService {
	private let context: ModelContext
	
	public init(context: ModelContext) {
		self.context = context
	}
	
	public func createPlace(name: String, category: Category) -> Place {
		let place = Place(name: name, category: category)
		context.insert(place)
		return place
	}
	
	public func delete(place: Place) {
		context.delete(place)
	}
}
