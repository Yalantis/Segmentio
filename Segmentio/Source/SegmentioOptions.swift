//
//  SegmentioOptions.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit

// MARK: - Item

public struct SegmentioItem {
    
    public var title: String?
    public var image: UIImage?
    public var selectedImage: UIImage?
    public var badgeCount: Int?
    public var badgeColor: UIColor?
    public var intrinsicWidth: CGFloat {
        let label = UILabel()
        label.text = self.title
        label.sizeToFit()
        return label.intrinsicContentSize.width
    }

    public init(title: String?, image: UIImage?, selectedImage: UIImage? = nil) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage ?? image
    }
    
    public mutating func addBadge(_ count: Int, color: UIColor) {
        self.badgeCount = count
        self.badgeColor = color
    }
    
    public mutating func removeBadge() {
        self.badgeCount = nil
        self.badgeColor = nil
    }
    
}

// MARK: - Content view

public struct SegmentioState {
    
    var backgroundColor: UIColor
    var titleFont: UIFont
    var titleTextColor: UIColor
    var titleAlpha: CGFloat
    
    public init(
        backgroundColor: UIColor = .clear,
        titleFont: UIFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
        titleTextColor: UIColor = .black,
        titleAlpha: CGFloat = 1) {
        self.backgroundColor = backgroundColor
        self.titleFont = titleFont
        self.titleTextColor = titleTextColor
        self.titleAlpha = titleAlpha
    }
    
}

// MARK: - Horizontal separator

public enum SegmentioHorizontalSeparatorType {
    
    case none
    case top
    case bottom
    case topAndBottom
    
}

public struct SegmentioHorizontalSeparatorOptions {
    
    var type: SegmentioHorizontalSeparatorType
    var height: CGFloat
    var color: UIColor
    
    public init(type: SegmentioHorizontalSeparatorType = .topAndBottom, height: CGFloat = 1.0,
                color: UIColor = .darkGray) {
        self.type = type
        self.height = height
        self.color = color
    }
    
}

// MARK: - Vertical separator

public struct SegmentioVerticalSeparatorOptions {
    
    var ratio: CGFloat
    var color: UIColor
    
    public init(ratio: CGFloat = 1, color: UIColor = .darkGray) {
        self.ratio = ratio
        self.color = color
    }

}

// MARK: - Indicator

public enum SegmentioIndicatorType {
    
    case top
    case bottom
    
}

public struct SegmentioIndicatorOptions {
    
    var type: SegmentioIndicatorType
    var ratio: CGFloat
    var height: CGFloat
    var color: UIColor
    
    public init(type: SegmentioIndicatorType = .bottom, ratio: CGFloat = 1, height: CGFloat = 2,
                color: UIColor = .orange) {
        self.type = type
        self.ratio = ratio
        self.height = height
        self.color = color
    }
    
}

// MARK: - Position

public enum SegmentioPosition {
    case dynamic
    case fixed(maxVisibleItems: Int)
}

// MARK: - Control options

public enum SegmentioStyle: String {
    
    case onlyLabel, onlyImage, imageOverLabel, imageUnderLabel, imageBeforeLabel, imageAfterLabel
    
    public static let allStyles = [
        onlyLabel,
        onlyImage,
        imageOverLabel,
        imageUnderLabel,
        imageBeforeLabel,
        imageAfterLabel
    ]
    
    public func isWithText() -> Bool {
        switch self {
        case .onlyLabel, .imageOverLabel, .imageUnderLabel, .imageBeforeLabel, .imageAfterLabel:
            return true
        default:
            return false
        }
    }
    
    public func isWithImage() -> Bool {
        switch self {
        case .imageOverLabel, .imageUnderLabel, .imageBeforeLabel, .imageAfterLabel, .onlyImage:
            return true
        default:
            return false
        }
    }

    public var layoutMargins: CGFloat {
        let defaultLayoutMargins: CGFloat = 8.0
        switch self {
        case .onlyLabel, .imageAfterLabel, .imageBeforeLabel, .imageOverLabel, .imageUnderLabel:
            return 4 * defaultLayoutMargins
        case .onlyImage:
            return 2 * defaultLayoutMargins
        }
    }
}

public typealias SegmentioStates = (defaultState: SegmentioState, selectedState: SegmentioState,
    highlightedState: SegmentioState)

public struct SegmentioOptions {
    
    var backgroundColor: UIColor
    var segmentPosition: SegmentioPosition
    var scrollEnabled: Bool
    var horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions?
    var verticalSeparatorOptions: SegmentioVerticalSeparatorOptions?
    var indicatorOptions: SegmentioIndicatorOptions?
    var imageContentMode: UIView.ContentMode
    var labelTextAlignment: NSTextAlignment
    var labelTextNumberOfLines: Int
    var states: SegmentioStates
    var animationDuration: CFTimeInterval
    
    public init() {
        self.backgroundColor = .lightGray
        self.segmentPosition = .fixed(maxVisibleItems: 4)
        self.scrollEnabled = true
        self.indicatorOptions = SegmentioIndicatorOptions()
        self.horizontalSeparatorOptions = SegmentioHorizontalSeparatorOptions()
        self.verticalSeparatorOptions = SegmentioVerticalSeparatorOptions()
        self.imageContentMode = .center
        self.labelTextAlignment = .center
        self.labelTextNumberOfLines = 0
        self.states = SegmentioStates(defaultState: SegmentioState(),
                                        selectedState: SegmentioState(),
                                        highlightedState: SegmentioState())
        self.animationDuration = 0.1
    }

    public init(backgroundColor: UIColor = .lightGray,
                segmentPosition: SegmentioPosition = .fixed(maxVisibleItems: 4),
                scrollEnabled: Bool = true,
                indicatorOptions: SegmentioIndicatorOptions? = SegmentioIndicatorOptions(),
                horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions? = SegmentioHorizontalSeparatorOptions(),
                verticalSeparatorOptions: SegmentioVerticalSeparatorOptions? = SegmentioVerticalSeparatorOptions(),
                imageContentMode: UIView.ContentMode = .center,
                labelTextAlignment: NSTextAlignment = .center,
                labelTextNumberOfLines: Int = 0,
                segmentStates: SegmentioStates = SegmentioStates(defaultState: SegmentioState(),
                                                                 selectedState: SegmentioState(),
                                                                 highlightedState: SegmentioState()),
                animationDuration: CFTimeInterval = 0.1) {
        self.backgroundColor = backgroundColor
        self.segmentPosition = segmentPosition
        self.scrollEnabled = scrollEnabled
        self.indicatorOptions = indicatorOptions
        self.horizontalSeparatorOptions = horizontalSeparatorOptions
        self.verticalSeparatorOptions = verticalSeparatorOptions
        self.imageContentMode = imageContentMode
        self.labelTextAlignment = labelTextAlignment
        self.labelTextNumberOfLines = labelTextNumberOfLines
        self.states = segmentStates
        self.animationDuration = animationDuration
    }
}
