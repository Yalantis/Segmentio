//
//  BadgeViewPresenter.swift
//  Pods
//
//  Created by Eugene on 22.09.16.
//
//

import UIKit

class BadgeViewPresenter {
    
    func addBadgeForContainerView(_ containerView: UIView, counterValue: Int, backgroundColor: UIColor = .red,
                                  badgeSize: BadgeSize = .standard, badgePosition: BadgePosition = .topRight) {
        var badgeView: BadgeWithCounterView!
        for view in containerView.subviews {
            if view is BadgeWithCounterView {
                badgeView = view as? BadgeWithCounterView
                badgeView?.setBadgeBackgroundColor(backgroundColor)
                badgeView?.setBadgeCounterValue(counterValue)
            }
        }
        if badgeView == nil {
            badgeView = badgeViewForCounterValue(counterValue, backgroundColor: backgroundColor, size: badgeSize)
            badgeView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(badgeView)
            containerView.bringSubviewToFront(badgeView)
            setupBadgeConstraints(badgeView, counterValue: counterValue, badgePosition: badgePosition)
        }
    }
    
    func removeBadgeFromContainerView(_ containerView: UIView) {
        for view in containerView.subviews {
            if view is BadgeWithCounterView {
                view.removeFromSuperview()
            }
        }
    }
    
    fileprivate func setupBadgeConstraints(_ badgeView: BadgeWithCounterView, counterValue: Int, badgePosition: BadgePosition) {
        guard let superView = badgeView.superview else { return }
        var targetVerticalCenter: NSLayoutConstraint.Attribute?
        var targetHorizontalCenter: NSLayoutConstraint.Attribute?

        switch badgePosition {
        case .topLeft:
            targetVerticalCenter = .top
            targetHorizontalCenter = .left
        case .topRight:
            targetVerticalCenter = .top
            targetHorizontalCenter = .right
        case .bottomLeft:
            targetVerticalCenter = .bottom
            targetHorizontalCenter = .left
        case .bottomRight:
            targetVerticalCenter = .bottom
            targetHorizontalCenter = .right
        }
        
        guard let targetVerticalCenter = targetVerticalCenter else { return }
        guard let targetHorizontalCenter = targetHorizontalCenter else { return }
        
        let segmentTitleLabelVerticalCenterConstraint =
            NSLayoutConstraint(
                item: badgeView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: badgeView.superview,
                attribute: targetVerticalCenter,
                multiplier: 1,
                constant: 0.0
        )
        let segmentTitleLabelHorizontalCenterConstraint =
            NSLayoutConstraint(
                item: badgeView,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: superView,
                attribute: targetHorizontalCenter,
                multiplier: 1,
                constant: 0.0
        )f
        segmentTitleLabelVerticalCenterConstraint.isActive = true
        segmentTitleLabelHorizontalCenterConstraint.isActive = true
    }
    
}

enum Separator {
    
    case top
    case bottom
    case topAndBottom
    
}



// MARK: Badges views creation

extension BadgeViewPresenter {
    
    fileprivate func badgeViewForCounterValue(_ counter: Int, backgroundColor: UIColor, size: BadgeSize) -> BadgeWithCounterView {
        let view = BadgeWithCounterView.instanceFromNib(size: size)
        view.setBadgeBackgroundColor(backgroundColor)
        view.setBadgeCounterValue(counter)
        return view
        
    }
    
}
