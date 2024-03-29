//
//  Coordinator.swift
//  EatBeforeExpiry
//
//  Created by Nurşah Ari on 27.02.2024.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

