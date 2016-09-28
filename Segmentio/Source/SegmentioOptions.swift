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
    var title: String?
    var image: UIImage?
    var badgeCount: Int?
    var badgeColor: UIColor?
    
    public init(title: String?, image: UIImage?) {
        self.title = title
        self.image = image
    }
    
    public mutating func setupBadgeWithCount(count: Int, color: UIColor = .redColor()) {
        self.badgeCount = count
        self.badgeColor = color
    }
    
}

// MARK: - Content view

public struct SegmentioState {
    var backgroundColor: UIColor
    var titleFont: UIFont
    var titleTextColor: UIColor
    
    public init(
        backgroundColor: UIColor = UIColor.clearColor(),
        titleFont: UIFont = UIFont.systemFontOfSize(UIFont.smallSystemFontSize()),
        titleTextColor: UIColor = UIColor.blackColor()) {
        self.backgroundColor = backgroundColor
        self.titleFont = titleFont
        self.titleTextColor = titleTextColor
    }
    
}

// MARK: - Horizontal separator

public enum SegmentioHorizontalSeparatorType {
    case Top, Bottom, TopAndBottom
}

public struct SegmentioHorizontalSeparatorOptions {
    var type: SegmentioHorizontalSeparatorType
    var height: CGFloat
    var color: UIColor
    
    public init(
        type: SegmentioHorizontalSeparatorType = .TopAndBottom,
        height: CGFloat = 1.0,
        color: UIColor = UIColor.darkGrayColor()) {
        self.type = type
        self.height = height
        self.color = color
    }
    
}

// MARK: - Vertical separator

public struct SegmentioVerticalSeparatorOptions {
    var ratio: CGFloat
    var color: UIColor
    
    public init(ratio: CGFloat = 1.0, color: UIColor = UIColor.darkGrayColor()) {
        self.ratio = ratio
        self.color = color
    }

}

// MARK: - Indicator

public enum SegmentioIndicatorType {
    case Top, Bottom
}

public struct SegmentioIndicatorOptions {
    var type: SegmentioIndicatorType
    var ratio: CGFloat
    var height: CGFloat
    var color: UIColor
    
    public init(
        type: SegmentioIndicatorType = .Bottom,
        ratio: CGFloat = 1.0,
        height: CGFloat = 2.0,
        color: UIColor = UIColor.orangeColor()) {
        self.type = type
        self.ratio = ratio
        self.height = height
        self.color = color
    }
    
}

// MARK: - Control options

public enum SegmentioStyle: String {
    case OnlyLabel, OnlyImage, ImageOverLabel, ImageUnderLabel, ImageBeforeLabel, ImageAfterLabel
    
    public static let allStyles = [
        OnlyLabel,
        OnlyImage,
        ImageOverLabel,
        ImageUnderLabel,
        ImageBeforeLabel,
        ImageAfterLabel
    ]
    
    public func isWithText() -> Bool {
        switch self {
        case .OnlyLabel, .ImageOverLabel, .ImageUnderLabel, .ImageBeforeLabel, .ImageAfterLabel:
            return true
        default:
            return false
        }
    }
    
    public func isWithImage() -> Bool {
        switch self {
        case .ImageOverLabel, .ImageUnderLabel, .ImageBeforeLabel, .ImageAfterLabel, .OnlyImage:
            return true
        default:
            return false
        }
    }
}

public typealias SegmentioStates = (defaultState: SegmentioState, selectedState: SegmentioState, highlightedState: SegmentioState)

public struct SegmentioOptions {
    var backgroundColor: UIColor
    var maxVisibleItems: Int
    var scrollEnabled: Bool
    var horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions?
    var verticalSeparatorOptions: SegmentioVerticalSeparatorOptions?
    var indicatorOptions: SegmentioIndicatorOptions?
    var imageContentMode: UIViewContentMode
    var labelTextAlignment: NSTextAlignment
    var states: SegmentioStates
    
    public init() {
        self.backgroundColor = UIColor.lightGrayColor()
        self.maxVisibleItems = 4
        self.scrollEnabled = true
        
        self.horizontalSeparatorOptions = SegmentioHorizontalSeparatorOptions()
        self.verticalSeparatorOptions = SegmentioVerticalSeparatorOptions()
        
        self.indicatorOptions = SegmentioIndicatorOptions()
        
        self.imageContentMode = .Center
        self.labelTextAlignment = .Center
        
        self.states = SegmentioStates(
            defaultState: SegmentioState(),
            selectedState: SegmentioState(),
            highlightedState: SegmentioState()
        )
    }
    
    public init(backgroundColor: UIColor, maxVisibleItems: Int, scrollEnabled: Bool, indicatorOptions: SegmentioIndicatorOptions?, horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions?, verticalSeparatorOptions: SegmentioVerticalSeparatorOptions?, imageContentMode: UIViewContentMode, labelTextAlignment: NSTextAlignment, segmentStates: SegmentioStates) {
        self.backgroundColor = backgroundColor
        self.maxVisibleItems = maxVisibleItems
        self.scrollEnabled = scrollEnabled
        self.indicatorOptions = indicatorOptions
        self.horizontalSeparatorOptions = horizontalSeparatorOptions
        self.verticalSeparatorOptions = verticalSeparatorOptions
        self.imageContentMode = imageContentMode
        self.labelTextAlignment = labelTextAlignment
        self.states = segmentStates
    }
    
}