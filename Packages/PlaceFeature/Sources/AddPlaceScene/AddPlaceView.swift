//
//  AddPlaceView.swift
//
//
//  Created by Alexander on 29.07.2024.
//

import DesignSystem
import Domain
import SearchService
import SelectCategoryScene
import SwiftUI

public struct AddPlaceView: View {
	@State private var placeName = ""
	@State private var selectedCategory: Domain.Category?
	@State private var isCategorySelectorPresented = false
	
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var context
	@Environment(\.searchService) private var searchService
	
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
		.background(Color.cmScreenBackground)
		.navigationTitle("Новое место")
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Сохранить") {
					createPlace()
					dismiss()
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
	
	private func createPlace() {
		guard let selectedCategory else { return }
		
		let place = Place(name: placeName, category: selectedCategory)
		context.insert(place)
		searchService?.index(place: place)
	}
}
