//
//  EmbedContainerViewController.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit
import Segmentio

private let animateDuration: NSTimeInterval = 0.6

class EmbedContainerViewController: UIViewController {
    
    var style = SegmentioStyle.OnlyImage
    
    private var currentViewController: UIViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentController(controller(style))
    }
    
    // MARK: - Private functions
    
    private func presentController(controller: UIViewController) {
        if let _ = currentViewController {
            removeCurrentViewController()
        }
        
        addChildViewController(controller)
        view.addSubview(controller.view)
        currentViewController = controller
        controller.didMoveToParentViewController(self)
    }
    
    private func controller(style: SegmentioStyle) -> ExampleViewController {
        let controller = ExampleViewController.create()
        controller.segmentioStyle = style
        controller.view.frame = view.bounds
        return controller
    }
    
    private func removeCurrentViewController() {
        currentViewController?.willMoveToParentViewController(nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParentViewController()
    }
    
    private func swapCurrentController(controller: UIViewController) {
        currentViewController?.willMoveToParentViewController(nil)
        addChildViewController(controller)
        view.addSubview(controller.view)
        
        UIView.animateWithDuration(
            animateDuration,
            animations: {
                controller.view.alpha = 1
                self.currentViewController?.view.alpha = 0
            },
            completion: { _ in
                self.currentViewController?.view.removeFromSuperview()
                self.currentViewController?.removeFromParentViewController()
                self.currentViewController = controller
                self.currentViewController?.didMoveToParentViewController(self)
            }
        )
    }
    
    // MARK: - Public functions
    
    func swapViewControllers(style: SegmentioStyle) {
        swapCurrentController(controller(style))
    }
    
}