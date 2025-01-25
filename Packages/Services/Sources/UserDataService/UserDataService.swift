//
//  SettingsModel.swift
//  CashbackManager
//
//  Created by Alexander on 26.10.2024.
//

import CoreTransferable
import Domain
import Foundation
import SearchService
import Shared
import SwiftData

public final class UserDataService {
	private let searchService: SearchService
	
	public init(searchService: SearchService) {
		self.searchService = searchService
	}
	
	public func generateExportFile() async throws -> UserData {
		let context = try getContext()

		let categories: [Domain.Category] = try fetchAll(from: context)
		let categoriesDTO: [UserData.Category] = categories.map { entity in
			UserData.Category(
				id: entity.id,
				name: entity.name,
				emoji: entity.emoji,
				synonyms: entity.synonyms,
				priority: entity.priority,
				isArchived: entity.isArchived
			)
		}
		let places: [Place] = try fetchAll(from: context)
		let placesDTO: [UserData.Place] = places.map { place in
			UserData.Place(
				id: place.id,
				name: place.name,
				category: categoriesDTO.first(where: { $0.id == place.category.id })!,
				isFavorite: place.isFavorite
			)
		}
		let cards: [Card] = try fetchAll(from: context)
		let cardsDTO: [UserData.Card] = cards.map { card in
			UserData.Card(
				id: card.id,
				name: card.name,
				cashback: card.cashback.map { cashback in
					UserData.Cashback(
						id: cashback.id,
						category: categoriesDTO.first(where: { $0.id == cashback.category.id })!,
						percent: cashback.percent
					)
				},
				color: card.color,
				isArchived: card.isArchived,
				isFavorite: card.isFavorite,
				currency: card.currency,
				currencySymbol: card.currencySymbol)
		}
		let payments: [Income] = try fetchAll(from: context)
		let paymentsDTO: [UserData.Income] = payments.map { payment in
			UserData.Income(
				id: payment.id,
				amount: payment.amount,
				date: payment.date,
				source: cardsDTO.first(where: { $0.id == payment.source?.id })
			)
		}
		
		let userData = UserData(
			categories: categoriesDTO,
			cards: cardsDTO,
			places: placesDTO,
			payments: paymentsDTO
		)
		return userData
	}
	
	public func importData(from url: URL) async throws {
		guard url.startAccessingSecurityScopedResource() else {
			throw UserDataError.noPermission
		}
		
		let context = try getContext()
		
		let data = try Data(contentsOf: url)
		let userData = try JSONDecoder().decode(UserData.self, from: data)
		
		try context.transaction {
			try deleteAll(from: context)
			let categories = userData.categories.map { category in
				Domain.Category(
					id: category.id,
					name: category.name,
					emoji: category.emoji,
					synonyms: category.synonyms,
					priority: category.priority,
					isArchived: category.isArchived
				)
			}
			for category in categories {
				context.insert(category)
			}
			let places = userData.places.map { place in
				Domain.Place(
					id: place.id,
					name: place.name,
					category: categories.first(where: { $0.id == place.category.id })!,
					isFavorite: place.isFavorite
				)
			}
			for place in places {
				context.insert(place)
				searchService.index(place: place)
			}
			let cards = userData.cards.map { card in
				Domain.Card(
					id: card.id,
					name: card.name,
					cashback: card.cashback.map { cashback in
						Domain.Cashback(
							id: cashback.id,
							category: categories.first(where: { $0.id == cashback.category.id })!,
							percent: cashback.percent
						)
					},
					color: card.color,
					isArchived: card.isArchived,
					isFavorite: card.isFavorite,
					currency: card.currency,
					currencySymbol: card.currencySymbol
				)
			}
			for card in cards {
				context.insert(card)
				searchService.index(card: card)
			}
			let payments = userData.payments.map { payment in
				Domain.Income(
					id: payment.id,
					amount: payment.amount,
					date: payment.date,
					source: cards.first(where: { $0.id == payment.source?.id })!
				)
			}
			for income in payments {
				context.insert(income)
			}
		}
		
		try context.save()
		url.stopAccessingSecurityScopedResource()
	}
	
	private func getContext() throws -> ModelContext {
		let container = try ModelContainer(for: Domain.Category.self, Place.self, Card.self, Income.self)
		return ModelContext(container)
	}
	
	func deleteAll(from context: ModelContext) throws {
		let payments: [Income] = try fetchAll(from: context)
		for payment in payments {
			context.delete(payment)
		}
		let cards: [Card] = try fetchAll(from: context)
		for card in cards {
			searchService.deindex(card: card)
			context.delete(card)
		}
		let cashback: [Cashback] = try fetchAll(from: context)
		for cashback in cashback {
			context.delete(cashback)
		}
		let places: [Place] = try fetchAll(from: context)
		for place in places {
			searchService.deindex(place: place)
			context.delete(place)
		}
		let categories: [Domain.Category] = try fetchAll(from: context)
		for category in categories {
			context.delete(category)
		}
	}
	
	private func fetchAll<T: PersistentModel>(from context: ModelContext) throws -> [T] {
		try context.fetch(FetchDescriptor<T>())
	}
}
