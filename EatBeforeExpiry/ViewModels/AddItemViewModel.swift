//
//  AddItemViewModel.swift
//  EatBeforeExpiry
//
//  Created by Nurşah Ari on 26.02.2024.
//

import Foundation

class AddItemViewModel {
    
    var newItem = Product()
    var selectedItem: Product?
    var isExpiryDateSet: Bool = false
    
    func setCategory(_ category: Categories) {
        newItem.category = category.rawValue
        if var selectedItem = selectedItem {
            selectedItem.category = category.rawValue
            self.selectedItem = selectedItem
        }
    }
    
    func setExpiryDate(_ date: Date) {
        newItem.expiryDate = date
        if var selectedItem = selectedItem {
            selectedItem.expiryDate = date
            self.selectedItem = selectedItem
        }
        isExpiryDateSet = true
    }
    
    func addItem() {
        if var items = UserDefaultsManager().getDataForObject(type: [Product].self, forKey: .addItem) {
            if var selectedItem = selectedItem {
                if let removeIndex = items.firstIndex(where: {$0.id == selectedItem.id }) {
                    items.remove(at: removeIndex)
                    selectedItem.productName = newItem.productName
                    items.append(selectedItem)
                    UserDefaultsManager().setDataForObject(value: items, key: .addItem)
                }
            } else {
                if let maxId = items.max(by: {$0.id<$1.id})?.id {
                    newItem.id = maxId + 1
                }
                items.append(newItem)
                UserDefaultsManager().setDataForObject(value: items, key: .addItem)
            }
        } else {
            UserDefaultsManager().setDataForObject(value: [newItem], key: .addItem)
        }
    }
    
    func validateFields() -> Bool {
        return !(newItem.category.isEmpty || newItem.productName.isEmpty || !isExpiryDateSet)
    }
    
}
