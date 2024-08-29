//
//  AddCashbackView.swift
//  CashbackManager
//
//  Created by Alexander on 26.06.2024.
//

import CardsService
import DesignSystem
import Domain
import SearchService
import SelectCategoryScene
import Shared
import SwiftData
import SwiftUI

public struct AddCashbackView: View {
	private let card: Card
	
	private let percentPresets = [0.01, 0.015, 0.02, 0.03, 0.05, 0.07, 0.08, 0.1, 0.15, 0.2, 0.25, 0.3, 0.5]
	
	@State private var percent = 0.05
	@State private var selectedCategory: Domain.Category?
	@State private var isCategorySelectorPresented = false
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var context
	@Environment(\.displayScale) var displayScale
	@Environment(\.searchService) var searchService
	@Environment(\.cardsService) var cardsService
		
	public init(card: Card) {
		self.card = card
	}
	
	public var body: some View {
		contentView
			.background(Color.cmScreenBackground)
			.navigationTitle("Добавить кэшбек")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					saveButton
				}
				
				if selectedCategory == nil {
					ToolbarItem(placement: .bottomBar) {
						selectCategoryButton
					}
				}
			}
			.sheet(isPresented: $isCategorySelectorPresented) {
				selectCategorySheet
			}
	}
	
	private var contentView: some View {
		ScrollView(.vertical) {
			HStack {
				Spacer()
				VStack(alignment: .leading, spacing: 32) {
					Spacer()
					
					if let category = selectedCategory {
						CategorySelectorView(category: category, percent: percent) {
							isCategorySelectorPresented = true
						}
					}
					
					if selectedCategory != nil {
						PercentSelectorView(percentPresets: percentPresets) { percent in
							self.percent = percent
						}
						.sensoryFeedback(.impact, trigger: percent)
					}
				}
				Spacer()
			}
		}
	}
	
	private var selectCategorySheet: some View {
		NavigationView {
			SelectCategoryView { category in
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
			createCashback()
			dismiss()
		}
		.disabled(selectedCategory == nil || percent == 0)
	}
	
	private var selectCategoryButton: some View {
		Button("Выбрать категорию") {
			isCategorySelectorPresented = true
		}
		.sensoryFeedback(.impact, trigger: isCategorySelectorPresented)
	}
	
	@MainActor
	private func createCashback() {
		if let selectedCategory {
			let cashback = Cashback(category: selectedCategory, percent: percent)
			cardsService?.add(cashback: cashback, card: card)
			index(cashback: cashback)
			searchService?.index(card: card)
		}
	}
	
	@MainActor
	private func renderCategoryMarker(category: Domain.Category) -> UIImage? {
		let renderer = ImageRenderer(content: CategoryMarkerView(category: category))
		renderer.scale = displayScale
		return renderer.uiImage
	}
	
	@MainActor
	private func index(cashback: Cashback) {
		let image = renderCategoryMarker(category: cashback.category)
		searchService?.index(cashback: cashback, cardName: card.name, image: image)
	}
}

private extension AddCashbackView {
	struct CategorySelectorView: View {
		let category: Domain.Category
		let percent: Double
		let onTap: () -> Void
		
		var body: some View {
			Button {
				onTap()
			} label: {
				HStack {
					CategoryView(category: category)
					
					Text(percent, format: .percent)
						.padding()
				}
				.contentShape(Rectangle())
			}
			.buttonStyle(PlainButtonStyle())
		}
	}
	
	struct PercentSelectorView: View {
		let percentPresets: [Double]
		let onPercentSelect: (Double) -> Void
		
		var body: some View {
			ScrollView(.horizontal, showsIndicators: false) {
				LazyHStack {
					ForEach(percentPresets, id: \.self) { percent in
						Button {
							onPercentSelect(percent)
						} label: {
							Text(percent, format: .percent)
						}
						.buttonStyle(BorderedProminentButtonStyle())
						.padding()
					}
				}
			}
		}
	}
}
