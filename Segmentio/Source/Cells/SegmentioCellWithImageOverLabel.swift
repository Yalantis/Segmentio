//
//  SegmentioCellWithImageOverLabel.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit

class SegmentioCellWithImageOverLabel: SegmentioCell {
    
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
        
        let segmentImageViewHorizontConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "|-[segmentImageView]-|",
            options: [],
            metrics: nil,
            views: views)
        NSLayoutConstraint.activateConstraints(segmentImageViewHorizontConstraint)
        
        let segmentTitleLabelHorizontConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "|-[containerView]-|",
            options: [.AlignAllCenterX],
            metrics: nil,
            views: views
        )
        
       
        NSLayoutConstraint.activateConstraints(segmentTitleLabelHorizontConstraint)
        
        let contentViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[segmentImageView]-[containerView(labelHeight)]",
            options: [],
            metrics: metrics,
            views: views)
        NSLayoutConstraint.activateConstraints(contentViewVerticalConstraints)
        
        // custom constraints
        
        topConstraint = NSLayoutConstraint(
            item: segmentImageView,
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