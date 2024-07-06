//
//  CashbackAssembly.swift
//  CashbackManager
//
//  Created by Alexander on 25.06.2024.
//

import SwiftUI

enum CashbackAssembly {
	@MainActor
	static func assemble(
		card: Card,
		coordinator: CashbackCoordinator,
		cashbackService: ICashbackService
	) -> some View {
		let state = CashbackState(card: card)
		let effectHandler = CashbackEffectHandler(coordinator: coordinator, cashbackService: cashbackService)
		let store = CashbackStore(state: state, effectHandler: effectHandler)
		let view = CashbackScreen(store: store)
		return view
	}
}
