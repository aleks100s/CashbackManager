//
//  AddPlaceView.swift
//
//
//  Created by Alexander on 29.07.2024.
//

import DesignSystem
import Domain
import SelectCategoryScene
import SwiftUI

public struct AddPlaceView: View {
	@State private var placeName = ""
	@State private var selectedCategory: Domain.Category?
	@State private var isCategorySelectorPresented = false
	
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var context
	
	private var isInputCorrect: Bool {
		selectedCategory != nil && !placeName.isEmpty
	}
	
	public init() {}
	
	public var body: some View {
		ScrollView {
			VStack {
				CMTextField("Название", text: $placeName)
				
				Button {
					isCategorySelectorPresented = true
				} label: {
					if let selectedCategory {
						CategoryView(category: selectedCategory)
					} else {
						Text("Категория кэшбека")
					}
				}
			}
			.padding()
		}
		.navigationTitle("Новое место")
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Сохранить") {
					if let selectedCategory {
						let place = Place(name: placeName, category: selectedCategory)
						context.insert(place)
						dismiss()
					}
				}
				.disabled(!isInputCorrect)
			}
		}
		.sheet(isPresented: $isCategorySelectorPresented) {
			SelectCategoryView { category in
				selectedCategory = category
				isCategorySelectorPresented = false
			}
		}
	}
}
