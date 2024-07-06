//
//  AddCashbackScreen.swift
//  CashbackApp
//
//  Created by Alexander on 26.06.2024.
//

import SwiftUI

struct AddCashbackScreen: View {
	@State var store: AddCashbackStore
	@FocusState private var isFocused
	
	var body: some View {
		ScrollView(.vertical) {
			HStack {
				Spacer()
				VStack(alignment: .leading, spacing: 32) {
					Spacer()
					
					HStack {
						if let category = store.selectedCategory {
							Button {
								store.send(.selectCategoryTapped)
							} label: {
								HStack {
									CategoryView(category: category)
									
									Text(store.percent, format: .percent)
										.padding()
								}
							}
							.buttonStyle(PlainButtonStyle())
						} else {
							Button {
								store.send(.selectCategoryTapped)
							} label: {
								Text("Выбрать категорию")
							}
							.buttonStyle(BorderedProminentButtonStyle())
						}
					}
					
					if store.selectedCategory != nil {
						ScrollView(.horizontal) {
							LazyHStack {
								ForEach(store.percentPresets, id: \.self) { percent in
									Button {
										store.send(.updatePercent(percent))
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
		.background(Color(UIColor.secondarySystemBackground))
		.navigationTitle("Добавить кэшбек")
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Сохранить") {
					store.send(.saveCashbackTapped)
				}
				.disabled(store.selectedCategory == nil || store.percent == 0)
			}
		}
		.sheet(
			isPresented: Binding(
				get: { store.isCategorySelectorPresented },
				set: { value, _ in
					if value {
						store.send(.selectCategoryTapped)
					} else {
						store.send(.dismissSelection)
					}
				}
			)
		) {
			NavigationView {
				SelectCategoryView(categories: store.filteredCategories, searchText: store.searchText) { category in
					store.send(.categorySelected(category))
				} onSearchTextChange: { text in
					store.send(.searchTextChanged(text))
				}
			}
			.navigationTitle("Выбор категории")
			.navigationBarTitleDisplayMode(.inline)
			.presentationDetents([.large])
		}
		.onAppear {
			store.send(.viewDidAppear)
		}
	}
}
