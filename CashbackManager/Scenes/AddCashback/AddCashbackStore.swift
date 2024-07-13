//
//  AddCashbackStore.swift
//  CashbackManager
//
//  Created by Alexander on 26.06.2024.
//

import Domain
import Store

typealias AddCashbackStore = Store<AddCashbackState, AddCashbackEffectHandler>

struct AddCashbackState {
	let card: Card
	let percentPresets: [Double] = [0.01, 0.015, 0.02, 0.03, 0.05, 0.07, 0.1, 0.15, 0.2, 0.25]
	var selectedCategory: Domain.Category?
	var percent: Double = 0.05
	var categories = [Domain.Category]()
	var filteredCategories = [Domain.Category]()
	var isCategorySelectorPresented = false
	var searchText: String = ""
	var isPercentInputSheetPresented = false
}

extension AddCashbackState: StoreState {
	enum Input {
		case viewDidAppear
		case selectCategoryTapped
		case categorySelected(Domain.Category)
		case dismissSelection
		case updatePercent(Double)
		case saveCashbackTapped
		case searchTextChanged(String)
		case saveNewCategory(String)
		case onInputPercentButtonTapped
		case dismissInputPercentSheet
		case updatePercentString(String)
	}
	
	enum Effect {
		case fetchCategories
		case updateCard(Card)
		case saveCategory(Domain.Category)
	}
	
	enum Feedback {
		case categoriesFetched([Domain.Category])
		case categorySaved
	}
	
	static func reduce(state: inout AddCashbackState, with message: Message<Input, Feedback>) -> Effect? {
		switch message {
		case .input(.viewDidAppear):
			return .fetchCategories
		case .input(.selectCategoryTapped):
			state.isCategorySelectorPresented = true
		case .input(.dismissSelection):
			state.isCategorySelectorPresented = false
		case .input(.categorySelected(let category)):
			state.selectedCategory = category
			state.isCategorySelectorPresented = false
		case .input(.updatePercent(let percent)):
			state.percent = percent
		case .input(.updatePercentString(let string)):
			let text = string.replacingOccurrences(of: ",", with: ".")
			let percent = (Double(text) ?? 0) / 100
			state.percent = percent
			state.isPercentInputSheetPresented = false
		case .input(.saveCashbackTapped):
			if let category = state.selectedCategory {
				var card = state.card
				let cashback = Cashback(category: category, percent: state.percent)
				card.cashback.append(cashback)
				return .updateCard(card)
			}
		case .input(.searchTextChanged(let text)):
			state.searchText = text
			if text.isEmpty {
				state.filteredCategories = state.categories
			} else {
				state.filteredCategories = state.categories.filter { $0.name.lowercased().contains(text.lowercased()) }
			}
		case .input(.saveNewCategory(let categoryName)):
			let category = Domain.Category(name: categoryName, emoji: "\(categoryName.uppercased().first ?? "?")")
			return .saveCategory(category)
		case .input(.onInputPercentButtonTapped):
			state.isPercentInputSheetPresented = true
		case .input(.dismissInputPercentSheet):
			state.isPercentInputSheetPresented = false
		case .feedback(.categoriesFetched(let categories)):
			state.categories = categories
			state.filteredCategories = categories
		case .feedback(.categorySaved):
			return .fetchCategories
		}
		return nil
	}
}

final class AddCashbackEffectHandler: EffectHandler {
	typealias S = AddCashbackState
	
	private let coordinator: AddCashbackCoordinator
	private let categoryService: ICategoryService
	private let cashbackService: ICashbackService
	
	init(
		coordinator: AddCashbackCoordinator,
		categoryService: ICategoryService,
		cashbackService: ICashbackService
	) {
		self.coordinator = coordinator
		self.categoryService = categoryService
		self.cashbackService = cashbackService
	}
	
	func handle(effect: AddCashbackState.Effect) async -> AddCashbackState.Feedback? {
		switch effect {
		case .fetchCategories:
			let categories = categoryService.getCategories()
			return .categoriesFetched(categories)
		case .updateCard(let card):
			cashbackService.update(card: card)
			coordinator.navigateBack()
		case .saveCategory(let category):
			categoryService.save(category: category)
			return .categorySaved
		}
		return nil
	}
}
