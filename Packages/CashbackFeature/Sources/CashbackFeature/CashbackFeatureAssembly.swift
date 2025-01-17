//
//  CashbackFeatureAssembly.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import AppIntents
import CardsService
import SwiftData
import SwiftUI

@MainActor
public enum CashbackFeatureAssembly {
	public static func assemble(
		addCardIntent: any AppIntent,
		checkCategoryCardIntent: any AppIntent,
		cardCashbackIntent: any AppIntent,
		addCategoryIntent: any AppIntent,
		addCashbackIntent: any AppIntent
	) -> some View {
		Coordinator(
			addCardIntent: addCardIntent,
			checkCategoryCardIntent: checkCategoryCardIntent,
			cardCashbackIntent: cardCashbackIntent,
			addCategoryIntent: addCategoryIntent,
			addCashbackIntent: addCashbackIntent
		)
	}
}
