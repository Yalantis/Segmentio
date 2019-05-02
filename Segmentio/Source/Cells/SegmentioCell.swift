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
    static let segmentTitleLabelHeight: CGFloat = 22
    
    var verticalSeparatorView: UIView?
    var segmentTitleLabel: UILabel?
    var segmentImageView: UIImageView?
    var containerView: UIView?
    var imageContainerView: UIView?
    
    var topConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    var cellSelected = false
    
    private var options = SegmentioOptions()
    private var style = SegmentioStyle.imageOverLabel
    private let verticalSeparatorLayer = CAShapeLayer()
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        
        set {
            if newValue != isHighlighted {
                super.isHighlighted = newValue
                
                let highlightedState = options.states.highlightedState
                let defaultState = options.states.defaultState
                let selectedState = options.states.selectedState
                
                if style.isWithText() {
                    let highlightedTitleTextColor = cellSelected ? selectedState.titleTextColor
                        : defaultState.titleTextColor
                    let highlightedTitleFont = cellSelected ? selectedState.titleFont : defaultState.titleFont
                    
                    segmentTitleLabel?.textColor = isHighlighted ? highlightedState.titleTextColor
                        : highlightedTitleTextColor
                    segmentTitleLabel?.font = isHighlighted ? highlightedState.titleFont : highlightedTitleFont
                }
                
                backgroundColor = isHighlighted ? highlightedState.backgroundColor : .clear
            }
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageContainerView = UIView(frame: CGRect.zero)
        if let imageContainerView = imageContainerView {
            contentView.addSubview(imageContainerView)
        }

        segmentImageView = UIImageView(frame: CGRect.zero)
        if let segmentImageView = segmentImageView, let imageContainerView = imageContainerView {
            imageContainerView.addSubview(segmentImageView)
        }
        
        containerView = UIView(frame: CGRect.zero)
        if let containerView = containerView {
            contentView.addSubview(containerView)
        }
        
        segmentTitleLabel = UILabel(frame: CGRect.zero)
        if let segmentTitleLabel = segmentTitleLabel, let containerView = containerView {
            containerView.addSubview(segmentTitleLabel)
        }

        segmentImageView?.translatesAutoresizingMaskIntoConstraints = false
        segmentTitleLabel?.translatesAutoresizingMaskIntoConstraints = false
        containerView?.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView?.translatesAutoresizingMaskIntoConstraints = false
        
        segmentImageView?.layer.masksToBounds = true
        segmentTitleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        
        setupConstraintsForSubviews()
        addVerticalSeparator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        verticalSeparatorLayer.removeFromSuperlayer()
        super.prepareForReuse()
        
        let badgePresenter = BadgeViewPresenter()
        switch style {
        case .onlyLabel:
            badgePresenter.removeBadgeFromContainerView(containerView!)
            segmentTitleLabel?.text = nil
        case .onlyImage:
            badgePresenter.removeBadgeFromContainerView(imageContainerView!)
            segmentImageView?.image = nil
        default:
            badgePresenter.removeBadgeFromContainerView(containerView!)
            segmentTitleLabel?.text = nil
            segmentImageView?.image = nil
        }
    }
    
    // MARK: - Configure
    
    func configure(content: SegmentioItem, style: SegmentioStyle, options: SegmentioOptions, isLastCell: Bool) {
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
        configurateBadgeWithCount(content.badgeCount, color: content.badgeColor)
    }
    
    func configure(selected: Bool, selectedImage: UIImage? = nil, image: UIImage? = nil) {
        cellSelected = selected
        
        let selectedState = options.states.selectedState
        let defaultState = options.states.defaultState
        
        if style.isWithText() {
            segmentTitleLabel?.textColor = selected ? selectedState.titleTextColor : defaultState.titleTextColor
            segmentTitleLabel?.font = selected ? selectedState.titleFont : defaultState.titleFont
            segmentTitleLabel?.alpha = selected ? selectedState.titleAlpha : defaultState.titleAlpha
            segmentTitleLabel?.minimumScaleFactor = 0.5
            segmentTitleLabel?.adjustsFontSizeToFitWidth = true
        }
                
        if (style != .onlyLabel) {
            segmentImageView?.image = selected ? selectedImage : image
        }
    }
    
    func configurateBadgeWithCount(_ badgeCount: Int?, color: UIColor?) {
        guard let badgeCount = badgeCount, let color = color else {
            return
        }
        
        let badgePresenter = BadgeViewPresenter()
        if style == .onlyImage {
            badgePresenter.addBadgeForContainerView(
                imageContainerView!,
                counterValue: badgeCount,
                backgroundColor: color,
                badgeSize: .standard
            )
        } else {
            badgePresenter.addBadgeForContainerView(
                containerView!,
                counterValue: badgeCount,
                backgroundColor: color,
                badgeSize: .standard
            )
        }
    }
    
    func setupConstraintsForSubviews() {
        setupContainerConstraints()
        setupImageContainerConstraints()
        return // implement in subclasses
    }

    // MARK: - Private functions
    
    private func setupContainerConstraints() {
        guard let segmentTitleLabel = segmentTitleLabel, let containerView = containerView else {
            return
        }
        
        let segmentTitleLabelVerticalCenterConstraint = NSLayoutConstraint(
            item: segmentTitleLabel,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: containerView,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        )
        let segmentTitleLabelTrailingConstraint = NSLayoutConstraint(
            item: segmentTitleLabel,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: containerView,
            attribute: .trailingMargin,
            multiplier: 1.0,
            constant: 0
        )
        let segmentTitleLabelLeadingConstraint = NSLayoutConstraint(
            item: segmentTitleLabel,
            attribute: .leading,
            relatedBy: .equal,
            toItem: containerView,
            attribute: .leadingMargin,
            multiplier: 1.0,
            constant: 0
        )
        
        addConstraints([
            segmentTitleLabelTrailingConstraint,
            segmentTitleLabelVerticalCenterConstraint,
            segmentTitleLabelLeadingConstraint
        ])
    }
    
    private func setupImageContainerConstraints() {
        guard let segmentImageView = segmentImageView else {
            return
        }
        guard let imageContainerView = imageContainerView else {
            return
        }
        
        let segmentImageViewTopConstraint =
            NSLayoutConstraint(
                item: segmentImageView,
                attribute: .top,
                relatedBy: .equal,
                toItem: imageContainerView,
                attribute: .top,
                multiplier: 1,
                constant: 0
        )
        
        let segmentImageViewLeadingConstraint =
            NSLayoutConstraint(
                item: segmentImageView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: imageContainerView,
                attribute: .leading,
                multiplier: 1,
                constant: 0
        )
        
        let segmentImageViewTrailingConstraint =
            NSLayoutConstraint(
                item: segmentImageView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: imageContainerView,
                attribute: .trailing,
                multiplier: 1,
                constant: 0
        )
        
        let segmentImageViewBottomConstraint =
            NSLayoutConstraint(
                item: segmentImageView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: imageContainerView,
                attribute: .bottom,
                multiplier: 1,
                constant: 0
        )
        addConstraints([
            segmentImageViewBottomConstraint,
            segmentImageViewTrailingConstraint,
            segmentImageViewLeadingConstraint,
            segmentImageViewTopConstraint
            ])
    }

    
    private func setupContent(content: SegmentioItem) {
        if style.isWithImage() {
            segmentImageView?.contentMode = options.imageContentMode
            segmentImageView?.image = content.image
        }
        
        if style.isWithText() {
            segmentTitleLabel?.textAlignment = options.labelTextAlignment
            segmentTitleLabel?.numberOfLines = options.labelTextNumberOfLines
            let defaultState = options.states.defaultState
            segmentTitleLabel?.textColor = defaultState.titleTextColor
            segmentTitleLabel?.font = defaultState.titleFont
            segmentTitleLabel?.text = content.title
            segmentTitleLabel?.minimumScaleFactor = 0.5
            segmentTitleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    private func setupConstraint(indicatorOptions: SegmentioIndicatorOptions) {
        switch indicatorOptions.type {
        case .top:
            topConstraint?.constant = padding + indicatorOptions.height
        case .bottom:
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
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 1
        )
        widthConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(
            item: verticalSeparatorView,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .trailing,
            multiplier: 1,
            constant: 0
        )
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(
            item: verticalSeparatorView,
            attribute: .top,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .top,
            multiplier: 1,
            constant: 0
        )
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(
            item: contentView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: verticalSeparatorView,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        bottomConstraint.isActive = true
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
        path.move(to: CGPoint(x: verticalSeparatorView.frame.width / 2, y: startY))
        path.addLine(to: CGPoint(x: verticalSeparatorView.frame.width / 2, y: endY))
        
        verticalSeparatorLayer.path = path.cgPath
        verticalSeparatorLayer.lineWidth = 1
        verticalSeparatorLayer.strokeColor = verticalSeparatorOptions.color.cgColor
        verticalSeparatorLayer.fillColor = verticalSeparatorOptions.color.cgColor
        
        verticalSeparatorView.layer.addSublayer(verticalSeparatorLayer)
    }
    
}
