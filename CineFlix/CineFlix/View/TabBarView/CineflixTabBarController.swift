//
//  CineflixTabBarController.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import UIKit
import SwiftUI

class CineflixTabBarController: UITabBarController {
    
    // MARK: - Properties
    static let identifier = "CineflixTabBarController"
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarAppearance()
        setupViewControllers()
    }
    
    // MARK: - Setup Controllers
    private func setupViewControllers() {
        viewControllers = [
            createTabBarItem(rootVC: MediaViewController(),
                             image: UIImage(named: "movieclapper")!,
                             selectedImage: UIImage(named: "movieclapper.fill")!,
                             title: "Media"),
            createTabBarItem(rootVC: SearchViewController(),
                             image: UIImage(systemName: "magnifyingglass")!,
                             selectedImage: UIImage(systemName: "magnifyingglass")!,
                             title: "Search"),
            createTabBarItem(rootVC: FavoritesViewController(),
                             image: UIImage(systemName: "bookmark")!,
                             selectedImage: UIImage(systemName: "bookmark.fill")!,
                             title: "Favorites")
        ]
    }
    
    // MARK: - Create item tabBar
    private func createTabBarItem(rootVC: UIViewController, image: UIImage, selectedImage: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.selectedImage = selectedImage
        return navigationVC
    }
    
    // MARK: - Configure tabBar
    private func configureTabBarAppearance() {
        tabBar.unselectedItemTintColor = UIColor(named: "tabbaricon")
        additionalSafeAreaInsets.bottom = 12
        tabBar.itemPositioning = .centered
        tabBar.layer.shadowColor = UIColor.white.withAlphaComponent(0.65).cgColor
        tabBar.layer.shadowRadius = 40
        tabBar.layer.shadowOpacity = 0.6
        tabBar.tintColor = .systemOrange.withAlphaComponent(0.9)
        tabBar.backgroundColor = UIColor(named: "tabbarColor")
        tabBar.selectionIndicatorImage = UIImage(named: "Selected")
    }
}

//struct ViewControllerProvider: PreviewProvider {
//    static var previews: some View {
//        // ViewController.showPreview
//        CineflixTabBarController().showPreview()
//    }
//}
