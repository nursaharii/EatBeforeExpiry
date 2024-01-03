//
//  UserDefaultsMAnager.swift
//  EatBeforeExpiry
//
//  Created by Nurşah ARİ on 18.12.2023.
//

import Foundation
enum UserDefaultKeys: String, CaseIterable{
    case addItem
    case recipe
}

class UserDefaultsManager {
    
    let jsonEncoder = JSONEncoder()
    let jsonDecoder = JSONDecoder()
    let defaults = UserDefaults.standard
    
    func setData<T>(value: T, key: UserDefaultKeys) {
        self.defaults.set(value, forKey: key.rawValue)
    }
    func getData<T>(type: T.Type, forKey: UserDefaultKeys) -> T? {
        let value = self.defaults.object(forKey: forKey.rawValue) as? T
        return value
    }
    
    func setDataForObject<T: Codable>(value: T, key: UserDefaultKeys) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(value)
            self.defaults.set(encodedData, forKey: key.rawValue)
        } catch {
            print("Encoding error: \(error.localizedDescription)")
        }
    }

    func getDataForObject<T: Codable>(type: T.Type, forKey: UserDefaultKeys) -> T? {
        if let data = self.defaults.object(forKey: forKey.rawValue) as? Data {
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(type, from: data)
                return decodedData
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }
    
    func removeData(key: UserDefaultKeys) {
        self.defaults.removeObject(forKey: key.rawValue)
    }
    
}
