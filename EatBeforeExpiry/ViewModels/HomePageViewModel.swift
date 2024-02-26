//
//  HomePageViewModel.swift
//  EatBeforeExpiry
//
//  Created by Nurşah Ari on 26.02.2024.
//

import Foundation
import Combine
import UIKit

class HomePageViewModel {
    var items = [Product]()
    @Published var filteredItems = [Product]()
    @Published var searchedItems = [Product]()
    var aboutToExpireItems = [Product]()
    var expiryItems = [Product]()
    var descSorted: Bool = false
    var searchTerm: String = "" {
        didSet {
            search(searchTerm)
        }
    }
    
    func getItems() {
        items.removeAll()
        expiryItems.removeAll()
        aboutToExpireItems.removeAll()
        filteredItems.removeAll()
        if let items = UserDefaultsManager().getDataForObject(type: [Product].self, forKey: .addItem) {
            self.items = items.sorted(by: { $0.expiryDate < $1.expiryDate})
            for item in items {
                if let nextDate = Calendar.current.date(byAdding: .day, value: 5, to: Date()) {
                    if item.expiryDate <= nextDate, item.expiryDate > Date() {
                        aboutToExpireItems.append(item)
                    } else if item.expiryDate <= Date() {
                        expiryItems.append(item)
                    }
                }
            }
        }
        filteredItems = items
    }
    
    func resetAll() {
        searchedItems.removeAll()
        
        if !descSorted {
            filteredItems = items.sorted(by: { $0.expiryDate < $1.expiryDate})
        } else {
            filteredItems = items.sorted(by: { $0.expiryDate > $1.expiryDate})
        }
    }
    
    func orderByDescending() -> Bool {
        if descSorted {
            filteredItems = filteredItems.sorted(by: { $0.expiryDate > $1.expiryDate})
        } else {
            filteredItems = filteredItems.sorted(by: { $0.expiryDate < $1.expiryDate})
        }
        descSorted = !descSorted
        return !descSorted
    }
    
    func search(_ term: String) {
        searchedItems = filteredItems.filter({ item in
            if let _ = item.productName.prefix(searchTerm.count).lowercased().range(of: searchTerm,options: .caseInsensitive) {
                
                return true
            }
            return false
        })
    }
    
    func tableViewCellForRowItemAt(_ indexPath: IndexPath) {
        
    }
    
    func tableViewDelete(_ indexPath: IndexPath) {
        var tempItems = filteredItems
        if searchedItems.count > 0 {
            let item = searchedItems
            if let removeIndex = tempItems.firstIndex(where: {$0.id == item[indexPath.row].id }) {
                tempItems.remove(at: removeIndex)
            }
            if let removeIndex = self.items.firstIndex(where: {$0.id == item[indexPath.row].id }) {
                self.items.remove(at: removeIndex)
                UserDefaultsManager().setDataForObject(value: items, key: .addItem)
            }
            searchedItems.remove(at: indexPath.row)
            search(searchTerm)
        } else {
            if let removeIndex = self.items.firstIndex(where: {$0.id == tempItems[indexPath.row].id }) {
                self.items.remove(at: removeIndex)
                UserDefaultsManager().setDataForObject(value: items, key: .addItem)
            }
            tempItems.remove(at: indexPath.row)
        }
        filteredItems = tempItems
    }
    
    func filter(_ category: String) -> [Product]? {
        filteredItems = items.filter({return $0.category == category})
        return filteredItems
    }
    
    
}
