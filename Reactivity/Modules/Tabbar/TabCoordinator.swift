//
//  TabCoordinator.swift
//  Reactivity
//
//  Created by Данила Бондаренко on 05.05.2024.
//

import UIKit

protocol TabCoordinatorDelegate: AnyObject {
    func showAddVideo()
}

final class TabCoordinator: Coordinator {
    func start() {
        let tabView = TabbarViewController()
        tabView.coordinator = self
        navigationController?.pushViewController(tabView, animated: false)
    }
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}

extension TabCoordinator: TabCoordinatorDelegate {
    func showAddVideo() {
        let addVideoView = AddVideoViewController()
        addVideoView.modalPresentationStyle = .fullScreen
        navigationController?.present(addVideoView, animated: true)
    }
}
