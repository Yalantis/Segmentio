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
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        UINavigationBar.appearance().barTintColor = ColorPalette.WhiteColor
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().tintColor = ColorPalette.BlackColor
        let attributes = [
            NSFontAttributeName : UIFont.exampleAvenirMediumWithSize(17),
            NSForegroundColorAttributeName : ColorPalette.BlackColor
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
}