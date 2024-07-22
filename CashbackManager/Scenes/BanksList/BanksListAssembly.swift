//
//  CardsListAssembly.swift
//  CashbackManager
//
//  Created by Alexander on 20.06.2024.
//

import Domain
import SwiftUI

enum CardsListAssembly {
	@MainActor
	static func assemble(
		banksCoordinator: CardsListCoordinator,
		cashbackService: ICashbackService
	) -> some View {
		let effectHandler = CardsListEffectHandler(coordinator: banksCoordinator, cashbackService: cashbackService)
		let state = CardsListState()
		let store = CardsListStore(state: state, effectHandler: effectHandler)
		let view = CardsListScreen(store: store)
		return view
	}
}
