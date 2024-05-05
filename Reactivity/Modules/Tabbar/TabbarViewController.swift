//
//  TabbarViewController.swift
//  Reactivity
//
//  Created by Данила Бондаренко on 29.04.2024.
//

import UIKit

final class TabbarViewController: UITabBarController {
    private let feedView = FeedVideoViewBuilder.build()
    private let profileView = ProfileViewController()
    private let messangerView = MessangerViewController()
    private let friendsView = FriendsViewController()
    
    var coordinator: TabCoordinatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        tabBar.tintColor = .white
        tabBar.barTintColor = .black
    }
    
    private func setupViewControllers() {
        viewControllers = [
            makeViewController(for: feedView, systemImage: "house", title: "Главная"),
            makeViewController(for: friendsView, systemImage: "person.2", title: "Друзья"),
            makeViewController(for: messangerView, systemImage: "message", title: "Сообщения"),
            makeViewController(for: profileView, systemImage: "person", title: "Профиль")
        ]
        
        setupMiddleButton()
    }
    
    private func makeViewController(
        for viewController: UIViewController,
        systemImage: String,
        title: String
    ) -> UIViewController {
        viewController.tabBarItem = UITabBarItem(
            title: title, image: UIImage(systemName: systemImage),
            selectedImage: UIImage(systemName: "\(systemImage).fill")
        )
        
        return viewController
    }
    
    func setupMiddleButton() {
        var config = UIButton.Configuration.bordered()
        config.baseBackgroundColor = .gray
        config.title = "+"
        config.buttonSize = .large
        config.titlePadding = 50
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24)
        config.cornerStyle = .large
        
        let centerButton = UIButton(configuration: config)
        centerButton.addTarget(self, action: #selector(showAddVideo), for: .touchUpInside)
        self.tabBar.addSubview(centerButton)
        centerButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        self.view.layoutIfNeeded()
    }
    
    @objc
    private func showAddVideo() {
        coordinator?.showAddVideo()
    }
}

@available(iOS 17, *)
#Preview("Tabbar", traits: .portrait, body: {
    TabbarViewController()
})
