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
	private let onPlaceSelected: (Place) -> Void
	private let onAddPlaceButtonTapped: () -> Void
	
	@Query private var places: [Place]
	@Environment(\.modelContext) private var context
	
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
			ContentUnavailableView("Нет сохраненных мест", systemImage: "mappin.circle")
		} else {
			List {
				ForEach(places) { place in
					VStack(alignment: .leading, spacing: 8) {
						Text(place.name)
						Text(place.category.name)
					}
					.contextMenu {
						Button(role: .destructive) {
							context.delete(place)
						} label: {
							Text("Удалить")
						}
					}
				}
				.onDelete { indexSet in
					for index in indexSet {
						context.delete(places[index])
					}
				}
			}
		}
	}
}
