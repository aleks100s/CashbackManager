//
//  CashbackListView.swift
//  CashbackManager
//
//  Created by Alexander on 30.06.2024.
//

import Domain
import SwiftUI

public struct CashbackListView: View {
	private let cashback: [Cashback]
	
	public init(cashback: [Cashback]) {
		self.cashback = cashback
	}
	
	public var body: some View {
		List {
			ForEach(cashback) { cashback in
				CashbackView(cashback: cashback)
			}
		}
	}
}
