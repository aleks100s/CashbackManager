//
//  FavouriteCardsWidget.swift
//  CashbackManager
//
//  Created by Alexander on 19.01.2025.
//

import WidgetKit
import Shared
import SwiftUI

struct FavouriteCardsWidget: Widget {
	var body: some WidgetConfiguration {
		AppIntentConfiguration(
			kind: Constants.favouriteCardsWidgetKind,
			intent: FavouriteCardsConfigurationIntent.self,
			provider: FavouriteCardsProvider()
		) { entry in
			FavouriteCardsEntryView(entry: entry)
		}
		.configurationDisplayName("Три любимые карты")
		.description("Показывает три выбранные карты")
		.supportedFamilies([.systemLarge])
	}
}
