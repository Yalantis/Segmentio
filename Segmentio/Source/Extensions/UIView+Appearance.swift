//
//  UIView+Appearance.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit

private typealias SubviewTreeModifier = (Void -> UIView)

public struct AppearanceOptions: OptionSetType {
    public let rawValue: UInt
    public init(rawValue: UInt) { self.rawValue = rawValue }
    public static let Overlay = AppearanceOptions(rawValue: 1 << 0)
    public static let UseAutoresize = AppearanceOptions(rawValue: 1 << 1)
}

extension UIView {
    
    private func addSubviewUsingOptions(options: AppearanceOptions, modifier: SubviewTreeModifier) {
        let subview = modifier()
        if options.union(.Overlay) == .Overlay {
            if options.union(.UseAutoresize) != .UseAutoresize {
                subview.translatesAutoresizingMaskIntoConstraints = false
                let views = dictionaryOfNames([subview])
                
                let horisontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                    "|[subview]|",
                    options: [],
                    metrics: nil,
                    views: views
                )
                addConstraints(horisontalConstraints)
                
                let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:|[subview]|",
                    options: [],
                    metrics: nil,
                    views: views
                )
                addConstraints(verticalConstraints)
                
            } else {
                frame = bounds
                subview.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            }
        }
    }
    
    private func dictionaryOfNames(views:[UIView]) -> [String: UIView] {
        var container = [String: UIView]()
        for (_, value) in views.enumerate() {
            container["subview"] = value
        }
        return container
    }
    
    // MARK: - Interface methods
    
    public func addSubview(subview: UIView, options: AppearanceOptions) {
        if subview.superview == self {
            return
        }
        addSubviewUsingOptions(options) { [weak self] in
            self?.addSubview(subview)
            return subview
        }
    }
    
    public func insertSubview(subview: UIView, index: Int, options: AppearanceOptions) {
        if subview.superview == self {
            return
        }
        addSubviewUsingOptions(options) { [weak self] in
            self?.insertSubview(subview, atIndex: index)
            return subview
        }
    }
    
}