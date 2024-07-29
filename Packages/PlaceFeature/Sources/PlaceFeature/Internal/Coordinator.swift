//
//  Coordinator.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import AddPlaceScene
import PlacesListScene
import PlaceDetailScene
import SwiftUI

struct Coordinator: View {
	@State private var path = [Navigation]()
	@State private var isAddPlaceSheetPresented = false
	
	var body: some View {
		NavigationStack(path: $path) {
			PlacesListView { place in
				path.append(.placeDetail(place))
			} onAddPlaceButtonTapped: {
				isAddPlaceSheetPresented = true
			}
			.navigationDestination(for: Navigation.self, destination: navigate(to:))
		}
		.sheet(isPresented: $isAddPlaceSheetPresented) {
			NavigationView {
				AddPlaceView()
			}
		}
	}
	
	@ViewBuilder
	private func navigate(to destination: Navigation) -> some View {
		switch destination {
		case .placeDetail(let place):
			PlaceDetailView(place: place)
		}
	}
}
