//
//  CardWidget.swift
//  CashbackWidget
//
//  Created by Alexander on 20.07.2024.
//

import WidgetKit
import SwiftUI

struct CardWidget: Widget {
    static let kind: String = "CardWidget"

    var body: some WidgetConfiguration {
		StaticConfiguration(kind: Self.kind, provider: CardWidgetProvider()) { entry in
            if #available(iOS 17.0, *) {
                CashbackWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CashbackWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
		.supportedFamilies([.systemMedium])
    }
}
