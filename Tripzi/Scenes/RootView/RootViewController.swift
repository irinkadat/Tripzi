//
//  RootViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 28.06.24.
//

import UIKit

final class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        view.backgroundColor = UIColor(named: "UniBackground")
    }
    
    func setUpTabBar() {
        let tabBarController = UITabBarController()
        
        let homeVC = HomeViewController()
        let homeNavVC = UINavigationController(rootViewController: homeVC)
        
        let flightsVC = FlightsViewController()
        let flightsNavVC = UINavigationController(rootViewController: flightsVC)
        
        let favoritesVC = FavoritesViewController()
        let favoritesNavVC = UINavigationController(rootViewController: favoritesVC)
        
        let profileVC = ProfileVC()
        let profileNavVC = UINavigationController(rootViewController: profileVC)
        
        tabBarController.viewControllers = [
            homeNavVC,
            flightsNavVC,
            favoritesNavVC,
            profileNavVC
        ]
        
        homeNavVC.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        flightsNavVC.tabBarItem = UITabBarItem(title: "Flights", image: UIImage(systemName: "airplane"), tag: 1)
        favoritesNavVC.tabBarItem = UITabBarItem(title: "Wishlists", image: UIImage(systemName: "heart"), tag: 2)
        profileNavVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(named: "UniBackground")
        
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .greenPrimary
               tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.greenPrimary]
        
        tabBarController.tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        
        
        tabBarController.tabBar.barTintColor = UIColor(red: 58/255, green: 137/255, blue: 255/255, alpha: 1.0)
        tabBarController.tabBar.tintColor = UIColor(named: "buttonColor")
        
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
    }
}

#Preview {
    RootViewController()
}
