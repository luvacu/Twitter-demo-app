//
//  Coordinator.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 16/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import UIKit

final class Coordinator {
    
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func setRootViewController(withUserID userID: String?) {
        let rootViewController: UIViewController
        if let userID = userID {
            let repository = TwitterRepository(userID: userID)
            rootViewController = tabBarController(repository: repository)
        } else {
            rootViewController = loginViewController
        }
        window?.rootViewController = rootViewController
    }
    
    private var loginViewController: UIViewController {
        let viewModel = LoginViewModel()
        viewModel.completionHandler = { [weak self] userID in
            self?.setRootViewController(withUserID: userID)
        }
        let viewController = R.storyboard.main.loginViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    private func tabBarController(repository: TwitterRepository) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: timelineViewController(repository: repository)),
            UINavigationController(rootViewController: favouritesViewController(repository: repository)),
        ]
        return tabBarController
    }
    
    private func timelineViewController(repository: TwitterRepository) -> UIViewController {
        let viewModel = HomeTimelineViewModel(repository: repository)
        viewModel.showUserProfile = { [weak self] userID in
            guard let `self` = self else {
                return
            }
            let profileViewController = self.profileViewController(repository: repository, userID: userID)
            self.push(profileViewController)
        }
        
        let viewController = R.storyboard.main.timelineViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    private func profileViewController(repository: TwitterRepository, userID: String) -> UIViewController {
        let viewModel = ProfileViewModel(repository: repository, userID: userID)
        
        let viewController = R.storyboard.main.profileViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    private func favouritesViewController(repository: TwitterRepository) -> UIViewController {
        let viewModel = FavouritesViewModel(repository: repository)
        viewModel.showUserProfile = { [weak self] userID in
            guard let `self` = self else {
                return
            }
            let profileViewController = self.profileViewController(repository: repository, userID: userID)
            self.push(profileViewController)
        }
        
        let viewController = R.storyboard.main.timelineViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    private func push(_ viewController: UIViewController) {
        guard let tabBarController = window?.rootViewController as? UITabBarController,
            let navigationController = tabBarController.selectedViewController as? UINavigationController else {
                return
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
