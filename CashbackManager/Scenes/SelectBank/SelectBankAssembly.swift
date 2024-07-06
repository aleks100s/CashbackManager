//
//  SelectBankAssembly.swift
//  CashbackManager
//
//  Created by Alexander on 27.06.2024.
//

import SwiftUI

enum SelectBankAssembly {
	@MainActor
	static func assemble(coordinator: SelectBankCoordinator, cashbackService: ICashbackService) -> some View {
		let effectHandler = SelectBankEffectHandler(coordinator: coordinator, cashbackService: cashbackService)
		let store = SelectBankStore(state: .init(), effectHandler: effectHandler)
		let view = SelectBankScreen(store: store)
		return view
	}
}
