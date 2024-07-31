//
//  PlacesListView.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import DesignSystem
import Domain
import SearchService
import Shared
import SwiftData
import SwiftUI

public struct PlacesListView: View {
	private let onPlaceSelected: (Place) -> Void
	private let onAddPlaceButtonTapped: () -> Void
	
	@State private var searchText = ""
	@Query private var places: [Place]
	@Environment(\.modelContext) private var context
	@Environment(\.searchService) private var searchService
	
	private var filteredPlaces: [Place] {
		places.filter {
			searchText.isEmpty ? true : $0.name.localizedStandardContains(searchText)
		}
	}
	
	public init(
		onPlaceSelected: @escaping (Place) -> Void,
		onAddPlaceButtonTapped: @escaping () -> Void
	) {
		self.onPlaceSelected = onPlaceSelected
		self.onAddPlaceButtonTapped = onAddPlaceButtonTapped
	}
	
	public var body: some View {
		contentView
			.background(Color.cmScreenBackground)
			.navigationTitle("Сохраненные места")
			.if(!places.isEmpty) {
				$0.searchable(
					text: $searchText,
					placement: .navigationBarDrawer(displayMode: .automatic),
					prompt: "Название заведения"
				)
			}
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
		if filteredPlaces.isEmpty {
			ContentUnavailableView("Нет сохраненных мест", systemImage: Constants.SFSymbols.mapPin)
		} else {
			List {
				ForEach(filteredPlaces) { place in
					Button {
						onPlaceSelected(place)
					} label: {
						PlaceView(place: place)
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
