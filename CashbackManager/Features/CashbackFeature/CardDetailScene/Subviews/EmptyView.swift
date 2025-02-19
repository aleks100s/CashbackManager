//
//  EmptyView.swift
//  CashbackManager
//
//  Created by Alexander on 19.02.2025.
//

import SwiftUI

extension CardDetailView {
	struct EmptyView: View {
		var body: some View {
			Section {
				ContentUnavailableView(
					"Добавьте кэшбэк со скриншота или вручную",
					systemImage: "rublesign.circle"
				)
			}
		}
	}
}
