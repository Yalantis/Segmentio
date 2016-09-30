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
            badgeView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(badgeView)
            containerView.bringSubviewToFront(badgeView)
            setupBadgeConstraints(badgeView, counterValue: counterValue)
        }
    }
    
    func removeBadgeFromContainerView(containerView: UIView) {
        for view in containerView.subviews {
            if view is BadgeWithCounterView {
                view.removeFromSuperview()
            }
        }
    }
    
    private func setupBadgeConstraints(badgeView: BadgeWithCounterView, counterValue: Int) {
        var constraintConstant:CGFloat = -5.0
        if counterValue > 9 {
            constraintConstant = -10.0
        }
        let segmentTitleLabelHorizontalCenterConstraint =
            NSLayoutConstraint(
                item: badgeView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: badgeView.superview,
                attribute: .Top,
                multiplier: 1,
                constant: 6.0
        )
        
        let segmentTitleLabelVerticalCenterConstraint =
            NSLayoutConstraint(
                item: badgeView,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: badgeView.superview,
                attribute: .Trailing,
                multiplier: 1,
                constant: constraintConstant
        )
        segmentTitleLabelHorizontalCenterConstraint.active = true
        segmentTitleLabelVerticalCenterConstraint.active = true
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