//
//  AddCashbackView.swift
//  CashbackManager
//
//  Created by Alexander on 26.06.2024.
//

import AppIntents
import SwiftData
import SwiftUI
import WidgetKit

struct AddCashbackView: View {
	private let card: Card
	private let cashback: Cashback?
	private let addCategoryIntent: any AppIntent
	private let addCashbackIntent: any AppIntent
	
	private let percentPresets = [0.01, 0.03, 0.05, 0.1]
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@State private var percent: Double
	@State private var selectedCategory: Category?
	@State private var isCategorySelectorPresented = false
	
	@Environment(\.dismiss) private var dismiss
	@Environment(\.cardsService) private var cardsService
	@Environment(\.toastService) private var toastService
	
	private var isEditMode: Bool {
		cashback != nil
	}
	
	init(card: Card, cashback: Cashback?, addCategoryIntent: any AppIntent, addCashbackIntent: any AppIntent) {
		self.card = card
		self.cashback = cashback
		self.addCategoryIntent = addCategoryIntent
		self.addCashbackIntent = addCashbackIntent
		_percent = State(initialValue: cashback?.percent ?? 0.05)
		_selectedCategory = State(initialValue: cashback?.category)
	}
	
	var body: some View {
		contentView
			.background(Color.cmScreenBackground)
			.navigationTitle(isEditMode ? "Редактировать кэшбэк" : "Добавить кэшбэк")
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
			if areSiriTipsVisible, !isEditMode {
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
	
	private var saveButton: some View {
		Button("Сохранить") {
			if isEditMode {
				editCashback()
			} else {
				createCashback()
			}
			toastService?.show(Toast(title: isEditMode ? "Кэшбэк обновлен" : "Кэшбэк добавлен"))
			dismiss()
		}
		.frame(maxWidth: .infinity)
		.padding()
		.background(.background)
		.disabled(selectedCategory == nil || percent == 0 || (card.has(category: selectedCategory) && cashback?.category != selectedCategory))
	}
	
	private var selectCategoryButton: some View {
		Button("Выбрать категорию") {
			isCategorySelectorPresented = true
		}
	}
	
	private func createCashback() {
		if let selectedCategory {
			let cashback = Cashback(category: selectedCategory, percent: percent, order: card.cashback.count)
			cardsService?.add(cashback: cashback, to: card)
		}
	}
	
	private func editCashback() {
		if let selectedCategory {
			cashback?.category = selectedCategory
		}
		cashback?.percent = percent
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.favouriteCardsWidgetKind)
	}
}

private extension AddCashbackView {
	struct CategorySelectorView: View {
		let category: Category
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
