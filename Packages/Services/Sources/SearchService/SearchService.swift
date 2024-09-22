//
//  SearchService.swift
//  
//
//  Created by Alexander on 29.07.2024.
//

import CoreSpotlight
import Domain
import Shared

public struct SearchService: @unchecked Sendable {
	public init() {}
	
	public func index(card: Card) {
		let attributeSet = createAttributes(title: card.name, description: card.cashbackDescription)
		index(id: card.id, attributes: attributeSet)
		for cashback in card.cashback {
			index(cashback: cashback, cardName: card.name)
		}
	}
	
	public func index(place: Place) {
		let attributeSet = createAttributes(title: place.name, description: place.category.name)
		index(id: place.id, attributes: attributeSet)
	}
	
	public func deindex(card: Card) {
		for cashback in card.cashback {
			deindex(cashback: cashback)
		}
		deindex(id: card.id)
	}
	
	public func deindex(cashback: Cashback) {
		deindex(id: cashback.id)
	}
	
	public func deindex(place: Place) {
		deindex(id: place.id)
	}
	
	private func index(cashback: Cashback, cardName: String) {
		let synonyms = cashback.category.synonyms?.split(separator: ",") ?? []
		let attributeSet = createAttributes(title: cashback.description, description: cardName, keywords: synonyms.map { String($0) })
		index(id: cashback.id, attributes: attributeSet)
	}
	
	private func createAttributes(
		title: String,
		description: String,
		keywords: [String]? = nil
	) -> CSSearchableItemAttributeSet {
		let attributeSet = CSSearchableItemAttributeSet(itemContentType: UTType.text.identifier)
		attributeSet.title = title
		attributeSet.contentDescription = description
		attributeSet.keywords = keywords
		return attributeSet
	}
	
	private func index(id: UUID, attributes: CSSearchableItemAttributeSet) {
		let item = CSSearchableItem(uniqueIdentifier: id.uuidString, domainIdentifier: Constants.appIdentifier, attributeSet: attributes)
		CSSearchableIndex.default().indexSearchableItems([item]) { error in
			if let error = error {
				print("Indexing error: \(error.localizedDescription)")
			} else {
				print("Search item successfully indexed!")
			}
		}
	}
	
	private func deindex(id: UUID) {
		CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id.uuidString]) { error in
			if let error = error {
				print("Deindexing error: \(error.localizedDescription)")
			} else {
				print("Search item successfully removed!")
			}
		}
	}
}
