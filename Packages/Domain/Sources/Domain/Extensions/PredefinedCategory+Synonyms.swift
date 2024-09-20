//
//  File.swift
//  
//
//  Created by Alexander on 19.09.2024.
//

public extension PredefinedCategory {
	var synonyms: [String] {
		switch self {
		case .allPurchases:
			["За все покупки", "На все покупки", "На всё"]
		case .education:
			["Курсы"]
		case .airplainTickets:
			["Авиаперелеты", "Билеты на самолет"]
		case .vipZone:
			[]
		case .carRent:
			["Прокат авто", "Автопрокат"]
		case .railRoadTickets:
			["Билеты на поезда", "Железные дороги", "Железнодорожные билеты"]
		case .tourAgencies:
			["Туризм"]
		case .cruises:
			[]
		case .hotels:
			[]
		case .dutyFreeShops:
			["Duty Free"]
		case .transport:
			["Городской транспорт"]
		case .taxi:
			["Yandex Go", "Яндекс Go"]
		case .carSharing:
			[]
		case .autoServices:
			["Автозапчасти", "Автосервис"]
		case .pharmacies:
			["Аптека", "Фармацея"]
		case .beautyAndSPA:
			["Салоны красоты", "Барбершопы", "Красота"]
		case .cosmeticsAndParfume:
			["Косметика и парфюмерия", "Магазины косметики"]
		case .houseAndRenovation:
			[]
		case .art:
			[]
		case .books:
			["Книжные магазины", "Книжные лавки"]
		case .zooGoods:
			["Зоомагазины", "Товары для животных", "Магазины для животных"]
		case .cinema:
			["Кинотеатры"]
		case .entertainment:
			[]
		case .exhibitionsAndMuseums:
			["Выставки", "Музеи", "Музеи и выставки"]
		case .medicineServices:
			[]
		case .fitness:
			["Спортзалы", "Спортивные залы"]
		case .clinicsAndEsthetics:
			[]
		case .dentist:
			["Стоматология", "Стоматологи"]
		case .music:
			["Магазины музыки"]
		case .supermarkets:
			[]
		case .shops:
			[]
		case .electronicDevices:
			["Магазины бытовой техники", "Магазины электроники"]
		case .restaurants:
			["Кафе и рестораны", "Бары"]
		case .fastfood:
			[]
		case .communicationAndTelecom:
			[]
		case .photoAndVideo:
			[]
		case .souvenirs:
			["Сувенирные магазины"]
		case .flowers:
			["Магазины цветов"]
		case .sportGoods:
			["Магазины спортивных товаров"]
		case .clothesAndShoes:
			["Аксессуары", "Магазины одежды", "Магазины обуви"]
		case .sbp:
			[]
		case .digitalGoods:
			[]
		case .yandex:
			[]
		case .burgerKing:
			["Burger King"]
		}
	}
}
