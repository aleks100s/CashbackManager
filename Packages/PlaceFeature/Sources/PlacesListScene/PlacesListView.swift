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
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@State private var searchText = ""
	@State private var toast: Toast?
	
	@Query(sort: [SortDescriptor<Place>(\.name, order: .forward)])
	private var places: [Place]
	
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
			.toast(item: $toast)
			.onAppear {
				print("PlacesListView appeared")
			}
	}
	
	@ViewBuilder
	private var contentView: some View {
		if filteredPlaces.isEmpty {
			ContentUnavailableView("Нет сохраненных мест", systemImage: Constants.SFSymbols.places)
		} else {
			List {
				if areSiriTipsVisible {
					IntentTipView(intent: checkPlaceIntent, text: "Чтобы быстро узнать категорию заведения")
				}
				
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
			.listSectionSpacing(16)
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
		toast = Toast(title: "Место удалено")
	}
}
