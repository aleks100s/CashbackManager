//
//  PlaceDetailView.swift
//
//
//  Created by Alexander on 29.07.2024.
//

import AppIntents
import CardsService
import DesignSystem
import Domain
import Shared
import SwiftUI

public struct PlaceDetailView: View {
	private let place: Place
	private let intent: any AppIntent
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@State private var cards: [PlaceCard] = []
	
	@Environment(\.cardsService) private var cardsService
	
	public init(place: Place, intent: any AppIntent) {
		self.place = place
		self.intent = intent
	}
	
	public var body: some View {
		List {
			Section("Данные о заведении") {
				HStack {
					Text(place.name)
					Spacer()
					Text("Название")
						.foregroundStyle(.secondary)
				}
				
				HStack {
					Text(place.category.name)
					Spacer()
					Text("Категория")
						.foregroundStyle(.secondary)
				}
			}
			
			if cards.isEmpty {
				ContentUnavailableView("Не найдены подходящие карты", systemImage: "creditcard")
			} else {
				Section("Карты, которыми можно оплатить") {
					ForEach(cards) { card in
						CardView(card: card, category: place.category)
					}
				}
				
				if areSiriTipsVisible {
					IntentTipView(intent: intent, text: "Чтобы быстро проверить карту в заведении")
				}
			}
		}
		.navigationTitle(place.name)
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
}

private struct PlaceCard: Identifiable {
	let id: UUID
	let color: String
	let name: String
	let percent: Double
}

private struct CardView: View {
	let card: PlaceCard
	let category: Domain.Category

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
