//
//  AppearanceConfigurator.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit

class AppearanceConfigurator {
    
    class func configureNavigationBar() {
        UIApplication.shared.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().barTintColor = ColorPalette.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = ColorPalette.black
        let attributes = [
            NSAttributedStringKey.font : UIFont.exampleAvenirMedium(ofSize: 17),
            NSAttributedStringKey.foregroundColor : ColorPalette.black
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
}
