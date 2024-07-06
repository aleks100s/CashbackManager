//
//  CashbackScreen.swift
//  CashbackManager
//
//  Created by Alexander on 19.06.2024.
//

import SwiftUI

struct CashbackScreen: View {
	@State private var store: CashbackStore
	
	init(store: CashbackStore) {
		self.store = store
	}
	
	var body: some View {
		List {
			ForEach(store.card.cashback) { cashback in
				CashbackView(cashback: cashback)
					.contextMenu {
						Button(role: .destructive) {
							store.send(.onDeleteCashbackMenuTap(cashback))
						} label: {
							Text("Удалить")
						}
					}
			}
			.onDelete { indexSet in
				store.send(.onDeleteCashbackTap(indexSet))
			}
		}
		.navigationTitle(store.card.name)
		.toolbar {
			ToolbarItem(placement: .bottomBar) {
				Button("Добавить кэшбек") {
					store.send(.onAddCashbackTap)
				}
			}
		}
		.onAppear {
			store.send(.viewDidAppear)
		}
	}
}
