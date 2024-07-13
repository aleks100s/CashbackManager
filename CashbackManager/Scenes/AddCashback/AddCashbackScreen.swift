//
//  AddCashbackScreen.swift
//  CashbackManager
//
//  Created by Alexander on 26.06.2024.
//

import SwiftUI

struct AddCashbackScreen: View {
	@State var store: AddCashbackStore
	@FocusState private var isFocused
	@State private var percentString = "5"
	
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
							CMProminentButton("Выбрать категорию") {
								store.send(.selectCategoryTapped)
							}
						}
					}
					
					if store.selectedCategory != nil {
						ScrollView(.horizontal) {
							LazyHStack {
								CMProminentButton("Другой процент") {
									store.send(.onInputPercentButtonTapped)
								}
								
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
		.onTapGesture {
			isFocused = false
		}
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
				} onSaveCategoryButtonTapped: { newCategoryName in
					store.send(.saveNewCategory(newCategoryName))
				}
			}
			.navigationTitle("Выбор категории")
			.navigationBarTitleDisplayMode(.inline)
			.presentationDetents([.large])
			.presentationBackground(.regularMaterial)
		}
		.sheet(
			isPresented: Binding(
				get: { store.isPercentInputSheetPresented },
				set: { value, _ in
					if value {
						store.send(.onInputPercentButtonTapped)
					} else {
						store.send(.dismissInputPercentSheet)
					}
				}
			)
		) {
			NavigationView {
				InputPercentView(percentString: String(format: "%.0f", store.percent * 100)) { value in
					store.send(.updatePercentString(value))
				}
			}
			.navigationTitle("Процент кэщбека")
			.navigationBarTitleDisplayMode(.inline)
			.presentationDetents([.medium])
			.presentationBackground(.regularMaterial)
		}
		.onAppear {
			store.send(.viewDidAppear)
		}
	}
}
