//
//  CustomerTabBar.swift
//  tabviewcontroller
//
//  Created by Mark Hoath on 3/10/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBarController, UITabBarControllerDelegate {
    let firstVC = CollectionViewListagemDeNoticias(collectionViewLayout: UICollectionViewFlowLayout())
    let secondVC = SecondViewController()

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        
        firstVC.tabBarItem.title = "Notícias"
        secondVC.tabBarItem.title = "Ajustes"
        
        
        firstVC.tabBarItem.image = UIImage(named: "noticias")
        secondVC.tabBarItem.image = UIImage(named: "ajustes")
        
        viewControllers = [firstVC, secondVC]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
