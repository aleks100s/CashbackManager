//
//  File.swift
//  IncomeFeature
//
//  Created by Alexander on 11.10.2024.
//

import AppIntents
import SwiftUI

struct Coordinator: View {
	let createIncomeIntent: any AppIntent
	
	@State private var isAddIncomePresented = false
	
	@Environment(\.incomeService) private var incomeService
	
	var body: some View {
		NavigationStack {
			if let incomeService {
				let model = IncomePeriodModel(incomeService: incomeService) {
					isAddIncomePresented = true
				}
				IncomePeriodView(model: model)
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
