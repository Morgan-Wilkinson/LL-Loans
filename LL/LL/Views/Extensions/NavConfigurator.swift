//
//  NavConfigurator.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/16/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

/*
 .background(NavigationConfigurator { nc in
     nc.navigationBar.barTintColor = UIColor(named: "Dashboard")
     nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
     nc.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
 })
 
 
 
 
 
 .navigationViewStyle(StackNavigationViewStyle())
 */
