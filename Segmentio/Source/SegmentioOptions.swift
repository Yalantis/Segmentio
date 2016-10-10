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
    
    public init(
        backgroundColor: UIColor = .clear,
        titleFont: UIFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
        titleTextColor: UIColor = .black) {
        self.backgroundColor = backgroundColor
        self.titleFont = titleFont
        self.titleTextColor = titleTextColor
    }
    
}

// MARK: - Horizontal separator

public enum SegmentioHorizontalSeparatorType {
    
    case top
    case bottom
    case topAndBottom
    
}

public struct SegmentioHorizontalSeparatorOptions {
    
    var type: SegmentioHorizontalSeparatorType
    var height: CGFloat
    var color: UIColor
    
    public init(type: SegmentioHorizontalSeparatorType = .topAndBottom, height: CGFloat = 1.0, color: UIColor = .darkGray) {
        self.type = type
        self.height = height
        self.color = color
    }
    
}

// MARK: - Vertical separator

public struct SegmentioVerticalSeparatorOptions {
    
    var ratio: CGFloat
    var color: UIColor
    
    public init(ratio: CGFloat = 1.0, color: UIColor = .darkGray) {
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
    
    public init(type: SegmentioIndicatorType = .bottom, ratio: CGFloat = 1.0, height: CGFloat = 2.0, color: UIColor = .orange) {
        self.type = type
        self.ratio = ratio
        self.height = height
        self.color = color
    }
    
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
        self.backgroundColor = .lightGray
        self.maxVisibleItems = 4
        self.scrollEnabled = true
        
        self.horizontalSeparatorOptions = SegmentioHorizontalSeparatorOptions()
        self.verticalSeparatorOptions = SegmentioVerticalSeparatorOptions()
        
        self.indicatorOptions = SegmentioIndicatorOptions()
        
        self.imageContentMode = .center
        self.labelTextAlignment = .center
        
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
