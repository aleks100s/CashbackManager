//
//  CardWidget.swift
//  CashbackWidget
//
//  Created by Alexander on 20.07.2024.
//

import WidgetKit
import Shared
import SwiftUI

struct CardWidget: Widget {
    var body: some WidgetConfiguration {
		StaticConfiguration(kind: Constants.cardWidgetKind, provider: CardWidgetProvider()) { entry in
            if #available(iOS 17.0, *) {
                CashbackWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CashbackWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Мои кэшбэки")
        .description("Показывает кэшбэк на всех картах.")
		.supportedFamilies([.systemMedium])
    }
}
