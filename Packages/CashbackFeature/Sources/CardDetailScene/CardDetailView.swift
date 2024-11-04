//
//  CashbackView.swift
//  CashbackManager
//
//  Created by Alexander on 19.06.2024.
//

import AppIntents
import CategoryService
import CardsService
import Domain
import DesignSystem
import IncomeService
import PhotosUI
import Shared
import SwiftData
import SwiftUI
import TextDetectionService
import WidgetKit

public struct CardDetailView: View {
	private let card: Card
	private let cardCashbackIntent: any AppIntent
	private let onAddCashbackTap: () -> Void
	
	@AppStorage(Constants.StorageKey.currentCardID, store: .appGroup)
	private var currentCardId: String?
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@State private var imageItem: PhotosPickerItem?
	@State private var animateGradient = false
	@State private var isEditing = false
	@State private var cardName: String
	@State private var color: Color
	@State private var toast: Toast?
	@State private var isDeleteCardWarningPresented = false
	@State private var isDeleteTransactionsWarningPresented = false
	
	@Environment(\.dismiss) private var dismiss
	@Environment(\.cardsService) private var cardsService
 	@Environment(\.categoryService) private var categoryService
	@Environment(\.textDetectionService) private var textDetectionService
	@Environment(\.incomeService) private var incomeService

	public init(card: Card, cardCashbackIntent: any AppIntent, onAddCashbackTap: @escaping () -> Void) {
		self.card = card
		self.cardCashbackIntent = cardCashbackIntent
		self.onAddCashbackTap = onAddCashbackTap
		cardName = card.name
		color = Color(hex: card.color ?? "")
	}
	
	public var body: some View {
		contentView
			.background(Color.cmScreenBackground)
			.navigationTitle(cardName)
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				if !isEditing {
					ToolbarItem(placement: .bottomBar) {
						addCashbackButton
					}
				}
				
				ToolbarItem(placement: .topBarTrailing) {
					editButton
				}
			}
			.onAppear {
				currentCardId = card.id.uuidString
				refreshWidget()
			}
			.onChange(of: isEditing) { _, newValue in
				if !newValue, !cardName.isEmpty {
					card.name = cardName
					card.color = color.toHex()
					cardsService?.update(card: card)
					toast = Toast(title: "Карта обновлена")
				}
			}
			.toast(item: $toast)
			.alert("Вы уверены?", isPresented: $isDeleteCardWarningPresented) {
				Button("Удалить только карту", role: .destructive) {
					archive(card: card)
				}
				
				Button("Удалить карту вместе с транзакциями", role: .destructive) {
					archive(card: card, shouldDeleteTransactions: true)
				}
				
				Button("Отмена", role: .cancel) {
					isDeleteCardWarningPresented = false
				}
			}
			.alert("Вы уверены?", isPresented: $isDeleteTransactionsWarningPresented) {
				Button("Удалить", role: .destructive) {
					deleteTransactions(from: card)
				}
				
				Button("Отмена", role: .cancel) {
					isDeleteTransactionsWarningPresented = false
				}
			}
	}
	
	@ViewBuilder
	private var contentView: some View {
		List {
			if !isEditing, areSiriTipsVisible, !card.isEmpty {
				IntentTipView(intent: cardCashbackIntent, text: "Чтобы быстро проверить кэшбэки на карте")
			}
			
			if isEditing {
				Section("Редактировать название и цвет") {
					TextField("Название карты", text: $cardName)
						.textFieldStyle(.plain)
					
					ColorPicker("Цвет карты", selection: $color)
				}
			}
			
			if card.isEmpty {
				Section {
					ContentUnavailableView("Нет сохраненных кэшбэков", systemImage: "rublesign.circle")
				}
			} else {
				Section("Кэшбэки") {
					ForEach(card.sortedCashback) { cashback in
						CashbackView(cashback: cashback)
							.contextMenu {
								deleteCashbackButton(cashback: cashback)
							}
					}
					.onDelete { indexSet in
						for index in indexSet {
							deleteCashback(index: index)
						}
					}
				}
			}
			
			if isEditing {
				Section {
					if !card.isEmpty {
						Button("Удалить все кэшбэки с карты", role: .destructive) {
							for cashback in card.cashback {
								delete(cashback: cashback)
							}
						}
					}
					
					Button("Удалить все транзакции", role: .destructive) {
						isDeleteTransactionsWarningPresented = true
					}
					
					Button("Удалить карту", role: .destructive) {
						isDeleteCardWarningPresented = true
					}
				} header: {
					Text("Для отважных пользователей")
				} footer: {
					Text("Данные действия нельзя отменить")
				}
			} else {
				detectCashbackSectionButton
			}
		}
	}
	
	private var addCashbackButton: some View {
		Button("Добавить кэшбэк вручную") {
			onAddCashbackTap()
		}
	}
	
	private var editButton: some View {
		Button(isEditing ? "Готово" : "Править") {
			isEditing.toggle()
			hapticFeedback(.light)
		}
		.disabled(cardName.isEmpty)
	}
	
	private var detectCashbackSectionButton: some View {
		DetectCashbackSectionButton(imageItem: $imageItem, animateGradient: $animateGradient) {
			Task.detached {
				do {
					try await detectCashbackFromImage()
				} catch {
					await MainActor.run {
						toast = Toast(title: error.localizedDescription)
					}
				}
			}
		}
	}
	
	private func deleteCashbackButton(cashback: Cashback) -> some View {
		Button(role: .destructive) {
			delete(cashback: cashback)
		} label: {
			Text("Удалить")
		}
	}
	
	private func deleteCashback(index: Int) {
		delete(cashback: card.sortedCashback[index])
	}
	
	private func delete(cashback: Cashback) {
		cardsService?.delete(cashback: cashback, card: card)
		toast = Toast(title: "Кэшбэк удален")
	}
	
	private func deleteTransactions(from card: Card) {
		incomeService?.deleteIncomes(card: card)
		toast = Toast(title: "Транзакции успешно удалены")
	}
	
	private func archive(card: Card, shouldDeleteTransactions: Bool = false) {
		if shouldDeleteTransactions {
			deleteTransactions(from: card)
		}
		cardsService?.archive(card: card)
		currentCardId = nil
		dismiss()
	}
	
	private func refreshWidget() {
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
	}
}

