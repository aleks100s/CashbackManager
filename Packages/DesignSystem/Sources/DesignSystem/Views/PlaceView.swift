//
//  PlaceView.swift
//
//
//  Created by Alexander on 30.07.2024.
//

import Domain
import PlaceService
import SwiftUI

public struct PlaceView: View {
	private let place: Place
	
	@Environment(\.placeService) private var placeService
	
	public init(place: Place) {
		self.place = place
	}
	
	public var body: some View {
		HStack(alignment: .center) {
			PlaceMarkerView(name: place.name)
			
			VStack(alignment: .leading, spacing: 8) {
				Text(place.name)
				Text(place.category.name)
					.font(.callout)
					.foregroundStyle(.secondary)
			}
			
			Spacer()
			
			Image(systemName: place.isFavorite ? "heart.fill" : "heart")
				.font(.title2)
				.foregroundStyle(place.isFavorite ? .red : .gray)
				.animation(.default, value: place.isFavorite)
				.onTapGesture {
					place.isFavorite.toggle()
					placeService?.update(place: place)
				}
		}
		.contentShape(.rect)
	}
}
