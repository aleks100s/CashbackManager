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
			PlacesListView(checkPlaceIntent: checkPlaceIntent) { place in
				path.append(.placeDetail(place))
			} onAddPlaceButtonTapped: {
				isAddPlaceSheetPresented = true
			}
			.navigationDestination(for: PlaceNavigation.self, destination: navigate(to:))
		}
		.sheet(isPresented: $isAddPlaceSheetPresented) {
			NavigationView {
				AddPlaceView(addPlaceIntent: addPlaceIntent, addCategoryIntent: addCategoryIntent) { place in
					path.append(.placeDetail(place))
				}
			}
			.presentationDetents([.medium, .large])
		}
	}
	
	@ViewBuilder
	private func navigate(to destination: PlaceNavigation) -> some View {
		switch destination {
		case .placeDetail(let place):
			PlaceDetailView(
				place: place,
				checkPlaceCardIntent: checkPlaceCardIntent,
				addCategoryIntent: addCategoryIntent
			)
		}
	}
}
