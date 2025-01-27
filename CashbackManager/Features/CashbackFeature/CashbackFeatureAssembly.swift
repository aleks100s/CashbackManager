//
//  CashbackFeatureAssembly.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import AppIntents
import SwiftData
import SwiftUI

@MainActor
enum CashbackFeatureAssembly {
	static func assemble(
		addCardIntent: any AppIntent,
		checkCategoryCardIntent: any AppIntent,
		cardCashbackIntent: any AppIntent,
		addCategoryIntent: any AppIntent,
		addCashbackIntent: any AppIntent
	) -> some View {
		CashbackCoordinator(
			addCardIntent: addCardIntent,
			checkCategoryCardIntent: checkCategoryCardIntent,
			cardCashbackIntent: cardCashbackIntent,
			addCategoryIntent: addCategoryIntent,
			addCashbackIntent: addCashbackIntent
		)
	}
}
