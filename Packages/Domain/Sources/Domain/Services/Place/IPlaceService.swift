//
//  IPlaceService.swift
//
//
//  Created by Alexander on 19.08.2024.
//

public protocol IPlaceService {
	func getPlace(by name: String) -> Place?
	func createPlace(name: String, category: Category) -> Place
	func delete(place: Place)
}
