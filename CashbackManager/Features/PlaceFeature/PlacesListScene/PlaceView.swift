//
//  PlaceView.swift
//
//
//  Created by Alexander on 30.07.2024.
//

import SwiftUI

struct PlaceView: View {
	private let place: Place
	
	@Environment(\.placeService) private var placeService
	@Environment(\.toastService) private var toastService
	
	init(place: Place) {
		self.place = place
	}
	
	var body: some View {
		HStack(alignment: .center) {
			PlaceMarkerView(name: place.name)
			
			VStack(alignment: .leading, spacing: 8) {
				Text(place.name)
				Text(place.category.name)
					.font(.callout)
					.foregroundStyle(.secondary)
			}
			
			Spacer()
			
			HeartView(isFavorite: place.isFavorite)
				.onTapGesture {
					place.isFavorite.toggle()
					placeService?.update(place: place)
					toastService?.show(Toast(title: place.isFavorite ? "Добавлено в избранное" : "Удалено из избранного", hasFeedback: false))
				}
		}
		.contentShape(.rect)
	}
}