private extension CardDetailView {
	func detectCashbackFromImage() async throws {
		defer {
			imageItem = nil
		}
		
		let data = try await imageItem?.loadTransferable(type: Data.self) ?? Data()
		let image = UIImage(data: data) ?? UIImage()
		
		let result = await textDetectionService?.recogniseCashbackCategories(from: image) ?? []
		guard !result.isEmpty else { return }
		
		apply(result: result)
	}
	
	@MainActor
	func apply(result: [(String, Double)]) {
		for item in result {
			guard let category = categoryService?.getCategory(by: item.0), !card.has(category: category), item.1 > 0 else {
				continue
			}
			
			let cashback = Cashback(category: category, percent: item.1)
			cardsService?.add(cashback: cashback, card: card)
		}
		toast = Toast(title: "Кэшбэки считаны!")
		refreshWidget()
	}
}

private struct DetectCashbackSectionButton: View {
	@Binding var imageItem: PhotosPickerItem?
	@Binding var animateGradient: Bool
	
	let onTap: () -> Void
	
	var body: some View {
		Section {
			PhotosPicker(selection: $imageItem, matching: .any(of: [.screenshots, .images])) {
				Text("Считать кэшбэки со скриншота")
					.foregroundStyle(.white)
					.bold()
					.padding()
					.padding(.horizontal, 12)
					.frame(maxWidth: .infinity, alignment: .leading)
					.background(
						LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]), startPoint: .leading, endPoint: .trailing)
							.hueRotation(.degrees(animateGradient ? 360 : 0))
							.opacity(0.8)
							.animation(.linear(duration: 3).repeatForever(autoreverses: false), value: animateGradient)
					)
					.onAppear {
						animateGradient.toggle()
					}
			}
			.listRowBackground(Color.clear)
			.listRowInsets(EdgeInsets(top: .zero, leading: -12, bottom: .zero, trailing: -12))
			.onChange(of: imageItem) {
				onTap()
			}
		} footer: {
			Text("Будут считаны только кэшбэки, чьи категории представлены в приложении и не добалены на эту карту")
				.offset(x: -8)
		}
	}
}
