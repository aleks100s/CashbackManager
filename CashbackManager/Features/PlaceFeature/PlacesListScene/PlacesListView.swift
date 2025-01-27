//
//  PlacesListView.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import AppIntents
import SwiftData
import SwiftUI

struct PlacesListView: View {
	private let checkPlaceIntent: any AppIntent
	private let onPlaceSelected: (Place) -> Void
	private let onAddPlaceButtonTapped: () -> Void
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@State private var searchText = ""
	
	@Query(sort: [SortDescriptor<Place>(\.isFavorite, order: .reverse),
		SortDescriptor<Place>(\.name, order: .forward)],
		   animation: .default)
	private var places: [Place]
	
	@Environment(\.placeService) private var placeService
	@Environment(\.toastService) private var toastService
	
	private var filteredPlaces: [Place] {
		places.filter {
			searchText.isEmpty ? true : $0.name.localizedStandardContains(searchText)
		}
	}
	
	init(
		checkPlaceIntent: any AppIntent,
		onPlaceSelected: @escaping (Place) -> Void,
		onAddPlaceButtonTapped: @escaping () -> Void
	) {
		self.checkPlaceIntent = checkPlaceIntent
		self.onPlaceSelected = onPlaceSelected
		self.onAddPlaceButtonTapped = onAddPlaceButtonTapped
	}
	
	var body: some View {
		contentView
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
				if areSiriTipsVisible, !searchText.isEmpty {
					IntentTipView(intent: checkPlaceIntent, text: "Чтобы быстро узнать категорию заведения")
				}
				
				ForEach(filteredPlaces) { place in
					Button {
						onPlaceSelected(place)
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
			.listSectionSpacing(16)
			.scrollIndicators(.hidden)
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
		placeService?.delete(place: place)
		toastService?.show(Toast(title: "Место удалено"))
	}
}
