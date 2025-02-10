//
//  Coordinator.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import AppIntents
import SwiftUI

struct PlaceCoordinator: View {
	let addPlaceIntent: any AppIntent
	let checkPlaceIntent: any AppIntent
	let addCategoryIntent: any AppIntent
	let checkPlaceCardIntent: any AppIntent
	
	@State private var path = [PlaceNavigation]()
	@State private var isAddPlaceSheetPresented = false
		
	var body: some View {
		NavigationStack(path: $path) {
			PlacesListView(checkPlaceIntent: checkPlaceIntent) { place, isEditing in
				path.append(.placeDetail(place, isEditing))
			} onAddPlaceButtonTapped: {
				isAddPlaceSheetPresented = true
			}
			.navigationDestination(for: PlaceNavigation.self, destination: navigate(to:))
		}
		.sheet(isPresented: $isAddPlaceSheetPresented) {
			NavigationView {
				AddPlaceView(addPlaceIntent: addPlaceIntent, addCategoryIntent: addCategoryIntent) { place in
					path.append(.placeDetail(place, false))
				}
			}
			.presentationDetents([.medium, .large])
		}
	}
	
	@ViewBuilder
	private func navigate(to destination: PlaceNavigation) -> some View {
		switch destination {
		case let .placeDetail(place, isEditing):
			PlaceDetailView(
				place: place,
				checkPlaceCardIntent: checkPlaceCardIntent,
				addCategoryIntent: addCategoryIntent,
				isEditing: isEditing
			)
		}
	}
}
