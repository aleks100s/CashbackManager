//
//  PlacesListView.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import AppIntents
import DesignSystem
import Domain
import PlaceService
import SearchService
import Shared
import SwiftData
import SwiftUI

public struct PlacesListView: View {
	private let checkPlaceIntent: any AppIntent
	private let onPlaceSelected: (Place) -> Void
	private let onAddPlaceButtonTapped: () -> Void
	
	@State private var searchText = ""
	@Query private var places: [Place]
	@Environment(\.searchService) private var searchService
	@Environment(\.placeService) private var placeService
	
	private var filteredPlaces: [Place] {
		places.filter {
			searchText.isEmpty ? true : $0.name.localizedStandardContains(searchText)
		}
	}
	
	public init(
		checkPlaceIntent: any AppIntent,
		onPlaceSelected: @escaping (Place) -> Void,
		onAddPlaceButtonTapped: @escaping () -> Void
	) {
		self.checkPlaceIntent = checkPlaceIntent
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
					addPlaceButton
				}
			}
	}
	
	@ViewBuilder
	private var contentView: some View {
		if filteredPlaces.isEmpty {
			ContentUnavailableView("Нет сохраненных мест", systemImage: Constants.SFSymbols.places)
		} else {
			List {
				Section {
					IntentTipView(intent: checkPlaceIntent, text: "Чтобы быстро узнать категорию заведения")
				}
				.listRowBackground(Color.clear)
				.listRowInsets(EdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
				
				ForEach(filteredPlaces) { place in
					Button {
						// onPlaceSelected(place)
					} label: {
						PlaceView(place: place)
							.contentShape(.rect)
							.contextMenu {
								deletePlaceButton(place)
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
			.listSectionSpacing(8)
		}
	}
	
	private var addPlaceButton: some View {
		Button("Добавить место") {
			onAddPlaceButtonTapped()
		}
	}
	
	private func deletePlaceButton(_ place: Place) -> some View {
		Button(role: .destructive) {
			delete(place: place)
		} label: {
			Text("Удалить")
		}
	}
	
	private func deletePlace(index: Int) {
		let place = places[index]
		delete(place: place)
	}
	
	private func delete(place: Place) {
		searchService?.deindex(place: place)
		placeService?.delete(place: place)
	}
}
