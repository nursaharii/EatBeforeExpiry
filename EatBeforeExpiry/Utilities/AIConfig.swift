//
//  AIConfig.swift
//  EatBeforeExpiry
//
//  Created by Nurşah Ari on 27.02.2024.
//

import Foundation

import Foundation
import OpenAI
import FirebaseRemoteConfig

struct AIConfig {
    static func setApiKey(){
        FirebaseManager.getRemoteConfigValue(forKey: "api_key") { value in
            if let value = value {
                Singleton.sharedInstance.apiKey = value
            }
        }
    }
    
    static func chatQuery(_ strItems: String) -> ChatQuery{
        return ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .user, content: "\(strItems) içeren yemek tarifi")])
    }
}
