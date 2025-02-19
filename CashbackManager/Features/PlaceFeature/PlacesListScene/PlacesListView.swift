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
	private let onPlaceSelected: (Place, Bool) -> Void
	private let onAddPlaceButtonTapped: () -> Void
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@State private var searchText = ""
	@State private var selectedCategory: Category?
	
	@Query(sort: [SortDescriptor<Place>(\.isFavorite, order: .reverse),
		SortDescriptor<Place>(\.name, order: .forward)],
		   animation: .default)
	private var places: [Place]
	
	@Query(
		filter: #Predicate<Category> { $0.priority > 0 },
		sort: [SortDescriptor<Category>(\.priority, order: .reverse)]
	)
	private var categories: [Category]
	
	@Environment(\.placeService) private var placeService
	@Environment(\.toastService) private var toastService
	
	private var filteredPlaces: [Place] {
		places.filter { place in
			if searchText.isEmpty {
				if let selectedCategory {
					place.category.name.localizedStandardContains(selectedCategory.name)
				} else {
					true
				}
			} else {
				place.name.localizedStandardContains(searchText)
			}
		}
	}
	
	private var popularCategories: [Category] {
		Array(categories.prefix(5))
	}
	
	init(
		checkPlaceIntent: any AppIntent,
		onPlaceSelected: @escaping (Place, Bool) -> Void,
		onAddPlaceButtonTapped: @escaping () -> Void
	) {
		self.checkPlaceIntent = checkPlaceIntent
		self.onPlaceSelected = onPlaceSelected
		self.onAddPlaceButtonTapped = onAddPlaceButtonTapped
	}
	
	var body: some View {
		contentView
			.navigationTitle("Сохраненные места")
			.navigationBarTitleDisplayMode(places.isEmpty ? .large : .inline)
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
			.safeAreaInset(edge: .top) {
				if !places.isEmpty {
					FilterView(popularCategories: popularCategories, selectedCategory: $selectedCategory)
				}
			}
	}
	
	@ViewBuilder
	private var contentView: some View {
		VStack {
			if filteredPlaces.isEmpty {
				if searchText.isEmpty && selectedCategory == nil {
					ContentUnavailableView("Добавьте любимые места, чтобы не забыть категорию кэшбэка", systemImage: Constants.SFSymbols.places)
				} else {
					ContentUnavailableView("Такие места не найдены\nПопробуйте изменить запрос", systemImage: Constants.SFSymbols.search)
				}
			} else {
				List {
					if areSiriTipsVisible, !searchText.isEmpty {
						IntentTipView(intent: checkPlaceIntent, text: "Чтобы быстро узнать категорию заведения")
					}
					
					ForEach(filteredPlaces) { place in
						Button {
							onPlaceSelected(place, false)
						} label: {
							PlaceView(place: place)
								.contentShape(.rect)
								.contextMenu {
									editPlaceButton(place)
									deletePlaceButton(place)
								}
						}
						.buttonStyle(.plain)
						.swipeActions(edge: .leading, allowsFullSwipe: true) {
							editPlaceButton(place)
						}
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
	}
	
	private var addPlaceButton: some View {
		Button("Добавить место") {
			onAddPlaceButtonTapped()
		}
	}
	
	private func editPlaceButton(_ place: Place) -> some View {
		Button("Редактировать место") {
			onPlaceSelected(place, true)
		}
		.tint(.green)
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
