//
//  ExtNC.swift
//  ZenThea
//
//  Created by felix on 28/12/2024.
//
// mettre des settings correct par défaut

import UIKit

extension UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navBarAppearance.buttonAppearance = buttonAppearance
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navBarAppearance.backButtonAppearance = backButtonAppearance
        self.navigationBar.standardAppearance = navBarAppearance
        self.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.navigationBar.compactAppearance = navBarAppearance
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.tintColor = .white
        self.navigationBar.isTranslucent = true
        self.navigationBar.barStyle = .black
    }

    
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//        let navBarAppearance = UINavigationBarAppearance()
//        navBarAppearance.configureWithTransparentBackground()
//        navBarAppearance.titleTextAttributes = [
//            .foregroundColor: UIColor.white,
//            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
//        ]
//        navBarAppearance.largeTitleTextAttributes = [
//            .foregroundColor: UIColor.white,
//            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
//        ]
//        self.navigationBar.standardAppearance = navBarAppearance
//        self.navigationBar.scrollEdgeAppearance = navBarAppearance
//        self.navigationBar.prefersLargeTitles = true
//        self.navigationBar.tintColor = .white
//    }
}
