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
import PhotosUI
import SearchService
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
	
	@Environment(\.modelContext) private var context
	@Environment(\.cardsService) private var cardsService
	@Environment(\.searchService) private var searchService
 	@Environment(\.categoryService) private var categoryService
	@Environment(\.textDetectionService) private var textDetectionService

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
			.navigationBarTitleDisplayMode(isEditing ? .inline : .large)
			.toolbar {
				if !isEditing {
					ToolbarItem(placement: .bottomBar) {
						addCashbackButton
					}
				}
				
				if !card.isEmpty {
					ToolbarItem(placement: .topBarTrailing) {
						editButton
					}
				}
			}
			.onAppear {
				currentCardId = card.id.uuidString
				WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
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
	}
	
	@ViewBuilder
	private var contentView: some View {
		if card.cashback.isEmpty {
			List {
				Section {
					ContentUnavailableView("Нет сохраненных кэшбэков", systemImage: "rublesign.circle")
				}
				
				detectCashbackSectionButton
			}
		} else {
			List {
				if !isEditing, areSiriTipsVisible {
					IntentTipView(intent: cardCashbackIntent, text: "Чтобы быстро проверить кэшбэки на карте")
				}
				
				if isEditing {
					Section("Редактировать название и цвет") {
						TextField("Название карты", text: $cardName)
							.textFieldStyle(.plain)
						
						ColorPicker("Цвет карты", selection: $color)
					}
				}
				
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
				
				if isEditing {
					Section {
						Button("Удалить все кэшбэки с карты", role: .destructive) {
							for cashback in card.cashback {
								delete(cashback: cashback)
							}
							isEditing.toggle()
						}
					} footer: {
						Text("Данное действие нельзя отменить")
					}
				} else {
					detectCashbackSectionButton
				}
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
		}
		.disabled(cardName.isEmpty)
	}
	
	private var detectCashbackSectionButton: some View {
		DetectCashbackSectionButton(imageItem: $imageItem, animateGradient: $animateGradient) {
			Task {
				await detectCashbackFromImage()
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
		searchService?.deindex(cashback: cashback)
		card.cashback.removeAll(where: { $0.id == cashback.id })
		context.delete(cashback)
		searchService?.index(card: card)
	}
}

private extension CardDetailView {
	func detectCashbackFromImage() async {
		defer {
			imageItem = nil
		}
		
		guard let data = try? await imageItem?.loadTransferable(type: Data.self), let image = UIImage(data: data) else {
			print("Failed to load image from gallery")
			return
		}
		
		let result = await textDetectionService?.recogniseCashbackCategories(from: image) ?? []
		guard !result.isEmpty else { return }
		
		apply(result: result)
	}
	
	@MainActor
	func apply(result: [(String, Double)]) {
		for item in result {
			guard let category = categoryService?.getCategory(by: item.0), !card.has(category: category) else {
				continue
			}
			
			let cashback = Cashback(category: category, percent: item.1)
			card.cashback.append(cashback)
		}
		searchService?.index(card: card)
		toast = Toast(title: "Кэшбэки считаны!")
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
