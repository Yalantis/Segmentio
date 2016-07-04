//
//  SideMenuViewController.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit
import Segmentio

typealias SideMenuHandler = ((style: SegmentioStyle) -> Void)

private let animationDuration: NSTimeInterval = 0.3
private let selectedCheckboxImage = UIImage(named: "selectedCheckbox")
private let defaultCheckboxImage = UIImage(named: "defaultCheckbox")

class SideMenuViewController: UIViewController {
    
    var sideMenuDidHide: SideMenuHandler?
    
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var menuTableView: UITableView!
    @IBOutlet private weak var menuTableViewWidthConstraint: NSLayoutConstraint!
    
    private var menuItems = SegmentioStyle.allStyles
    private var currentStyle = SegmentioStyle.OnlyImage
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.hidden = true
        view.hidden = true
        menuTableViewWidthConstraint.constant = UIScreen.mainScreen().bounds.width * 0.7
        setupGestureRecognizers()
    }
    
    // MARK: - Public functions
    
    class func create() -> SideMenuViewController {
        let board = UIStoryboard(name: "Main", bundle: nil)
        return board.instantiateViewControllerWithIdentifier(String(self)) as! SideMenuViewController
    }
    
    func showSideMenu(viewController viewController: UIViewController, currentStyle: SegmentioStyle, sideMenuDidHide: SideMenuHandler?) {
        self.currentStyle = currentStyle
        self.sideMenuDidHide = sideMenuDidHide
        self.modalPresentationStyle = .OverCurrentContext
        let size = view.frame.size
        viewController.presentViewController(self, animated: false) { [weak self] in
            self?.view.hidden = false
            self?.menuTableView.frame.origin = CGPoint(x: -size.width, y: 0)
            UIView.animateWithDuration(
                animationDuration,
                animations: {
                    self?.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.63)
                    self?.slideAnimationToPoint(CGPointZero)
                    self?.menuTableView.hidden = false
                }
            )
        }
    }
    
    // MARK: - Private functions
    
    private func setupGestureRecognizers() {
        let dissmisSideMenuSelector = #selector(SideMenuViewController.dissmisSideMenu)
        
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: dissmisSideMenuSelector
        )
        tapRecognizer.delegate = self
        shadowView.addGestureRecognizer(tapRecognizer)
        
        let swipeRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: dissmisSideMenuSelector
        )
        swipeRecognizer.direction = .Left
        swipeRecognizer.delegate = self
        view.addGestureRecognizer(swipeRecognizer)
    }
    
    private func didSelectItemAtIndexPath(indexPath: NSIndexPath) {
        currentStyle = SegmentioStyle.allStyles[indexPath.row]
        dissmisSideMenu()
    }
    
    @objc private func dissmisSideMenu() {
        let size = view.frame.size
        
        UIView.animateWithDuration(
            animationDuration,
            animations: {
                self.slideAnimationToPoint(CGPoint(x: -size.width, y: 0))
                self.view.backgroundColor = UIColor.clearColor()
            },
            completion: { _ in
                self.view.hidden = true
                self.menuTableView.hidden = true
                self.sideMenuDidHide?(style: self.currentStyle)
            }
        )
    }
    
    private func slideAnimationToPoint(point: CGPoint) {
        UIView.animateWithDuration(animationDuration) {
            self.menuTableView.frame.origin = point
        }
    }
    
    private func uncheckCurrentStyle() {
        guard let currentStyleIndex = menuItems.indexOf(currentStyle) else {
            return
        }
        
        let activeIndexPath = NSIndexPath(
            forRow: currentStyleIndex,
            inSection: menuTableView.numberOfSections - 1
        )
        
        let activeCell = menuTableView.cellForRowAtIndexPath(activeIndexPath)
        activeCell?.imageView?.image = defaultCheckboxImage
    }
    
}

extension SideMenuViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        let isCurrentStyle = currentStyle == menuItems[indexPath.row]
        
        cell!.textLabel?.text = menuItems[indexPath.row].rawValue.stringFromCamelCase()
        cell!.imageView?.image = isCurrentStyle ? selectedCheckboxImage : defaultCheckboxImage
        
        return cell!
    }
    
}

extension SideMenuViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if currentStyle != menuItems[indexPath.row] {
            uncheckCurrentStyle()
            cell?.imageView?.image = selectedCheckboxImage
        }
        didSelectItemAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

extension SideMenuViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}