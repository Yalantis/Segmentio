//
//  SegmentioCell.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit

class SegmentioCell: UICollectionViewCell {
    
    let padding: CGFloat = 8
    let segmentTitleLabelHeight: CGFloat = 22
    
    var verticalSeparatorView: UIView?
    var segmentTitleLabel: UILabel?
    var segmentImageView: UIImageView?
    var containerView: UIView?
    
    var topConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    var cellSelected = false
    
    private var options = SegmentioOptions()
    private var style = SegmentioStyle.ImageOverLabel
    private let verticalSeparatorLayer = CAShapeLayer()
    private let badgePresenter = BadgeViewPresenter()
    
    override var highlighted: Bool {
        get {
            return super.highlighted
        }
        
        set {
            if newValue != highlighted {
                super.highlighted = newValue
                
                let highlightedState = options.states.highlightedState
                let defaultState = options.states.defaultState
                let selectedState = options.states.selectedState
                
                if style.isWithText() {
                    let highlightedTitleTextColor = cellSelected ? selectedState.titleTextColor : defaultState.titleTextColor
                    let highlightedTitleFont = cellSelected ? selectedState.titleFont : defaultState.titleFont
                    
                    segmentTitleLabel?.textColor = highlighted ? highlightedState.titleTextColor : highlightedTitleTextColor
                    segmentTitleLabel?.font = highlighted ? highlightedState.titleFont : highlightedTitleFont
                }
                
                backgroundColor = highlighted ? highlightedState.backgroundColor : defaultState.backgroundColor
            }
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        segmentImageView = UIImageView(frame: CGRectZero)
        if let segmentImageView = segmentImageView {
            contentView.addSubview(segmentImageView)
        }
        
        containerView = UIView(frame: CGRectZero)
        if let containerView = containerView {
            contentView.addSubview(containerView)
        }
        
        segmentTitleLabel = UILabel(frame: CGRectZero)
        if let segmentTitleLabel = segmentTitleLabel, containerView = containerView {
            containerView.addSubview(segmentTitleLabel)
        }

        segmentImageView?.translatesAutoresizingMaskIntoConstraints = false
        segmentTitleLabel?.translatesAutoresizingMaskIntoConstraints = false
        containerView?.translatesAutoresizingMaskIntoConstraints = false
        
        segmentImageView?.layer.masksToBounds = true
        segmentTitleLabel?.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        
        setupConstraintsForSubviews()
        addVerticalSeparator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        verticalSeparatorLayer.removeFromSuperlayer()
        super.prepareForReuse()
        
        switch style {
        case .OnlyLabel:
            segmentTitleLabel?.text = nil
        case .OnlyImage:
            segmentImageView?.image = nil
        default:
            segmentTitleLabel?.text = nil
            segmentImageView?.image = nil
        }
    }
    
    // MARK: - Configure
    
    func configure(content content: SegmentioItem, style: SegmentioStyle, options: SegmentioOptions, isLastCell: Bool) {
        self.options = options
        self.style = style
        setupContent(content: content)
        if let indicatorOptions = self.options.indicatorOptions {
            setupConstraint(indicatorOptions: indicatorOptions)
        }
        
        if let _ = options.verticalSeparatorOptions {
            if isLastCell == false {
                setupVerticalSeparators()
            }
        }
    }
    
    func configure(selected selected: Bool) {
        cellSelected = selected
        
        let selectedState = options.states.selectedState
        let defaultState = options.states.defaultState
        
        if style.isWithText() {
            segmentTitleLabel?.textColor = selected ? selectedState.titleTextColor : defaultState.titleTextColor
            segmentTitleLabel?.font = selected ? selectedState.titleFont : defaultState.titleFont
        }
    }
    
    func configurateBadgeWithCount(badgeCount: Int?, color: UIColor?) {
        guard let badgeCount = badgeCount, color = color else {
            return
        }
        
        if style == .OnlyImage {
            badgePresenter.addBadgeForContainerView(
                segmentImageView!,
                counterValue: badgeCount,
                backgroundColor: color,
                badgeSize: .Standard
            )
        } else {
            badgePresenter.addBadgeForContainerView(
                containerView!,
                counterValue: badgeCount,
                backgroundColor: color,
                badgeSize: .Standard
            )
        }
    }
    
    func setupConstraintsForSubviews() {
        setupContainerConstraints()
        return // implement in subclasses
    }

    // MARK: - Private functions
    
    private func setupContainerConstraints() {
        guard let segmentTitleLabel = segmentTitleLabel else {
            return
        }
        guard let containerView = containerView else {
            return
        }
        
        let segmentTitleLabelHorizontalCenterConstraint =
            NSLayoutConstraint(
                item: segmentTitleLabel,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: containerView,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0.0
        )
        
        let segmentTitleLabelVerticalCenterConstraint =
            NSLayoutConstraint(
                item: segmentTitleLabel,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: containerView,
                attribute: .CenterY,
                multiplier: 1,
                constant: 0.0
        )
        addConstraints([segmentTitleLabelHorizontalCenterConstraint, segmentTitleLabelVerticalCenterConstraint])
    }
    
    private func setupContent(content content: SegmentioItem) {
        if style.isWithImage() {
            segmentImageView?.contentMode = options.imageContentMode
            segmentImageView?.image = content.image
        }
        
        if style.isWithText() {
            segmentTitleLabel?.textAlignment = options.labelTextAlignment
            let defaultState = options.states.defaultState
            segmentTitleLabel?.textColor = defaultState.titleTextColor
            segmentTitleLabel?.font = defaultState.titleFont
            segmentTitleLabel?.text = content.title
        }
        configurateBadgeWithCount(content.badgeCount, color: content.badgeColor)
    }
    
    private func setupConstraint(indicatorOptions indicatorOptions: SegmentioIndicatorOptions) {
        switch indicatorOptions.type {
        case .Top:
            topConstraint?.constant = padding + indicatorOptions.height
        case .Bottom:
            bottomConstraint?.constant = padding + indicatorOptions.height
        }
    }

    // MARK: - Vertical separator
    
    private func addVerticalSeparator() {
        let contentViewWidth = contentView.bounds.width
        let rect = CGRect(
            x: contentView.bounds.width - 1,
            y: 0,
            width: 1,
            height: contentViewWidth
        )
        verticalSeparatorView = UIView(frame: rect)
        
        guard let verticalSeparatorView = verticalSeparatorView else {
            return
        }
        
        if let lastView = contentView.subviews.last {
            contentView.insertSubview(verticalSeparatorView, aboveSubview: lastView)
        } else {
            contentView.addSubview(verticalSeparatorView)
        }
        
        // setup constraints
        
        verticalSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(
            item: verticalSeparatorView,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1,
            constant: 1
        )
        widthConstraint.active = true
        
        let trailingConstraint = NSLayoutConstraint(
            item: verticalSeparatorView,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Trailing,
            multiplier: 1,
            constant: 0
        )
        trailingConstraint.active = true
        
        let topConstraint = NSLayoutConstraint(
            item: verticalSeparatorView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Top,
            multiplier: 1,
            constant: 0
        )
        topConstraint.active = true
        
        let bottomConstraint = NSLayoutConstraint(
            item: contentView,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: verticalSeparatorView,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0
        )
        bottomConstraint.active = true
    }
    
    private func setupVerticalSeparators() {
        guard let verticalSeparatorOptions = options.verticalSeparatorOptions else {
            return
        }
        
        guard let verticalSeparatorView = verticalSeparatorView else {
            return
        }
        
        let heightWithRatio = bounds.height * CGFloat(verticalSeparatorOptions.ratio)
        let difference = (bounds.height - heightWithRatio) / 2
        
        let startY = difference
        let endY = bounds.height - difference
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: verticalSeparatorView.frame.width / 2, y: startY))
        path.addLineToPoint(CGPoint(x: verticalSeparatorView.frame.width / 2, y: endY))
        
        verticalSeparatorLayer.path = path.CGPath
        verticalSeparatorLayer.lineWidth = 1
        verticalSeparatorLayer.strokeColor = verticalSeparatorOptions.color.CGColor
        verticalSeparatorLayer.fillColor = verticalSeparatorOptions.color.CGColor
        
        verticalSeparatorView.layer.addSublayer(verticalSeparatorLayer)
    }
    
}