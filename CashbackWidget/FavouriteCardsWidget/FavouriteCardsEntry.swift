//
//  FavouriteCardsEntry.swift
//  CashbackManager
//
//  Created by Alexander on 19.01.2025.
//

import Domain
import WidgetKit

struct FavouriteCardsEntry: TimelineEntry {
	let date: Date
	let card1: Card?
	let card2: Card?
	let card3: Card?
}
