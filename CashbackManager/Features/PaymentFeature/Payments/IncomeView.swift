//
//  File.swift
//  IncomeFeature
//
//  Created by Alexander on 11.10.2024.
//

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
				
				Text(String(format: "%d \(income.source?.currencySymbol ?? "")", income.amount))
			}
			
			Text(income.date, format: .dateTime.month(.wide).day().year())
				.font(.callout)
				.foregroundStyle(.secondary)
		}
	}
}
