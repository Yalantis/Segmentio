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
    
    fileprivate var currentStyle = SegmentioStyle.onlyImage
    fileprivate var containerViewController: EmbedContainerViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: EmbedContainerViewController.self) {
            containerViewController = segue.destination as? EmbedContainerViewController
            containerViewController?.style = currentStyle
        }
    }
    
    // MARK: - Actions
    
    @IBAction fileprivate func showMenu(_ sender: UIBarButtonItem) {
        SideMenuViewController.create().showSideMenu(
            viewController: self,
            currentStyle: currentStyle,
            sideMenuDidHide: { [weak self] style in
                self?.dismiss(
                    animated: false,
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
