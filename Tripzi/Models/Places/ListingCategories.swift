//
//  ListingCategories.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 26.07.24.
//

import UIKit

struct ListingCategories {
    static let all: [SearchCategory] = [
        SearchCategory(name: "Hotel", icon: UIImage(named: "hotel") ?? UIImage(named: "pic")!),
        SearchCategory(name: "Food", icon: UIImage(named: "burger") ?? UIImage(named: "pic")!),
        SearchCategory(name: "Stores", icon: UIImage(named: "store") ?? UIImage(named: "pic")!),
        SearchCategory(name: "Bar", icon: UIImage(named: "vodka") ?? UIImage(named: "pic")!),
        SearchCategory(name: "Coffee", icon: UIImage(named: "cup") ?? UIImage(named: "pic")!),
        SearchCategory(name: "Museums", icon: UIImage(named: "museum") ?? UIImage(named: "pic")!),
        SearchCategory(name: "Night Clubs", icon: UIImage(named: "fire") ?? UIImage(named: "pic")!),
        SearchCategory(name: "Music", icon: UIImage(named: "music") ?? UIImage(named: "pic")!)
    ]
}
