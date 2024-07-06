//
//  AddCashbackAssembly.swift
//  CashbackManager
//
//  Created by Alexander on 27.06.2024.
//

import SwiftUI

enum AddCashbackAssembly {
	@MainActor
	static func assemble(card: Card, coordinator: AddCashbackCoordinator, categoryService: ICategoryService, cashbackService: ICashbackService) -> some View {
		let initialState = AddCashbackState(card: card)
		let effectHandler = AddCashbackEffectHandler(coordinator: coordinator, categoryService: categoryService, cashbackService: cashbackService)
		let store = AddCashbackStore(state: initialState, effectHandler: effectHandler)
		let view = AddCashbackScreen(store: store)
		return view
	}
}
