//
//  FirebaseManager.swift
//  EatBeforeExpiry
//
//  Created by Nurşah Ari on 27.02.2024.
//

import Foundation
import FirebaseRemoteConfig

class FirebaseManager {
    static func getRemoteConfigValue(forKey key: String, defaultValue: String? = nil, completion: @escaping (String?) -> Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        let defaultValues: [String: NSObject] = [
            key: defaultValue as NSObject? ?? "" as NSObject
        ]
        remoteConfig.setDefaults(defaultValues)
        
        remoteConfig.fetch { status, error in
            if status == .success {
                remoteConfig.activate { _, _ in
                    let value = remoteConfig[key].stringValue ?? defaultValue
                    completion(value)
                }
            } else {
                print("\(error?.localizedDescription ?? "Unknown error")")
                completion(defaultValue)
            }
        }
    }
}

