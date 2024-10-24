//
//  AddCashbackView.swift
//  CashbackManager
//
//  Created by Alexander on 26.06.2024.
//

import AppIntents
import DesignSystem
import Domain
import SearchService
import SelectCategoryScene
import Shared
import SwiftData
import SwiftUI

public struct AddCashbackView: View {
	private let card: Card
	private let addCategoryIntent: any AppIntent
	private let addCashbackIntent: any AppIntent
	
	private let percentPresets = [0.01, 0.03, 0.05, 0.1]
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@State private var percent = 0.05
	@State private var selectedCategory: Domain.Category?
	@State private var isCategorySelectorPresented = false
	
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var context
	@Environment(\.displayScale) var displayScale
	@Environment(\.searchService) var searchService
	
	public init(card: Card, addCategoryIntent: any AppIntent, addCashbackIntent: any AppIntent) {
		self.card = card
		self.addCategoryIntent = addCategoryIntent
		self.addCashbackIntent = addCashbackIntent
	}
	
	public var body: some View {
		contentView
			.background(Color.cmScreenBackground)
			.navigationTitle("Добавить кэшбэк")
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
	}
	
	private var contentView: some View {
		List {
			if areSiriTipsVisible {
				IntentTipView(intent: addCashbackIntent, text: "Чтобы быстро добавить новый кэшбэк")
			}
			
			Section {
				if let category = selectedCategory {
					CategorySelectorView(category: category, percent: percent) {
						isCategorySelectorPresented = true
					}
				} else {
					selectCategoryButton
				}
			} footer: {
				if card.has(category: selectedCategory) {
					Text("Нельзя добавить две одинаковые категории для одной карты")
						.font(.caption)
						.foregroundStyle(.red)
				}
			}
			
			Section {
				PercentSelectorView(percentPresets: percentPresets, percent: percent) { percent in
					self.percent = percent
					hapticFeedback(.light)
				}
			}
			
		}
		.scrollDismissesKeyboard(.interactively)
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
			createCashback()
			dismiss()
		}
		.frame(maxWidth: .infinity)
		.padding()
		.background(.background)
		.disabled(selectedCategory == nil || percent == 0 || card.has(category: selectedCategory))
	}
	
	private var selectCategoryButton: some View {
		Button("Выбрать категорию") {
			isCategorySelectorPresented = true
			hapticFeedback(.medium)
		}
	}
	
	@MainActor
	private func createCashback() {
		if let selectedCategory {
			let cashback = Cashback(category: selectedCategory, percent: percent)
			card.cashback.append(cashback)
			searchService?.index(card: card)
		}
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
		private static let formatter = {
			let formatter = NumberFormatter()
			formatter.maximumFractionDigits = 1
			formatter.minimumFractionDigits = 0
			return formatter
		}()
		
		let percentPresets: [Double]
		let onPercentSelect: (Double) -> Void
		@State var percent: Double
		
		@FocusState private var isFocused
		
		init(percentPresets: [Double], percent: Double, onPercentSelect: @escaping (Double) -> Void) {
			self.percentPresets = percentPresets
			self.percent = percent * 100
			self.onPercentSelect = onPercentSelect
		}
		
		var body: some View {
			HStack {
				Text("Процент")
				
				TextField(value: $percent, formatter: Self.formatter) {
					Text("Процент кэшбэка")
				}
				.keyboardType(.decimalPad)
				.focused($isFocused)
				.onChange(of: percent) { _, newValue in
					onPercentSelect(newValue / 100)
				}
				.onTapGesture {
					isFocused = false
				}
				
				Text("%")
			}
			
			HStack {
				ForEach(percentPresets, id: \.self) { preset in
					Text(preset, format: .percent)
						.foregroundStyle(.blue)
						.frame(maxWidth: .infinity)
						.contentShape(Rectangle())
						.onTapGesture {
							percent = preset * 100
						}
				}
			}
		}
	}
}
