//
//  SegmentioCellWithLabel.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit

final class SegmentioCellWithLabel: SegmentioCell {
    
    override func setupConstraintsForSubviews() {
        super.setupConstraintsForSubviews()
        
        guard let containerView = containerView else {
            return
        }
        
        let views = ["containerView": containerView]
        
        // main constraints
        
        let segmentTitleLabelHorizontConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "|-[containerView]-|",
            options: [.AlignAllCenterX],
            metrics: nil,
            views: views
        )
        NSLayoutConstraint.activateConstraints(segmentTitleLabelHorizontConstraint)
        
        // custom constraints
        
        topConstraint = NSLayoutConstraint(
            item: containerView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Top,
            multiplier: 1,
            constant: padding
        )
        topConstraint?.active = true
        
        bottomConstraint = NSLayoutConstraint(
            item: contentView,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: containerView,
            attribute: .Bottom,
            multiplier: 1,
            constant: padding
        )
        bottomConstraint?.active = true
    }

}