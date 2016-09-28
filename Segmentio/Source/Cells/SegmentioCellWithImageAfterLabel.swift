//
//  SegmentioCellWithImageAfterLabel.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit

final class SegmentioCellWithImageAfterLabel: SegmentioCell {
    
    override func setupConstraintsForSubviews() {
        super.setupConstraintsForSubviews()
        guard let segmentImageView = segmentImageView else {
            return
        }
        guard let containerView = containerView else {
            return
        }
        
        let metrics = ["labelHeight": segmentTitleLabelHeight]
        let views = [
            "segmentImageView": segmentImageView,
            "containerView": containerView
        ]
        
        // main constraints
        
        let segmentImageViewVerticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[segmentImageView(labelHeight)]",
            options: [.AlignAllCenterY],
            metrics: metrics,
            views: views)
        NSLayoutConstraint.activateConstraints(segmentImageViewVerticalConstraint)
        
        let contentViewHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "|-[containerView]-[segmentImageView(labelHeight)]-|",
            options: [.AlignAllCenterY],
            metrics: metrics,
            views: views)
        NSLayoutConstraint.activateConstraints(contentViewHorizontalConstraints)
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