//
//  SelectBankScreen.swift
//  CashbackManager
//
//  Created by Alexander on 19.06.2024.
//

import CommonInput
import SwiftUI

struct SelectBankScreen: View {
	@State var store: SelectBankStore
	
	var body: some View {
		List {
			ForEach(store.banks) { bank in
				Button {
					store.send(.bankSelected(bank))
				} label: {
					ItemView(bank: bank)
				}
				.buttonStyle(.plain)
				.contextMenu {
					Text(bank.name)
					Button {
						store.send(.renameBankButtonTapped(bank))
					} label: {
						Text("Переименовать банк")
					}
					Button(role: .destructive) {
						store.send(.deleteBankButtonTapped(bank))
					} label: {
						Text("Удалить банк")
					}
				}
			}
			.onDelete { indexSet in
				store.send(.onBankDeleted(indexSet))
			}
			
			Button {
				store.send(.addBankButtonTapped)
			} label: {
				Text("Добавить новый банк")
			}
		}
		.navigationTitle("Выбери банк")
		.onAppear {
			store.send(.viewDidAppear)
		}
		.sheet(isPresented: Binding(get: { store.isAddBankSheetPresented }, set: { value, _ in  store.send(value ? .addBankButtonTapped : .addBankDismiss) })) {
			NavigationView {
				CommonInputView("Название банка") { name in
					store.send(.saveBank(name))
				}
				.navigationTitle("Добавить новый банк")
				.navigationBarTitleDisplayMode(.inline)
			}
			.presentationDetents([.medium])
			.presentationBackground(.regularMaterial)
		}
		.sheet(item: Binding(get: { store.bankToBeRenamed }, set: { _ in store.send(.dismissRenameBankSheet) })) { bank in
			NavigationView {
				CommonInputView("Название банка", text: bank.name) { name in
					store.send(.onBankRenamed(name))
				}
				.navigationTitle("Переименовать банк")
				.navigationBarTitleDisplayMode(.inline)
			}
			.presentationDetents([.medium])
			.presentationBackground(.regularMaterial)
		}
	}
}

import Domain

private extension SelectBankScreen {
	struct ItemView: View {
		let bank: Bank
		
		var body: some View {
			VStack(alignment: .leading, spacing: .zero) {
				Text(bank.name)
					.font(.title2.bold())
				
				HStack {
					if bank.cards.isEmpty {
						Text("Нет карт")
					} else {
						Text("Карты:")
						Text(bank.cardsList)
							.truncationMode(.tail)
					}
					Spacer()
				}
			}
			.lineLimit(1)
			.contentShape(Rectangle())
		}
	}
}
