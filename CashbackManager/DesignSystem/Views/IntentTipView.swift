//
//  File.swift
//  
//
//  Created by Alexander on 15.09.2024.
//

import AppIntents
import SwiftUI

struct IntentTipView: View {
	private let intent: any AppIntent
	private let text: String?
	
	init(intent: any AppIntent, text: String? = nil) {
		self.intent = intent
		self.text = text
	}
	
	var body: some View {
		Section {
			VStack(alignment: .leading) {
				if let text {
					Text(text)
						.foregroundStyle(.secondary)
						.font(.footnote)
						.bold()
						.padding(.leading, 8)
				}
				SiriTipView(intent: intent)
			}
		}
		.listSectionSpacing(8)
		.listRowBackground(Color.clear)
		.listRowInsets(EdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
	}
}
