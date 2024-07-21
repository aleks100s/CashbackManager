//
//  CardWidgetEntry.swift
//  CashbackManager
//
//  Created by Alexander on 20.07.2024.
//

import Domain
import WidgetKit

struct CardWidgetEntry: TimelineEntry {
	let date: Date
	let card: Card?
}
