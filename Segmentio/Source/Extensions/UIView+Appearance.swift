//
//  UIView+Appearance.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit

private typealias SubviewTreeModifier = (() -> UIView)

public struct AppearanceOptions: OptionSet {
    
    public static let overlay = AppearanceOptions(rawValue: 1 << 0)
    public static let useAutoresize = AppearanceOptions(rawValue: 1 << 1)
    
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

extension UIView {
    
    fileprivate func addSubviewUsingOptions(_ options: AppearanceOptions, modifier: SubviewTreeModifier) {
        let subview = modifier()
        if options.union(.overlay) == .overlay {
            if options.union(.useAutoresize) != .useAutoresize {
                subview.translatesAutoresizingMaskIntoConstraints = false
                
                if #available(iOS 11.0, *) {
                    subview.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
                    subview.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
                    subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
                    subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
                } else {
                    let views = dictionaryOfNames([subview])
                    
                    let horisontalConstraints = NSLayoutConstraint.constraints(
                        withVisualFormat: "|[subview]|",
                        options: [],
                        metrics: nil,
                        views: views
                    )
                    addConstraints(horisontalConstraints)
                    
                    let verticalConstraints = NSLayoutConstraint.constraints(
                        withVisualFormat: "V:|[subview]|",
                        options: [],
                        metrics: nil,
                        views: views
                    )
                    addConstraints(verticalConstraints)
                }
            } else {
                frame = bounds
                subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            }
        }
    }
    
    fileprivate func dictionaryOfNames(_ views: [UIView]) -> [String: UIView] {
        var container = [String: UIView]()
        for (_, value) in views.enumerated() {
            container["subview"] = value
        }
        return container
    }
    
    // MARK: - Interface methods
    
    public func addSubview(_ subview: UIView, options: AppearanceOptions) {
        if subview.superview == self {
            return
        }
        addSubviewUsingOptions(options) { [weak self] in
            self?.addSubview(subview)
            return subview
        }
    }
    
    public func insertSubview(_ subview: UIView, index: Int, options: AppearanceOptions) {
        if subview.superview == self {
            return
        }
        addSubviewUsingOptions(options) { [weak self] in
            self?.insertSubview(subview, at: index)
            return subview
        }
    }
    
}
