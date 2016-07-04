//
//  HomeViewController.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit
import Segmentio

class HomeViewController: UIViewController {
    
    private var currentStyle = SegmentioStyle.OnlyImage
    private var containerViewController: EmbedContainerViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == String(EmbedContainerViewController.self) {
            containerViewController = segue.destinationViewController as? EmbedContainerViewController
            containerViewController?.style = currentStyle
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func showMenu(sender: UIBarButtonItem) {
        SideMenuViewController.create().showSideMenu(
            viewController: self,
            currentStyle: currentStyle,
            sideMenuDidHide: { [weak self] style in
                self?.dismissViewControllerAnimated(
                    false,
                    completion: {
                        if self?.currentStyle != style {
                            self?.currentStyle = style
                            self?.containerViewController?.swapViewControllers(style)
                        }
                    }
                )
            }
        )
    }
    
}