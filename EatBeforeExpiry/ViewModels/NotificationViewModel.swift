//
//  NotificationViewModel.swift
//  EatBeforeExpiry
//
//  Created by Nurşah Ari on 27.02.2024.
//

import Foundation
import Combine

class NotificationViewModel {
    var expiryItems = [Product]()
    var aboutToExpireItems = [Product]()
    @Published var selectedTabItems = [Product]()
    
    var selectedSegmentIndex = 0 {
        didSet {
            switch selectedSegmentIndex {
            case 0:
                selectedTabItems = aboutToExpireItems
            case 1:
                selectedTabItems = expiryItems
            default:
                break
            }
        }
    }
    
    func selectSegment(index: Int) {
        selectedSegmentIndex = index
    }
}
