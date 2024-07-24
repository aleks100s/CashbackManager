//
//  CardDetailAssembly.swift
//  CashbackManager
//
//  Created by Alexander on 25.06.2024.
//

import Domain
import SwiftUI

enum CardDetailAssembly {
	@MainActor
	static func assemble(
		card: Card,
		coordinator: CardDetailCoordinator,
		cashbackService: ICashbackService
	) -> some View {
		let state = CardDetailState(card: card)
		let effectHandler = CashbackEffectHandler(coordinator: coordinator, cashbackService: cashbackService)
		let store = CardDetailStore(state: state, effectHandler: effectHandler)
		let view = CardDetailScreen(store: store)
		return view
	}
}
