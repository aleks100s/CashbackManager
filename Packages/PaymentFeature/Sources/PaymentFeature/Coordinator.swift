//
//  File.swift
//  IncomeFeature
//
//  Created by Alexander on 11.10.2024.
//

import SwiftUI

struct Coordinator: View {
	@State private var isAddIncomePresented = false
	
	var body: some View {
		NavigationStack {
			IncomeListView {
				isAddIncomePresented = true
			}
		}
		.sheet(isPresented: $isAddIncomePresented) {
			NavigationView {
				AddIncomeView()
			}
			.presentationDetents([.large])
		}
	}
}
