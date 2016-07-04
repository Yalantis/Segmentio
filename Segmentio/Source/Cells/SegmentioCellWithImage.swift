//
//  SegmentioCellWithImage.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit

final class SegmentioCellWithImage: SegmentioCell {
    
    override func setupConstraintsForSubviews() {
        guard let segmentImageView = segmentImageView else {
            return
        }
        
        let views = ["segmentImageView": segmentImageView]
        
        // main constraints
        
        let segmentImageViewlHorizontConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "|-[segmentImageView]-|",
            options: [],
            metrics: nil,
            views: views)
        NSLayoutConstraint.activateConstraints(segmentImageViewlHorizontConstraint)
        
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
            toItem: segmentImageView,
            attribute: .Bottom,
            multiplier: 1,
            constant: padding
        )
        bottomConstraint?.active = true
    }
    
}