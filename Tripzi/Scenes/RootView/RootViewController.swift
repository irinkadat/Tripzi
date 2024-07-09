//
//  RootViewController.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 28.06.24.
//

import UIKit

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        view.backgroundColor = .white
    }
    
    func setUpTabBar() {
        
        let tabBarController = UITabBarController()
        let homeVC = HomeViewController()
        let flightsVC = FlightsViewController()
        let favoritesVC = FavoritesViewController()
        let profileVC = ProfileVC()
        
        
        tabBarController.viewControllers = [
            homeVC,
            flightsVC,
            favoritesVC,
            profileVC
        ]
        
        homeVC.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        flightsVC.tabBarItem = UITabBarItem(title: "Flights", image: UIImage(systemName: "airplane"), tag: 1)
        favoritesVC.tabBarItem = UITabBarItem(title: "Wishlists", image: UIImage(systemName: "heart"), tag: 2)
        profileVC.tabBarItem = UITabBarItem(title: "Population", image: UIImage(systemName: "person"), tag: 3)
        
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
