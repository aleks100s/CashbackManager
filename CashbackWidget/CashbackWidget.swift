//
//  CashbackWidget.swift
//  CashbackWidget
//
//  Created by Alexander on 20.07.2024.
//

import WidgetKit
import SwiftUI

struct CashbackWidget: Widget {
    let kind: String = "CashbackWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
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
    }
}

#Preview(as: .systemSmall) {
    CashbackWidget()
} timeline: {
	Entry(date: .now, card: .sberCard)
    Entry(date: .now, card: nil)
}
