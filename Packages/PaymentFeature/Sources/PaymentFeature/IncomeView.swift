//
//  File.swift
//  IncomeFeature
//
//  Created by Alexander on 11.10.2024.
//

import Domain
import SwiftUI

struct IncomeView: View {
	let income: Income
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text(income.source ?? "Кэшбэк")
				
				Spacer()
				
				Text(income.amount, format: .currency(code: "RUB").precision(.fractionLength(.zero)))
			}
			
			Text(income.date, format: .dateTime)
				.font(.callout)
				.foregroundStyle(.secondary)
		}
	}
}
