//
//  File.swift
//  IncomeFeature
//
//  Created by Alexander on 11.10.2024.
//

import AppIntents
import Domain
import SwiftUI

struct Coordinator: View {
	enum Path: Hashable {
		case editIncome(Income)
	}

	let createIncomeIntent: any AppIntent
	
	@State private var isAddIncomePresented = false
	@State private var path: [Path] = []
	
	@Environment(\.incomeService) private var incomeService
	
	var body: some View {
		NavigationStack(path: $path) {
			PaymentsView {
				isAddIncomePresented = true
			} onEditIncomeTapped: { income in
				path.append(.editIncome(income))
			}
			.navigationDestination(for: Path.self) { path in
				switch path {
				case .editIncome(let income):
					AddIncomeView(createIncomeIntent: createIncomeIntent, income: income)
				}
			}
		}
		.sheet(isPresented: $isAddIncomePresented) {
			NavigationView {
				AddIncomeView(createIncomeIntent: createIncomeIntent)
			}
			.presentationDetents([.large])
		}
	}
}
