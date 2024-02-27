//
//  URLConstants.swift
//  EatBeforeExpiry
//
//  Created by Nurşah Ari on 27.02.2024.
//

import Foundation
import OpenAI

struct URLConstants {
    static let apiKey = "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"
    
    static func chatQuery(_ strItems: String) -> ChatQuery{
        return ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .user, content: "\(strItems) içeren yemek tarifi")])
    }
}
