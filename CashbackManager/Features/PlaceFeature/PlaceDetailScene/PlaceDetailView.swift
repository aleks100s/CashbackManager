//
//  PlaceDetailView.swift
//
//
//  Created by Alexander on 29.07.2024.
//

import AppIntents
import SwiftUI
import TipKit

struct PlaceDetailView: View {
	private let place: Place
	private let checkPlaceCardIntent: any AppIntent
	private let addCategoryIntent: any AppIntent
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@AppStorage(Constants.StorageKey.isAdVisible)
	private var isAdVisible: Bool = false
	
	@State private var isEditing = false
	@State private var cards: [PlaceCard] = []
	@State private var placeName: String
	@State private var selectedCategory: Category
	@State private var isCategorySelectorPresented = false
	@State private var isDeletePlaceConfirmationPresented = false
	
	@Environment(\.cardsService) private var cardsService
	@Environment(\.placeService) private var placeService
	@Environment(\.toastService) private var toastService
	@Environment(\.dismiss) private var dismiss
	
	init(
		place: Place,
		checkPlaceCardIntent: any AppIntent,
		addCategoryIntent: any AppIntent
	) {
		self.place = place
		self.checkPlaceCardIntent = checkPlaceCardIntent
		self.addCategoryIntent = addCategoryIntent
		placeName = place.name
		selectedCategory = place.category
	}
	
	var body: some View {
		List {
			Section(isEditing ? "Редактировать данные заведения" : "Данные о заведении") {
				HStack {
					TextField("Название места", text: $placeName)
						.textFieldStyle(.plain)
						.disabled(!isEditing)
					
					Spacer()
					Text("Название")
						.foregroundStyle(.secondary)
				}
				
				HStack {
					if isEditing {
						Button(selectedCategory.name) {
							isCategorySelectorPresented = true
						}
					} else {
						Text(selectedCategory.name)
					}
					Spacer()
					Text("Категория")
						.foregroundStyle(.secondary)
				}
				
				HStack {
					Text(place.isFavorite ? "В избранном" : "Добавить в избранное")
						.foregroundStyle(.secondary)
					
					Spacer()
					
					Button {
						place.isFavorite.toggle()
						placeService?.update(place: place)
						toastService?.show(Toast(title: place.isFavorite ? "Добавлено в избранное" : "Удалено из избранного", hasFeedback: false))
					} label: {
						HeartView(isFavorite: place.isFavorite)
					}
				}
			}
			
			if isEditing {
				Section {
					Button("Удалить место", role: .destructive) {
						isDeletePlaceConfirmationPresented = true
					}
				} header: {
					Text("Для отважных пользователей")
				} footer: {
					Text("Данное действие нельзя отменить")
				}
			} else {
				if cards.isEmpty {
					ContentUnavailableView("Не найдены подходящие карты", systemImage: "creditcard")
				} else {
					Section("Карты, которыми можно оплатить") {
						ForEach(cards) { card in
							PlaceCardView(card: card, category: place.category)
						}
					}
					
					if areSiriTipsVisible {
						IntentTipView(intent: checkPlaceCardIntent, text: "Чтобы быстро проверить карту в заведении")
					}
				}
			}
		}
		.navigationTitle(placeName)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button(isEditing ? "Готово" : "Править") {
					isEditing.toggle()
					hapticFeedback(.light)
				}
				.popoverTip(HowToDeletePlaceTip(), arrowEdge: .top)
			}
		}
		.safeAreaInset(edge: .bottom) {
			if isAdVisible {
				AdBannerView(bannerId: bannerId)
					.frame(height: 100)
			}
		}
		.sheet(isPresented: $isCategorySelectorPresented) {
			selectCategorySheet
		}
		.alert("Вы уверены?", isPresented: $isDeletePlaceConfirmationPresented) {
			Button("Удалить", role: .destructive) {
				delete(place: place)
			}
			
			Button("Отмена", role: .cancel) {
				isDeletePlaceConfirmationPresented = false
			}
		}
		.onChange(of: isEditing) { _, _ in
			if placeName != place.name || place.category != selectedCategory {
				place.name = placeName
				place.category = selectedCategory
				placeService?.update(place: place)
				toastService?.show(Toast(title: "Место обновлено"))
			}
		}
		.onAppear {
			guard let cards = cardsService?.getCards(category: place.category) else { return }
			
			self.cards = cards.map {
				PlaceCard(
					id: $0.id,
					color: $0.color ?? "",
					name: $0.name,
					percent: $0.cashback.first(where: { $0.category == place.category })?.percent ?? .zero
				)
			}
			.sorted { $0.percent > $1.percent }
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
	
	private func delete(place: Place) {
		placeService?.delete(place: place)
		toastService?.show(Toast(title: "Место удалено"))
		dismiss()
	}
}

private struct PlaceCard: Identifiable {
	let id: UUID
	let color: String
	let name: String
	let percent: Double
}

private struct PlaceCardView: View {
	let card: PlaceCard
	let category: Category

	var body: some View {
		HStack {
			Image(systemName: Constants.SFSymbols.cashback)
				.foregroundStyle(Color(hex: card.color))
			
			Text(card.name)
			
			Spacer()
			
			Text(card.percent, format: .percent)
		}
	}
}

#if DEBUG
private let bannerId = "demo-banner-yandex"
#else
private let bannerId = "R-M-12709149-3"
#endif
