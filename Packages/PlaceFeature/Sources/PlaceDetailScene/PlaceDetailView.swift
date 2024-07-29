//
//  PlaceDetailView.swift
//
//
//  Created by Alexander on 29.07.2024.
//

import Domain
import SwiftUI

public struct PlaceDetailView: View {
	private let place: Place
	
	public init(place: Place) {
		self.place = place
	}
	
	public var body: some View {
		VStack {
			Text(place.category.name)
		}
		.navigationTitle(place.name)
	}
}
