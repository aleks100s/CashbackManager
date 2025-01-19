//
//  FavouriteCardsEntryView.swift
//  CashbackManager
//
//  Created by Alexander on 19.01.2025.
//

import DesignSystem
import Foundation
import Shared
import SwiftUI

struct FavouriteCardsEntryView: View {
	let entry: FavouriteCardsEntry

	var body: some View {
		VStack {
			if let card1 = entry.card1, let url = URL(string: "\(Constants.urlSchemeCard)\(card1.id.uuidString)") {
				Link(destination: url) {
					CardView(card: card1)
				}
			}
			if let card2 = entry.card2, let url = URL(string: "\(Constants.urlSchemeCard)\(card2.id.uuidString)") {
				Link(destination: url) {
					CardView(card: card2)
				}
			}
			if let card3 = entry.card3, let url = URL(string: "\(Constants.urlSchemeCard)\(card3.id.uuidString)") {
				Link(destination: url) {
					CardView(card: card3)
				}
			}
			if entry.card1 == nil, entry.card2 == nil, entry.card3 == nil {
				Text("Выберите карты в настройках виджета")
			}
		}
		.viewClass(.favouriteWidget)
	}
}
