//
//  CashbackListView.swift
//  CashbackManager
//
//  Created by Alexander on 30.06.2024.
//

import SwiftUI

struct CashbackListView: View {
	private let cashback: [Cashback]
	
	init(cashback: [Cashback]) {
		self.cashback = cashback
	}
	
	var body: some View {
		List {
			ForEach(cashback) { cashback in
				CashbackView(cashback: cashback)
			}
		}
	}
}
