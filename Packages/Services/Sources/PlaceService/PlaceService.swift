//
//  PlaceService.swift
//
//
//  Created by Alexander on 19.08.2024.
//

import Domain
import Foundation
import SearchService
import SwiftData

@MainActor
public struct PlaceService {
	private let context: ModelContext
	private let searchService: SearchService
	
	public init(context: ModelContext, searchService: SearchService) {
		self.context = context
		self.searchService = searchService
	}
	
	public func getAllPlaces() -> [Place] {
		fetch(by: #Predicate<Place> { !$0.name.isEmpty })
	}
	
	public func getPlace(by name: String) -> Place? {
		let predicate = #Predicate<Place> { $0.name.localizedStandardContains(name) }
		let descriptor = FetchDescriptor(predicate: predicate)
		return (try? context.fetch(descriptor))?.first
	}
	
	@discardableResult
	public func createPlace(name: String, category: Domain.Category) -> Place {
		let place = Place(name: name, category: category)
		context.insert(place)
		try? context.save()
		searchService.index(place: place)
		return place
	}
	
	public func delete(place: Place) {
		searchService.deindex(place: place)
		context.delete(place)
		try? context.save()
	}
	
	private func fetch(by predicate: Predicate<Place>) -> [Place] {
		let descriptor = FetchDescriptor(predicate: predicate)
		return (try? context.fetch(descriptor)) ?? []
	}
}
