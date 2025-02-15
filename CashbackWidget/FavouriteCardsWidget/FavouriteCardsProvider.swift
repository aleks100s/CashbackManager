//
//  File.swift
//  CashbackManager
//
//  Created by Alexander on 19.01.2025.
//

import WidgetKit

struct FavouriteCardsProvider: AppIntentTimelineProvider {
	private let placeholderEntry = FavouriteCardsEntry(
		date: Date(),
		card1: nil,
		card2: nil,
		card3: nil
	)
	
	func placeholder(in context: Context) -> FavouriteCardsEntry {
		placeholderEntry
	}
	
	func snapshot(for configuration: FavouriteCardsConfigurationIntent, in context: Context) async -> FavouriteCardsEntry {
		FavouriteCardsEntry(date: Date(), card1: configuration.card1, card2: configuration.card2, card3: configuration.card3)
	}
	
	func timeline(for configuration: FavouriteCardsConfigurationIntent, in context: Context) async -> Timeline<FavouriteCardsEntry> {
		
		let entry = FavouriteCardsEntry(date: Date(), card1: configuration.card1, card2: configuration.card2, card3: configuration.card3)
		
		let timeline = Timeline(
			entries: [entry],
			policy: .after(Date().addingTimeInterval(60 * 60 * 24))
		)
		
		return timeline
		
	}
}
