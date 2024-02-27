//
//  Singleton.swift
//  EatBeforeExpiry
//
//  Created by Nurşah Ari on 27.02.2024.
//

import Foundation

final class Singleton {
    
    static let sharedInstance = Singleton()
    
    var apiKey: String = ""
    
    private init() {
        
    }
}
