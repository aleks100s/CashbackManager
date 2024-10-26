//
//  PlaceService.swift
//
//
//  Created by Alexander on 19.08.2024.
//

import Domain
import Foundation
import SwiftData

public struct PlaceService: @unchecked Sendable {
	private let context: ModelContext
	
	public init(context: ModelContext) {
		self.context = context
	}
	
	public func getAllPlaces() -> [Place] {
		fetch(by: #Predicate<Place> { !$0.name.isEmpty })
	}
	
	public func getPlace(by name: String) -> Place? {
		let predicate = #Predicate<Place> { $0.name.localizedStandardContains(name) }
		let descriptor = FetchDescriptor(predicate: predicate)
		return (try? context.fetch(descriptor))?.first
	}
	
	public func createPlace(name: String, category: Domain.Category) -> Place {
		let place = Place(name: name, category: category)
		context.insert(place)
		return place
	}
	
	public func delete(place: Place) {
		context.delete(place)
	}
	
	private func fetch(by predicate: Predicate<Place>) -> [Place] {
		let descriptor = FetchDescriptor(predicate: predicate)
		return (try? context.fetch(descriptor)) ?? []
	}
}
