//
//  Categories.swift
//  EatBeforeExpiry
//
//  Created by Nurşah Ari on 27.02.2024.
//

import Foundation
import UIKit

enum Categories: String, CaseIterable {
    case all = "Tümü"
    case fresh = "Taze Ürünler"
    case milk = "Süt Ürünleri"
    case dryFood = "Kuru Gıda ve Bakliyatlar"
    case fastFood = "Konserve ve Hazır Gıdalar"
    case drink = "İçecekler"
    case dessert = "Atıştırmalıklar ve Tatlılar"
    case sauce = "Baharatlar ve Soslar"
    case bread = "Ekmek ve Fırın Ürünleri"
    case other = "Diğer"
    
    var color: UIColor {
        switch self {
        case .all:
            return .black
        case .fresh:
            return .greenCategory
        case .milk:
            return .blueCategory
        case .dryFood:
            return .brownCategory
        case .fastFood:
            return .orangeCategory
        case .drink:
            return .redCategory
        case .dessert:
            return .purpleCategory
        case .sauce:
            return .yellowCategory
        case .bread:
            return .grayCategory
        case .other:
            return .pinkCategory
        }
    }
    var image: String {
        switch self {
        case .all:
            return "all"
        case .fresh:
            return "fresh-category"
        case .milk:
            return "milk-category"
        case .dryFood:
            return "dryFood-category"
        case .fastFood:
            return "fastFood-category"
        case .drink:
            return "drink-category"
        case .dessert:
            return "dessert-category"
        case .sauce:
            return  "sauce-category"
        case .bread:
            return  "bread-category"
        case .other:
            return  "others-category"
        }
    }
}
