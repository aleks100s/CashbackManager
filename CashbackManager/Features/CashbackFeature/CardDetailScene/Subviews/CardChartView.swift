//
//  CardChartView.swift
//  CashbackManager
//
//  Created by Alexander on 19.02.2025.
//

import Charts
import SwiftUI

extension CardDetailView {
	struct CardChartView: View {
		let card: Card

		@State private var chartData = [CardChartModel]()

		@Environment(\.incomeService) private var incomeService
		
		var body: some View {
			Group {
				if !chartData.isEmpty {
					Section("Последние 10 выплат") {
						Chart(chartData) { data in
							BarMark(x: .value("Дата", data.date), y: .value("Сумма", data.amount))
								.foregroundStyle(Color(hex: card.color ?? "#D7D7D7"))
						}
						.chartLegend(.visible)
						.scaledToFit()
						.padding()
					}
				}
			}
			.onAppear {
				setupChart()
			}
		}
		
		func setupChart() {
			guard let transactions = incomeService?.fetchIncomes(for: card) else { return }
			
			chartData = transactions.compactMap { transaction -> CardChartModel? in
				guard let source = transaction.source else { return nil }
				
				return CardChartModel(
					id: source.id,
					date: transaction.date,
					amount: transaction.amount
				)
			}
		}
	}
}
