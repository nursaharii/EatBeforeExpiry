//
//  HomePageCoordinator.swift
//  EatBeforeExpiry
//
//  Created by Nurşah Ari on 27.02.2024.
//

import Foundation
import UIKit

class HomePageCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ViewController") as! HomePageViewController
        vc.modalPresentationStyle = .fullScreen
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func goToAddItemVC(_ selectedItem: Product?,_ completion: @escaping () -> Void) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddItemVC") as! AddItemVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.selectedItem = selectedItem
        navigationController?.present(vc, animated: true) {
            vc.addItemListener = {
                completion()
            }
        }
    }
    
    func goToNotificationVC(_ aboutToExpireItems: [Product], _ expiryItems: [Product]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationViewController
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        viewController.aboutToExpireItems = aboutToExpireItems
        viewController.expiryItems = expiryItems
        navigationController?.present(viewController, animated: true)
    }
    
    func goToRecipeVC(_ items: [Product], _ vcTitle: String, _ category: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RecipeVC") as! RecipeViewController
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .coverVertical
        viewController.items = items
        viewController.recipeTitle = vcTitle
        viewController.category = category
        navigationController?.present(viewController, animated: true)
    }
}
