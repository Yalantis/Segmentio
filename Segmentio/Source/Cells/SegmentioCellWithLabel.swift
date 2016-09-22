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
            "|-(>=10)-[segmentTitleLabel]-(>=10)-|",
            options: [.AlignAllCenterX],
            metrics: nil,
            views: [
                "segmentTitleLabel": segmentTitleLabel
            ]
        )
        let segmentTitleLabelHorizontalCenterConstraint =
            NSLayoutConstraint(
                item: segmentTitleLabel,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: segmentTitleLabel.superview,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0.0
        )
        
        addConstraint(segmentTitleLabelHorizontalCenterConstraint)
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