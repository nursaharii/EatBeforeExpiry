//
//  NotificationCoordinator.swift
//  EatBeforeExpiry
//
//  Created by Nurşah Ari on 27.02.2024.
//

import Foundation
import UIKit

class NotificationCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var aboutToExpireItems: [Product]
    var expiryItems: [Product]
    
    init(navigationController: UINavigationController, aboutToExpireItems: [Product], expiryItems: [Product]) {
        self.navigationController = navigationController
        self.aboutToExpireItems = aboutToExpireItems
        self.expiryItems = expiryItems
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NotificationVC") as! NotificationViewController
        vc.modalPresentationStyle = .fullScreen
        vc.aboutToExpireItems = aboutToExpireItems
        vc.expiryItems = expiryItems
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
        
    }
    
    func goToRecipeVC(_ items: [Product], _ vcTitle: String, _ category: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RecipeVC") as! RecipeViewController
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .coverVertical
        viewController.items = items
        viewController.recipeTitle = vcTitle
        viewController.category = category
        navigationController.present(viewController, animated: true)
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}

