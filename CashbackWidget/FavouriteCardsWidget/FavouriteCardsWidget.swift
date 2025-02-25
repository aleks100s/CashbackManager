//
//  FavouriteCardsWidget.swift
//  CashbackManager
//
//  Created by Alexander on 19.01.2025.
//

import WidgetKit
import SwiftUI

struct FavouriteCardsWidget: Widget {
	var body: some WidgetConfiguration {
		AppIntentConfiguration(
			kind: Constants.favouriteCardsWidgetKind,
			intent: FavouriteCardsConfigurationIntent.self,
			provider: FavouriteCardsProvider()
		) { entry in
			FavouriteCardsEntryView(entry: entry)
				.containerBackground(.fill.tertiary, for: .widget)
		}
		.configurationDisplayName("Три любимые карты")
		.description("Показывает кэшбэк у трех выбранных карт")
		.supportedFamilies([.systemLarge])
	}
}
