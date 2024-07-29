//
//  PlacesListView.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import Domain
import SearchService
import Shared
import SwiftData
import SwiftUI

public struct PlacesListView: View {
	private let onPlaceSelected: (Place) -> Void
	private let onAddPlaceButtonTapped: () -> Void
	
	@Query private var places: [Place]
	@Environment(\.modelContext) private var context
	@Environment(\.searchService) private var searchService
	
	public init(
		onPlaceSelected: @escaping (Place) -> Void,
		onAddPlaceButtonTapped: @escaping () -> Void
	) {
		self.onPlaceSelected = onPlaceSelected
		self.onAddPlaceButtonTapped = onAddPlaceButtonTapped
	}
	
	public var body: some View {
		contentView
			.navigationTitle("Сохраненные места")
			.toolbar {
				ToolbarItem(placement: .bottomBar) {
					Button("Добавить место") {
						onAddPlaceButtonTapped()
					}
				}
			}
	}
	
	@ViewBuilder
	private var contentView: some View {
		if places.isEmpty {
			ContentUnavailableView("Нет сохраненных мест", systemImage: Constants.SFSymbols.mapPin)
		} else {
			List {
				ForEach(places) { place in
					Button {
						onPlaceSelected(place)
					} label: {
						VStack(alignment: .leading, spacing: 8) {
							Text(place.name)
							Text(place.category.name)
						}
						.contentShape(.rect)
						.contextMenu {
							Button(role: .destructive) {
								delete(place: place)
							} label: {
								Text("Удалить")
							}
						}
					}
					.buttonStyle(.plain)
				}
				.onDelete { indexSet in
					for index in indexSet {
						deletePlace(index: index)
					}
				}
			}
		}
	}
	
	func deletePlace(index: Int) {
		let place = places[index]
		delete(place: place)
	}
	
	func delete(place: Place) {
		searchService?.deindex(place: place)
		context.delete(place)
	}
}
