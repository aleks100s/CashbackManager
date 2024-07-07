//
//  SelectBankStore.swift
//  CashbackManager
//
//  Created by Alexander on 27.06.2024.
//

import Foundation

typealias SelectBankStore = Store<SelectBankState, SelectBankEffectHandler>

struct SelectBankState {
	var banks = [Bank]()
	var isAddBankSheetPresented: Bool = false
	var bankToBeRenamed: Bank?
}

extension SelectBankState: StoreState {
	enum Input {
		case viewDidAppear
		case addBankButtonTapped
		case addBankDismiss
		case bankSelected(Bank)
		case saveBank(String)
		case onBankDeleted(IndexSet)
		case deleteBankButtonTapped(Bank)
		case renameBankButtonTapped(Bank)
		case dismissRenameBankSheet
		case onBankRenamed(String)
	}
	
	enum Effect {
		case fetchBanks
		case navigateToBankDetail(Bank)
		case saveBank(Bank)
		case updateBanks([Bank])
		case renameBank(Bank)
	}
	
	enum Feedback {
		case banksFetched([Bank])
		case banksUpdated
	}
	
	static func reduce(state: inout SelectBankState, with message: Message<Input, Feedback>) -> Effect? {
		switch message {
		case .input(.viewDidAppear):
			return .fetchBanks
		case .input(.addBankButtonTapped):
			state.isAddBankSheetPresented = true
		case .input(.addBankDismiss):
			state.isAddBankSheetPresented = false
		case .input(.bankSelected(let bank)):
			return .navigateToBankDetail(bank)
		case .input(.saveBank(let name)):
			state.isAddBankSheetPresented = false
			let bank = Bank(name: name, cards: [])
			return .saveBank(bank)
		case .input(.onBankDeleted(let indexSet)):
			state.banks.remove(atOffsets: indexSet)
			return .updateBanks(state.banks)
		case .input(.deleteBankButtonTapped(let bank)):
			state.banks.removeAll { $0.id == bank.id }
			return .updateBanks(state.banks)
		case .input(.renameBankButtonTapped(let bank)):
			state.bankToBeRenamed = bank
		case .input(.dismissRenameBankSheet):
			state.bankToBeRenamed = nil
		case .input(.onBankRenamed(let name)):
			if var bank = state.bankToBeRenamed {
				bank.name = name
				state.bankToBeRenamed = nil
				return .renameBank(bank)
			}
		case .feedback(.banksFetched(let banks)):
			state.banks = banks
		case .feedback(.banksUpdated):
			return .fetchBanks
		}
		return nil
	}
}

final class SelectBankEffectHandler: EffectHandler {
	typealias S = SelectBankState
	
	private let coordinator: SelectBankCoordinator
	private let cashbackService: ICashbackService
	
	init(coordinator: SelectBankCoordinator, cashbackService: ICashbackService) {
		self.coordinator = coordinator
		self.cashbackService = cashbackService
	}
	
	func handle(effect: SelectBankState.Effect) async -> SelectBankState.Feedback? {
		switch effect {
		case .fetchBanks:
			let banks = cashbackService.getBanks()
			return .banksFetched(banks)
		case .saveBank(let bank):
			cashbackService.save(bank: bank)
			return .banksUpdated
		case .navigateToBankDetail(let bank):
			coordinator.navigateToBankDetail(bank: bank)
		case .updateBanks(let banks):
			cashbackService.update(banks: banks)
			return .banksUpdated
		case .renameBank(let bank):
			cashbackService.update(bank: bank)
			return .banksUpdated
		}
		return nil
	}
}
