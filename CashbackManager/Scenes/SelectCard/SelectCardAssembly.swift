//
//  SelectCardAssembly.swift
//  CashbackManager
//
//  Created by Alexander on 27.06.2024.
//

import SwiftUI

enum SelectCardAssembly {
	@MainActor
	static func assemble(bank: Bank, coordinator: SelectCardCoordinator, cashbackService: ICashbackService) -> some View {
		let effectHandler = SelectCardEffectHandler(coordinator: coordinator, cashbackService: cashbackService)
		let initialState = SelectCardState(bank: bank)
		let store = SelectCardStore(state: initialState, effectHandler: effectHandler)
		let view = SelectCardScreen(store: store)
		return view
	}
}
