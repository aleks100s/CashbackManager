//
//  AddPlaceView.swift
//
//
//  Created by Alexander on 29.07.2024.
//

import AppIntents
import SwiftUI

struct AddPlaceView: View {
	private let onPlaceAdded: (Place) -> Void
	private let addPlaceIntent: any AppIntent
	private let addCategoryIntent: any AppIntent
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@State private var placeName = ""
	@State private var selectedCategory: Category?
	@State private var isCategorySelectorPresented = false
	
	@FocusState private var isFocused
	
	@Environment(\.dismiss) private var dismiss
	@Environment(\.placeService) private var placeService
	@Environment(\.toastService) private var toastService
	
	private var isInputCorrect: Bool {
		selectedCategory != nil && !placeName.isEmpty
	}
	
	init(
		addPlaceIntent: any AppIntent,
		addCategoryIntent: any AppIntent,
		onPlaceAdded: @escaping (Place) -> Void
	) {
		self.addPlaceIntent = addPlaceIntent
		self.addCategoryIntent = addCategoryIntent
		self.onPlaceAdded = onPlaceAdded
	}
	
	var body: some View {
		contentView
			.background(Color.cmScreenBackground)
			.navigationTitle("Новое место")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Отмена") {
						dismiss()
					}
				}
			}
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
		List {
			if areSiriTipsVisible {
				IntentTipView(intent: addPlaceIntent, text: "Чтобы добавить место")
			}
			
			Section {
				TextField("Название", text: $placeName)
					.focused($isFocused)
			}
			
			Section {
				Button {
					isCategorySelectorPresented = true
				} label: {
					if let selectedCategory {
						CategoryView(category: selectedCategory)
					} else {
						Text("Категория кэшбэка")
					}
				}
			}
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
	
	private var saveButton: some View {
		Button("Сохранить") {
			createPlace()
			dismiss()
			toastService?.show(Toast(title: "Место добавлено"))
		}
		.padding()
		.disabled(!isInputCorrect)
	}
	
	private func createPlace() {
		guard let selectedCategory else { return }
		
		guard let place = placeService?.createPlace(name: placeName, category: selectedCategory) else { return }
		
		onPlaceAdded(place)
	}
}
