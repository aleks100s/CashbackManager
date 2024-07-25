//
//  AddCashbackScreen.swift
//  CashbackManager
//
//  Created by Alexander on 26.06.2024.
//

import CommonInput
import DesignSystem
import Domain
import SwiftData
import SwiftUI

struct AddCashbackScreen: View {
	let card: Card
	
	private let percentPresets = [0.01, 0.015, 0.02, 0.03, 0.05, 0.07, 0.1, 0.15, 0.2, 0.25]
	
	@State private var percent = 0.05
	@State private var selectedCategory: Domain.Category?
	@State private var isCategorySelectorPresented = false
	@FocusState private var isFocused
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var context
	
	var body: some View {
		ScrollView(.vertical) {
			HStack {
				Spacer()
				VStack(alignment: .leading, spacing: 32) {
					Spacer()
					
					if let category = selectedCategory {
						Button {
							isCategorySelectorPresented = true
						} label: {
							HStack {
								CategoryView(category: category)
								
								Text(percent, format: .percent)
									.padding()
							}
							.contentShape(Rectangle())
						}
						.buttonStyle(PlainButtonStyle())
					}
					
					if selectedCategory != nil {
						ScrollView(.horizontal) {
							LazyHStack {
								CMProminentButton("Другой процент") {
									
								}
								
								ForEach(percentPresets, id: \.self) { percent in
									Button {
										self.percent = percent
									} label: {
										Text(percent, format: .percent)
									}
									.buttonStyle(BorderedProminentButtonStyle())
									.padding()
								}
							}
						}
					}
				}
				Spacer()
			}
		}
		.background(Color.cmScreenBackground)
		.onTapGesture {
			isFocused = false
		}
		.navigationTitle("Добавить кэшбек")
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Сохранить") {
					if let selectedCategory {
						let cashback = Cashback(category: selectedCategory, percent: percent)
						context.insert(cashback)
						card.cashback.append(cashback)
						dismiss()
					}
				}
				.disabled(selectedCategory == nil || percent == 0)
			}
			
			if selectedCategory == nil {
				ToolbarItem(placement: .bottomBar) {
					Button("Выбрать категорию") {
						isCategorySelectorPresented = true
					}
				}
			}
		}
		.sheet(isPresented: $isCategorySelectorPresented) {
			NavigationView {
				SelectCategoryView { category in
					selectedCategory = category
					isCategorySelectorPresented = false
				}
			}
			.navigationTitle("Выбор категории")
			.navigationBarTitleDisplayMode(.inline)
			.presentationDetents([.large])
			.presentationBackground(.regularMaterial)
		}
	}
}
