//
//  CashbackView.swift
//  CashbackManager
//
//  Created by Alexander on 19.06.2024.
//

import AppIntents
import Charts
import PhotosUI
import SwiftData
import SwiftUI
import TipKit
import WidgetKit

struct CardDetailView: View {
	private let card: Card
	private let cardCashbackIntent: any AppIntent
	private let onAddCashbackTap: () -> Void
	private let formatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		return formatter
	}()
	
	@AppStorage(Constants.StorageKey.currentCardID, store: .appGroup)
	private var currentCardId: String?
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@AppStorage(Constants.StorageKey.isAdVisible)
	private var isAdVisible: Bool = false
	
	@State private var imageItem: PhotosPickerItem?
	@State private var animateGradient = false
	@State private var isEditing = false
	@State private var cardName: String
	@State private var color: Color
	@State private var isDeleteCardWarningPresented = false
	@State private var isDeleteTransactionsWarningPresented = false
	@State private var chartData = [CardChartModel]()
	
	@Environment(\.dismiss) private var dismiss
	@Environment(\.cardsService) private var cardsService
 	@Environment(\.categoryService) private var categoryService
	@Environment(\.textDetectionService) private var textDetectionService
	@Environment(\.incomeService) private var incomeService
	@Environment(\.toastService) private var toastService

	init(
		card: Card,
		cardCashbackIntent: any AppIntent,
		onAddCashbackTap: @escaping () -> Void
	) {
		self.card = card
		self.cardCashbackIntent = cardCashbackIntent
		self.onAddCashbackTap = onAddCashbackTap
		cardName = card.name
		color = Color(hex: card.color ?? "")
	}
	
	var body: some View {
		contentView
			.background(Color.cmScreenBackground)
			.navigationTitle(cardName)
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					editButton
						.popoverTip(HowToEditCardTip(), arrowEdge: .top)
				}
			}
			.safeAreaInset(edge: .bottom) {
				if isAdVisible {
					AdBannerView(bannerId: bannerId)
						.fixedSize()
						.padding(.top, 100)
				}
			}
			.onAppear {
				currentCardId = card.id.uuidString
				refreshWidget()
				setupChart()
			}
			.onChange(of: isEditing) { _, newValue in
				if !newValue, !cardName.isEmpty {
					card.name = cardName
					card.color = color.toHex()
					cardsService?.update(card: card)
					toastService?.show(Toast(title: "Карта обновлена"))
				}
			}
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
		VStack(spacing: .zero) {
			List {
				if isEditing {
					Section("Редактировать данные карты") {
						TextField("Название карты", text: $cardName)
							.textFieldStyle(.plain)
						
						HStack {
							Text("Выплата кэшбэка")
							Spacer()
							Menu(card.currency) {
								ForEach(Currency.allCases) { currency in
									Button(currency.rawValue) {
										card.currency = currency.rawValue
										card.currencySymbol = currency.symbol
										hapticFeedback(.light)
									}
								}
							}
						}
						
						ColorPicker("Цвет карты", selection: $color)
						
						HStack {
							Text(card.isFavorite ? "В избранном" : "Добавить в избранное")
								.foregroundStyle(.secondary)
							
							Spacer()
							
							Button {
								card.isFavorite.toggle()
								cardsService?.update(card: card)
								toastService?.show(Toast(title: card.isFavorite ? "Добавлено в избранное" : "Удалено из избранного", hasFeedback: false))
							} label: {
								HeartView(isFavorite: card.isFavorite)
							}
						}
					}
					
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
					if card.isEmpty {
						Section {
							ContentUnavailableView("Нет сохраненных кэшбэков", systemImage: "rublesign.circle")
						}
					} else {
						if areSiriTipsVisible {
							IntentTipView(intent: cardCashbackIntent, text: "Чтобы быстро проверить кэшбэки на карте")
						}
						
						Section {
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
							
							TipView(HowToDeleteCashbackTip())
						} header: {
							Text("Кэшбэки")
						} footer: {
							Text("Форма выплаты кэшбэка: \(card.currency)")
						}
					}
					
					addCashbackButton
					
					detectCashbackSectionButton
					
					if !chartData.isEmpty {
						Section("Последние 10 выплат") {
							Chart(chartData) { data in
								PointMark(x: .value("Дата", data.date), y: .value("Сумма", data.amount))
									.foregroundStyle(Color(hex: card.color ?? "#D7D7D7"))
								LineMark(x: .value("Дата", data.date), y: .value("Сумма", data.amount))
									.foregroundStyle(Color(hex: card.color ?? "#D7D7D7"))
							}
							.chartLegend(.visible)
							.scaledToFit()
							.padding()
						}
					}
				}
			}
			.scrollIndicators(.hidden)
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
						toastService?.show(Toast(title: error.localizedDescription))
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
		cardsService?.delete(cashback: cashback, from: card)
		toastService?.show(Toast(title: "Кэшбэк удален"))
	}
	
	private func deleteTransactions(from card: Card) {
		incomeService?.deleteIncomes(from: card)
		toastService?.show(Toast(title: "Транзакции успешно удалены"))
	}
	
	private func archive(card: Card, shouldDeleteTransactions: Bool = false) {
		if shouldDeleteTransactions {
			deleteTransactions(from: card)
		}
		cardsService?.archive(card: card)
		currentCardId = nil
		toastService?.show(Toast(title: "Карта удалена"))
		dismiss()
	}
	
	private func refreshWidget() {
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.favouriteCardsWidgetKind)
	}
	
	private func setupChart() {
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
			cardsService?.add(cashback: cashback, to: card)
		}
		toastService?.show(Toast(title: "Кэшбэки считаны!"))
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

#if DEBUG
private let bannerId = "demo-banner-yandex"
#else
private let bannerId = "R-M-12709149-2"
#endif
