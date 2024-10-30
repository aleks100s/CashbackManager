//
//  TextDetectionService.swift
//  
//
//  Created by Alexander on 19.09.2024.
//

import Vision
import UIKit

public struct TextDetectionService {
	public init() {}
	
	public func recogniseCashbackCategories(from image: UIImage) async -> [(String, Double)] {
		await withCheckedContinuation { continuation in
			guard let cgImage = image.cgImage else {
				continuation.resume(returning: [])
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
				
				continuation.resume(returning: categories)
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
	}
	
	private func processDecetectedTexts(_ texts: [(String, CGRect)], in image: UIImage) -> [(String, Double)] {
		
		var detectedCashback: [(String, Double)] = []
		
		for (text, _) in texts {
			if let percentRange = text.range(of: #"\d+[.,]?\d*%"#, options: .regularExpression) {
				let percentage = String(text[percentRange])
				let lines = text.components(separatedBy: "\n")
				let name = lines[0]
					.replacingOccurrences(of: percentage, with: "")
					.replacingOccurrences(of: "[^a-zA-Zа-яА-ЯёЁ\\s]", with: "", options: .regularExpression)
					.trimmingCharacters(in: .whitespaces)

				let percent = (Double(percentage.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: ",", with: ".")) ?? .zero) / 100
				detectedCashback.append((name, percent))
			}
		}
		
		return detectedCashback
	}
}
