//
//  BanksListAssembly.swift
//  CashbackManager
//
//  Created by Alexander on 20.06.2024.
//

import SwiftUI

enum BanksListAssembly {
	@MainActor
	static func assemble(
		banksCoordinator: BanksListCoordinator,
		cashbackService: ICashbackService
	) -> some View {
		let effectHandler = BanksListEffectHandler(coordinator: banksCoordinator, cashbackService: cashbackService)
		let state = BanksListState()
		let store = BanksListStore(state: state, effectHandler: effectHandler)
		let view = BanksListScreen(store: store)
		return view
	}
}
