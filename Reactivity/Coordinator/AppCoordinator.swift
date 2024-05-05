//
//  AppCoordinator.swift
//  Reactivity
//
//  Created by Данила Бондаренко on 05.05.2024.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
    var navigationController: UINavigationController? { get set }
}

final class AppCoordinator: Coordinator {
    func start() {
        let tabCoordinator = TabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
    }
    
    var navigationController: UINavigationController?
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
}
