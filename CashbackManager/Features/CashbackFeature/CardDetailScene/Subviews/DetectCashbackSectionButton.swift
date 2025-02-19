//
//  DetectCashbackSectionButton.swift
//  CashbackManager
//
//  Created by Alexander on 19.02.2025.
//

import PhotosUI
import SwiftUI

extension CardDetailView {
	struct DetectCashbackSectionButton: View {
		let card: Card
		let onFinish: () -> Void
		
		@State private var imageItem: PhotosPickerItem?
		@State private var animateGradient: Bool = false
		
		@Environment(\.toastService) private var toastService
		@Environment(\.textDetectionService) private var textDetectionService
		@Environment(\.cardsService) private var cardsService
		@Environment(\.categoryService) private var categoryService
				
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
					Task {
						do {
							try await detectCashbackFromImage()
						} catch {
							await MainActor.run {
								toastService?.show(Toast(title: error.localizedDescription))
							}
						}
					}
				}
			} footer: {
				Text("Будут считаны только кэшбэки, чьи категории представлены в приложении и не добалены на эту карту")
					.offset(x: -8)
			}
		}
		
		private func detectCashbackFromImage() async throws {
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
		private func apply(result: [(String, Double)]) {
			for item in result {
				guard let category = categoryService?.getCategory(by: item.0), !card.has(category: category), item.1 > 0 else {
					continue
				}
				
				let cashback = Cashback(category: category, percent: item.1, order: card.cashback.count)
				cardsService?.add(cashback: cashback, to: card)
			}
			toastService?.show(Toast(title: "Кэшбэки считаны!"))
			onFinish()
		}
	}
}
