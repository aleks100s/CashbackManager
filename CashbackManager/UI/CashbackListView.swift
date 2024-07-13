//
//  CashbackListView.swift
//  CashbackManager
//
//  Created by Alexander on 30.06.2024.
//

import Domain
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
