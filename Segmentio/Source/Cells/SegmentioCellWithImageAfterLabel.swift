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
        guard let segmentImageView = segmentImageView else {
            return
        }
        guard let segmentTitleLabel = segmentTitleLabel else {
            return
        }
        
        let metrics = ["labelHeight": segmentTitleLabelHeight]
        let views = [
            "segmentImageView": segmentImageView,
            "segmentTitleLabel": segmentTitleLabel
        ]
        
        // main constraints
        
        let segmentImageViewVerticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[segmentImageView(labelHeight)]",
            options: [.AlignAllCenterY],
            metrics: metrics,
            views: views)
        NSLayoutConstraint.activateConstraints(segmentImageViewVerticalConstraint)
        
        let contentViewHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "|-[segmentTitleLabel]-[segmentImageView(labelHeight)]-|",
            options: [.AlignAllCenterY],
            metrics: metrics,
            views: views)
        NSLayoutConstraint.activateConstraints(contentViewHorizontalConstraints)
        
        // custom constraints
        
        topConstraint = NSLayoutConstraint(
            item: segmentTitleLabel,
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
            toItem: segmentTitleLabel,
            attribute: .Bottom,
            multiplier: 1,
            constant: padding
        )
        bottomConstraint?.active = true
    }
    
}