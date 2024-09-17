//
//  AddPlaceView.swift
//
//
//  Created by Alexander on 29.07.2024.
//

import AppIntents
import DesignSystem
import Domain
import PlaceService
import SearchService
import SelectCategoryScene
import SwiftUI

public struct AddPlaceView: View {
	private let addPlaceIntent: any AppIntent
	private let addCategoryIntent: any AppIntent
	
	@State private var placeName = ""
	@State private var selectedCategory: Domain.Category?
	@State private var isCategorySelectorPresented = false
	
	@FocusState private var isFocused
	
	@Environment(\.dismiss) private var dismiss
	@Environment(\.searchService) private var searchService
	@Environment(\.placeService) private var placeService
	@Environment(\.displayScale) var displayScale
	
	private var isInputCorrect: Bool {
		selectedCategory != nil && !placeName.isEmpty
	}
	
	public init(addPlaceIntent: any AppIntent, addCategoryIntent: any AppIntent) {
		self.addPlaceIntent = addPlaceIntent
		self.addCategoryIntent = addCategoryIntent
	}
	
	public var body: some View {
		contentView
			.background(Color.cmScreenBackground)
			.navigationTitle("Новое место")
			.navigationBarTitleDisplayMode(.inline)
			.safeAreaInset(edge: .bottom) {
				saveButton
			}
			.sheet(isPresented: $isCategorySelectorPresented) {
				selectCategorySheet
			}
			.onAppear {
				isFocused = true
			}
	}
	
	private var contentView: some View {
		ScrollView {
			VStack(alignment: .center, spacing: 32) {
				IntentTipView(intent: addPlaceIntent, text: "В следующий раз, чтобы добавить место")
				
				CMTextField("Название", text: $placeName)
					.focused($isFocused)
				
				Button {
					isCategorySelectorPresented = true
				} label: {
					if let selectedCategory {
						CategoryView(category: selectedCategory)
					} else {
						Text("Категория кэшбэка")
					}
				}
				.buttonStyle(BorderedProminentButtonStyle())
			}
			.padding()
		}
	}
	
	private var selectCategorySheet: some View {
		NavigationView {
			SelectCategoryView(addCategoryIntent: addCategoryIntent) { category in
				selectedCategory = category
				isCategorySelectorPresented = false
			}
		}
		.navigationTitle("Выбор категории")
		.navigationBarTitleDisplayMode(.inline)
		.presentationDetents([.large])
		.presentationBackground(.regularMaterial)
	}
	
	@MainActor
	private var saveButton: some View {
		Button("Сохранить") {
			createPlace()
			dismiss()
		}
		.padding()
		.disabled(!isInputCorrect)
	}
	
	@MainActor
	private func createPlace() {
		guard let selectedCategory else { return }
		
		guard let place = placeService?.createPlace(name: placeName, category: selectedCategory) else { return }
		
		let image = renderPlaceMarker(place: place)
		searchService?.index(place: place, image: image)
	}
	
	@MainActor
	private func renderPlaceMarker(place: Place) -> UIImage? {
		let renderer = ImageRenderer(content: PlaceMarkerView(name: place.name))
		renderer.scale = displayScale
		return renderer.uiImage
	}
}
