//
//  SegmentioCellWithImageOrLabel.swift
//  Segmentio
//
//  Created by Ahsan Ali on 10/10/2019.
//

import UIKit

class SegmentioCellWithImageOrLabel: SegmentioCell {
    
    override func setupConstraintsForSubviews() {
        super.setupConstraintsForSubviews()
        guard let imageContainerView = imageContainerView else {
            return
        }
        guard let containerView = containerView else {
            return
        }
        
        let views = [
            "imageContainerView": imageContainerView,
            "containerView": containerView,
            "contentView": contentView
        ]
        
        // main constraints
        let segmentImageViewHorizontConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[contentView]-(<=1)-[imageContainerView]",
            options: [.alignAllCenterX],
            metrics: nil,
            views: views)
        NSLayoutConstraint.activate(segmentImageViewHorizontConstraint)
        
        let segmentImageViewVerticleConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[contentView]-(<=1)-[imageContainerView]",
            options: [.alignAllCenterY],
            metrics: nil,
            views: views)
        NSLayoutConstraint.activate(segmentImageViewVerticleConstraint)

        
        let segmentTitleLabelHorizontConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[contentView]-(<=1)-[containerView]",
            options: [.alignAllCenterX],
            metrics: nil,
            views: views
        )
        NSLayoutConstraint.activate(segmentTitleLabelHorizontConstraint)
        
        let segmentTitleLabelVerticleConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[contentView]-(<=1)-[containerView]",
            options: [.alignAllCenterY],
            metrics: nil,
            views: views
        )
        NSLayoutConstraint.activate(segmentTitleLabelVerticleConstraint)
        
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
