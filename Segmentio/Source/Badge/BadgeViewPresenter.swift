//
//  BadgeViewPresenter.swift
//  Pods
//
//  Created by Eugene on 22.09.16.
//
//

import UIKit

class BadgeViewPresenter {
    
    func addBadgeForContainerView(_ containerView: UIView, counterValue: Int?, backgroundColor: UIColor = .red, badgeSize: BadgeSize = .standard) {
        var badgeView: BadgeWithCounterView!
        for view in containerView.subviews {
            if view is BadgeWithCounterView {
                badgeView = view as! BadgeWithCounterView
                badgeView?.setBadgeBackgroundColor(backgroundColor)
                badgeView?.setBadgeCounterValue(counterValue)
            }
        }
        if badgeView == nil {
            badgeView = badgeViewForCounterValue(counterValue, backgroundColor: backgroundColor, size: badgeSize)
            badgeView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(badgeView)
            containerView.bringSubview(toFront: badgeView)
            setupBadgeConstraints(badgeView, counterValue: counterValue)
        }
    }
    
    func removeBadgeFromContainerView(_ containerView: UIView) {
        for view in containerView.subviews {
            if view is BadgeWithCounterView {
                view.removeFromSuperview()
            }
        }
    }
    
    fileprivate func setupBadgeConstraints(_ badgeView: BadgeWithCounterView, counterValue: Int?) {
        var constraintConstant:CGFloat = -5.0
        if let count = counterValue {
            if count > 9 {
                constraintConstant = -10.0
            }
            let segmentTitleLabelHorizontalCenterConstraint =
                NSLayoutConstraint(
                    item: badgeView,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: badgeView.superview,
                    attribute: .top,
                    multiplier: 1,
                    constant: 6.0
            )
            
            let segmentTitleLabelVerticalCenterConstraint =
                NSLayoutConstraint(
                    item: badgeView,
                    attribute: .trailing,
                    relatedBy: .equal,
                    toItem: badgeView.superview,
                    attribute: .trailing,
                    multiplier: 1,
                    constant: constraintConstant
            )
            segmentTitleLabelHorizontalCenterConstraint.isActive = true
            segmentTitleLabelVerticalCenterConstraint.isActive = true
        } else {
            let segmentTitleLabelHorizontalCenterConstraint =
                NSLayoutConstraint(
                    item: badgeView,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: badgeView.superview,
                    attribute: .top,
                    multiplier: 1,
                    constant: 6.0
            )
            
            let segmentTitleLabelVerticalCenterConstraint =
                NSLayoutConstraint(
                    item: badgeView,
                    attribute: .trailing,
                    relatedBy: .equal,
                    toItem: badgeView.superview,
                    attribute: .trailing,
                    multiplier: 1,
                    constant: constraintConstant
            )
            
            let width = NSLayoutConstraint(
                item: badgeView,
                attribute: NSLayoutAttribute.width,
                relatedBy:NSLayoutRelation.equal,
                toItem:nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier:0.0,
                constant:10
            )
    
            let height = NSLayoutConstraint(
                item: badgeView,
                attribute:
                NSLayoutAttribute.height,
                relatedBy:NSLayoutRelation.equal,
                toItem:nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier:0.0,
                constant:10
            )
            segmentTitleLabelHorizontalCenterConstraint.isActive = true
            segmentTitleLabelVerticalCenterConstraint.isActive = true
            badgeView.addConstraints([width, height])
        }
    }
    
}

enum Separator {
    
    case top
    case bottom
    case topAndBottom
}



// MARK: Badges views creation

extension BadgeViewPresenter {
    
    fileprivate func badgeViewForCounterValue(_ counter: Int?, backgroundColor: UIColor, size: BadgeSize) -> BadgeWithCounterView {
        let view = BadgeWithCounterView.instanceFromNib(size: size)
        view.setBadgeBackgroundColor(backgroundColor)
        view.setBadgeCounterValue(counter)

        return view
    }
    
}
