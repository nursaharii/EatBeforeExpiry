//
//  HomePageCoordinator.swift
//  EatBeforeExpiry
//
//  Created by Nurşah Ari on 27.02.2024.
//

import Foundation
import UIKit

class HomePageCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
            self.navigationController = navigationController
        }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ViewController") as! HomePageViewController
        vc.modalPresentationStyle = .fullScreen
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToAddItemVC(_ selectedItem: Product?,_ completion: @escaping () -> Void) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddItemVC") as! AddItemVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.selectedItem = selectedItem
        navigationController.present(vc, animated: true) {
            vc.addItemListener = {
                completion()
            }
        }
    }
    
    func goToNotificationVC(_ aboutToExpireItems: [Product], _ expiryItems: [Product]) {
        let nofiticationCoordinator = NotificationCoordinator(navigationController: navigationController, aboutToExpireItems: aboutToExpireItems, expiryItems: expiryItems)
        childCoordinators.append(nofiticationCoordinator)
        nofiticationCoordinator.start()
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
}
