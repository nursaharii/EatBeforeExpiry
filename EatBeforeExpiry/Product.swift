//
//  Product.swift
//  EatBeforeExpiry
//
//  Created by Nurşah ARİ on 18.12.2023.
//

import Foundation

struct Product: Codable {
    var id = Int()
    var productName = String()
    var category = String()
    var expiryDate = Date()
}
