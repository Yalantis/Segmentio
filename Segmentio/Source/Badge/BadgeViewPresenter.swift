//
//  BadgeViewPresenter.swift
//  Pods
//
//  Created by Eugene on 22.09.16.
//
//

import UIKit

class BadgeViewPresenter {
    
    func addBadgeForContainerView(
        containerView: UIView,
        counterValue: Int,
        backgroundColor: UIColor = .redColor(),
        badgeSize: CounterBadgeSize = .Standard
        ) {
        var badgeView: BadgeWithCounterView!
        for view in containerView.subviews {
            if view is BadgeWithCounterView {
                badgeView = view as! BadgeWithCounterView
                badgeView?.setBadgeBackgroundColor(backgroundColor)
                badgeView?.setBadgeCounterValue(counterValue)
            }
        }
        if badgeView == nil {
            badgeView = badgeViewForCounterValue(
                counterValue,
                backgroundColor: backgroundColor,
                size: badgeSize
            )
            containerView.addSubview(badgeView)
            setupBadgeConstraints(containerView, badgeView: badgeView)
        }
    }
    
    func removeBadgeFromContainerView(containerView: UIView) {
        for view in containerView.subviews {
            if view is BadgeWithCounterView {
                view.removeFromSuperview()
            }
        }
    }
    
    
    private func setupBadgeConstraints(containerView: UIView, badgeView: BadgeWithCounterView) {
        
        let segmentTitleLabelHorizontalCenterConstraint =
            NSLayoutConstraint(
                item: badgeView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: containerView,
                attribute: .Top,
                multiplier: 1,
                constant: 1.0
        )
        
        let segmentTitleLabelVerticalCenterConstraint =
            NSLayoutConstraint(
                item: badgeView,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: containerView,
                attribute: .Trailing,
                multiplier: 1,
                constant: 1.0
        )
        containerView.addConstraints([segmentTitleLabelHorizontalCenterConstraint, segmentTitleLabelVerticalCenterConstraint])
        
    }
    
}

// MARK: Badges views creation

extension BadgeViewPresenter {
    
    private func badgeViewForCounterValue(counter: Int, backgroundColor: UIColor, size: CounterBadgeSize) -> BadgeWithCounterView {
        let view = BadgeWithCounterView.instanceFromNib(size: size)
        view.setBadgeBackgroundColor(backgroundColor)
        view.setBadgeCounterValue(counter)
        return view
    }
    
}