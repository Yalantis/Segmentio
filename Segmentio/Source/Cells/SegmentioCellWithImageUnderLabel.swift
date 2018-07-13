//
//  SegmentioCellWithImageUnderLabel.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit

class SegmentioCellWithImageUnderLabel: SegmentioCell {
    
    override func setupConstraintsForSubviews() {
        super.setupConstraintsForSubviews()
        guard let imageContainerView = imageContainerView else {
            return
        }
        guard let containerView = containerView else {
            return
        }
        
        let metrics = ["labelHeight": SegmentioCell.segmentTitleLabelHeight]
        let views = [
            "imageContainerView": imageContainerView,
            "containerView": containerView
        ]
        
        // main constraints
        
        let segmentImageViewHorizontConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "|-[imageContainerView]-|",
            options: [],
            metrics: nil,
            views: views)
        NSLayoutConstraint.activate(segmentImageViewHorizontConstraint)
        
        let segmentTitleLabelHorizontConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "|-[containerView]-|",
            options: [.alignAllCenterX],
            metrics: nil,
            views: views
        )
        NSLayoutConstraint.activate(segmentTitleLabelHorizontConstraint)
        
        let contentViewVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[containerView(labelHeight)]-[imageContainerView]",
            options: [],
            metrics: metrics,
            views: views)
        NSLayoutConstraint.activate(contentViewVerticalConstraints)
        
        // custom constraints
        
        topConstraint = NSLayoutConstraint(
            item: containerView,
            attribute: .top,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .top,
            multiplier: 1,
            constant: padding
        )
        topConstraint?.isActive = true
        
        bottomConstraint = NSLayoutConstraint(
            item: contentView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: imageContainerView,
            attribute: .bottom,
            multiplier: 1,
            constant: padding
        )
        bottomConstraint?.isActive = true
    }
    
}
