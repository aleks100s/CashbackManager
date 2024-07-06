//
//  CashbackListView.swift
//  CashbackApp
//
//  Created by Alexander on 30.06.2024.
//

import SwiftUI

struct CashbackListView: View {
	let cashback: [Cashback]
	
	var body: some View {
		List {
			ForEach(cashback) { cashback in
				CashbackView(cashback: cashback)
			}
		}
	}
}
