//
//  CashbackView.swift
//  CashbackManager
//
//  Created by Alexander on 19.06.2024.
//

import AppIntents
import Charts
import SwiftData
import SwiftUI
import TipKit
import WidgetKit

struct CardDetailView: View {
	private let card: Card
	private let cardCashbackIntent: any AppIntent
	private let onAddCashbackTap: () -> Void
	private let onEditCashbackTap: (Cashback) -> Void
	private let formatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		return formatter
	}()
	
	@AppStorage(Constants.StorageKey.currentCardID, store: .appGroup)
	private var currentCardId: String?
	
	@AppStorage(Constants.StorageKey.isAdVisible)
	private var isAdVisible: Bool = false
	
	@State private var isEditing = false
	@State private var cardName: String
	@State private var color: Color
	
	@Environment(\.cardsService) private var cardsService
	@Environment(\.toastService) private var toastService
	@Environment(\.colorScheme) private var colorScheme
	
	init(
		card: Card,
		cardCashbackIntent: any AppIntent,
		onAddCashbackTap: @escaping () -> Void,
		onEditCashbackTap: @escaping (Cashback) -> Void
	) {
		self.card = card
		self.cardCashbackIntent = cardCashbackIntent
		self.onAddCashbackTap = onAddCashbackTap
		self.onEditCashbackTap = onEditCashbackTap
		cardName = card.name
		color = Color(hex: card.color ?? "")
	}
	
	var body: some View {
		VStack(spacing: .zero) {
			ContentView(
				card: card,
				cardCashbackIntent: cardCashbackIntent,
				isEditing: $isEditing,
				cardName: $cardName,
				color: $color,
				onAddCashbackTap: onAddCashbackTap,
				onEditCashbackTap: onEditCashbackTap
			)
			
			if isAdVisible {
				AdBannerView(bannerId: bannerId)
			}
		}
		.background(Color(hex: card.color ?? "").opacity(colorScheme == .light ? 0.4 : 0.2))
		.background(
			.linearGradient(
				colors: [
					.white.opacity(0.25),
					.white.opacity(0.05)
				],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
		)
		.navigationTitle(card.name)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button(isEditing ? "Готово" : "Править") {
					isEditing.toggle()
					hapticFeedback(.light)
				}
				.disabled(cardName.isEmpty)
				.popoverTip(HowToEditCardTip(), arrowEdge: .top)
			}
		}
		.onAppear {
			currentCardId = card.id.uuidString
		}
		.onChange(of: isEditing) { _, newValue in
			if !newValue, !cardName.isEmpty {
				card.name = cardName
				card.color = color.toHex()
				cardsService?.update(card: card)
				toastService?.show(Toast(title: "Карта обновлена"))
			}
		}
	}
}

#if DEBUG
private let bannerId = "demo-banner-yandex"
#else
private let bannerId = "R-M-12709149-2"
#endif
