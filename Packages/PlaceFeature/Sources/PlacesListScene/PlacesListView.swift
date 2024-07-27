//
//  PlacesListView.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import Domain
import SwiftData
import SwiftUI

public struct PlacesListView: View {
	@Query private var places: [Place]
	@Environment(\.modelContext) private var context
	
	public init() {}
	
	public var body: some View {
		List {
			ForEach(places) { place in
				VStack(alignment: .leading, spacing: 8) {
					Text(place.name)
					Text(place.category.name)
				}
			}
		}
		.onAppear {
			let category = Category(name: "Некая странная категория", emoji: "Н")
			let place = Place(name: "Green green", category: category)
			context.insert(place)
		}
	}
}
