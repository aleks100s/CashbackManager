//
//  CardWidget.swift
//  CashbackWidget
//
//  Created by Alexander on 20.07.2024.
//

import WidgetKit
import SwiftUI

struct CardWidget: Widget {
    var body: some WidgetConfiguration {
		StaticConfiguration(kind: Constants.cardWidgetKind, provider: CardWidgetProvider()) { entry in
			CashbackWidgetEntryView(entry: entry)
				.containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Мои кэшбэки")
        .description("Показывает кэшбэк на всех картах")
		.supportedFamilies([.systemMedium])
    }
}
