//
//  CashbackView.swift
//  CashbackManager
//
//  Created by Alexander on 19.06.2024.
//

import AppIntents
import CategoryService
import Domain
import DesignSystem
import PhotosUI
import SearchService
import Shared
import SwiftData
import SwiftUI
import Vision
import WidgetKit

public struct CardDetailView: View {
	private let card: Card
	private let cardCashbackIntent: any AppIntent
	private let onAddCashbackTap: () -> Void
	
	@AppStorage("CurrentCardID", store: .appGroup) private var currentCardId: String?
	
	@State private var imageItem: PhotosPickerItem?

	@Environment(\.modelContext) private var context
	@Environment(\.searchService) private var searchService
 	@Environment(\.categoryService) private var categoryService

	public init(card: Card, cardCashbackIntent: any AppIntent, onAddCashbackTap: @escaping () -> Void) {
		self.card = card
		self.cardCashbackIntent = cardCashbackIntent
		self.onAddCashbackTap = onAddCashbackTap
	}
	
	public var body: some View {
		contentView
			.background(Color.cmScreenBackground)
			.navigationTitle(card.name)
			.toolbar {
				ToolbarItem(placement: .bottomBar) {
					addCashbackButton
				}
			}
			.onAppear {
				currentCardId = card.id.uuidString
				WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
			}
	}
	
	@ViewBuilder
	private var contentView: some View {
		if card.cashback.isEmpty {
			ContentUnavailableView("Нет сохраненных кэшбэков", systemImage: "rublesign.circle")
		} else {
			List {
				Section {
					IntentTipView(intent: cardCashbackIntent, text: "Чтобы быстро проверить кэшбэки на карте")
				}
				.listSectionSpacing(8)
				.listRowBackground(Color.clear)
				.listRowInsets(EdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
				
				ForEach(card.cashback) { cashback in
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
				
				Section {
					PhotosPicker(selection: $imageItem, matching: .screenshots) {
						Text("Считать кэшбеки со скриншота")
					}
					.onChange(of: imageItem) {
						detectCashbackFromImage()
					}
				}
			}
		}
	}
	
	private var addCashbackButton: some View {
		Button("Добавить кэшбэк") {
			onAddCashbackTap()
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
		delete(cashback: card.cashback[index])
	}
	
	private func delete(cashback: Cashback) {
		searchService?.deindex(cashback: cashback)
		card.cashback.removeAll(where: { $0.id == cashback.id })
		context.delete(cashback)
		searchService?.index(card: card)
	}
	
	private func detectCashbackFromImage() {
		Task {
			if let data = try? await imageItem?.loadTransferable(type: Data.self),
			   let image = UIImage(data: data) {
				
				CashbackDetector().recogniseCashbackCategories(from: image) { result in
					if result.isEmpty {
						/// handle case with no categories found
					} else {
						DispatchQueue.main.async {
							for item in result {
								guard let category = categoryService?.getCategory(by: item.0) else {
									continue
								}
								
								let cashback = Cashback(category: category, percent: item.1)
								guard !card.cashback.contains(cashback) else {
									continue
								}
								
								card.cashback.append(cashback)
							}
						}
					}
				}
			} else {
				print("Failed to load image from gallery")
			}
		}
	}
}

final class CashbackDetector {
	func recogniseCashbackCategories(from image: UIImage, completion: @escaping ([(String, Double)]) -> Void) {
		
		guard let cgImage = image.cgImage else {
			return
		}
		
		let reuqestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
		let request = VNRecognizeTextRequest { (req, error ) in
			guard let observations = req.results as? [VNRecognizedTextObservation] else {
				print("nothing found")
				return
			}
			
			var detectedTexts: [(String, CGRect)] = []
			
			for observation in observations {
				guard let topCandidate = observation.topCandidates(1).first else { continue }
				detectedTexts.append( (topCandidate.string, observation.boundingBox) )
			}
			
			let categories = self.processDecetectedTexts(detectedTexts, in: image)
			
			completion(categories)
		}
		
		request.recognitionLevel = .accurate
		request.usesLanguageCorrection = true
		DispatchQueue.global(qos: .userInitiated).async {
			do {
				try reuqestHandler.perform([request])
			} catch {
				print("recognition handler error \(error.localizedDescription)")
			}
		}
	}
	
	private func processDecetectedTexts(_ texts: [(String, CGRect)], in image: UIImage) -> [(String, Double)] {
		
		var detectedCashback: [(String, Double)] = []
		
		for (text, _) in texts {
			if let percentRange = text.range(of: #"\d+[.,]?\d*%"#, options: .regularExpression) {
				let percentage = String(text[percentRange])
				let lines = text.components(separatedBy: "\n")
				let name = lines[0]
					.replacingOccurrences(of: percentage, with: "")
					.trimmingCharacters(in: .whitespaces)
				
				let percent = (Double(text[percentRange].replacingOccurrences(of: "%", with: "")) ?? .zero) / 100
				detectedCashback.append((name, percent))
			}
		}
		
		return detectedCashback
	}
}
