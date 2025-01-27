//
//  PlaceService.swift
//
//
//  Created by Alexander on 19.08.2024.
//

import Foundation
import SwiftData

@MainActor
struct PlaceService {
	private let context: ModelContext
	private let searchService: SearchService
	
	init(context: ModelContext, searchService: SearchService) {
		self.context = context
		self.searchService = searchService
	}
	
	func getAllPlaces() -> [Place] {
		fetch(by: #Predicate<Place> { !$0.name.isEmpty })
	}
	
	func getPlace(by name: String) -> Place? {
		let predicate = #Predicate<Place> { $0.name.localizedStandardContains(name) }
		let descriptor = FetchDescriptor(predicate: predicate)
		return (try? context.fetch(descriptor))?.first
	}
	
	@discardableResult
	func createPlace(name: String, category: Category) -> Place {
		let place = Place(name: name, category: category)
		context.insert(place)
		try? context.save()
		searchService.index(place: place)
		return place
	}
	
	func update(place: Place) {
		context.insert(place)
		try? context.save()
		searchService.index(place: place)
	}
	
	func delete(place: Place) {
		searchService.deindex(place: place)
		context.delete(place)
		try? context.save()
	}
	
	private func fetch(by predicate: Predicate<Place>) -> [Place] {
		let descriptor = FetchDescriptor(predicate: predicate)
		return (try? context.fetch(descriptor)) ?? []
	}
}
