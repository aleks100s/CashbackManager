//
//  File.swift
//  IncomeFeature
//
//  Created by Alexander on 11.10.2024.
//

import Domain
import Shared
import SwiftUI

struct IncomeView: View {
	let income: Income
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Image(systemName: Constants.SFSymbols.cashback)
					.foregroundStyle(Color(hex: income.source?.color ?? ""))

				Text(income.source?.name ?? "Кэшбэк")
				
				Spacer()
				
				Text(income.amount, format: .currency(code: "RUB").precision(.fractionLength(.zero)))
			}
			
			Text(income.date, format: .dateTime)
				.font(.callout)
				.foregroundStyle(.secondary)
		}
	}
}
