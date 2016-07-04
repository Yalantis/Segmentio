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
        guard let segmentTitleLabel = segmentTitleLabel else {
            return
        }
        
        let views = ["segmentTitleLabel": segmentTitleLabel]
        
        // main constraints
        
        let segmentTitleLabelHorizontConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "|-[segmentTitleLabel]-|",
            options: [],
            metrics: nil,
            views: views
        )
        NSLayoutConstraint.activateConstraints(segmentTitleLabelHorizontConstraint)
        
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