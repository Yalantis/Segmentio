//
//  SegmentioBuilder.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko on 11/14/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Segmentio
import UIKit

struct SegmentioBuilder {
    
    static func setupBadgeCountForIndex(_ segmentioView: Segmentio, index: Int) {
        segmentioView.addBadge(
            at: index,
            count: 10,
            color: ColorPalette.coral
        )
    }
    
    static func buildSegmentioView(segmentioView: Segmentio, segmentioStyle: SegmentioStyle) {
        segmentioView.setup(
            content: segmentioContent(),
            style: segmentioStyle,
            options: segmentioOptions(segmentioStyle: segmentioStyle)
        )
    }
    
    private static func segmentioContent() -> [SegmentioItem] {
        return [
            SegmentioItem(title: "Tornado", image: UIImage(named: "tornado")),
            SegmentioItem(title: "Earthquakes", image: UIImage(named: "earthquakes")),
            SegmentioItem(title: "Extreme heat", image: UIImage(named: "heat")),
            SegmentioItem(title: "Eruption", image: UIImage(named: "eruption")),
            SegmentioItem(title: "Floods", image: UIImage(named: "floods")),
            SegmentioItem(title: "Wildfires", image: UIImage(named: "wildfires"))
        ]
    }
    
    private static func segmentioOptions(segmentioStyle: SegmentioStyle) -> SegmentioOptions {
        var imageContentMode = UIViewContentMode.center
        switch segmentioStyle {
        case .imageBeforeLabel, .imageAfterLabel:
            imageContentMode = .scaleAspectFit
        default:
            break
        }
        
        return SegmentioOptions(
            backgroundColor: ColorPalette.white,
            maxVisibleItems: 3,
            scrollEnabled: true,
            indicatorOptions: segmentioIndicatorOptions(),
            horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions(),
            verticalSeparatorOptions: segmentioVerticalSeparatorOptions(),
            imageContentMode: imageContentMode,
            labelTextAlignment: .center,
            labelTextNumberOfLines: 1,
            segmentStates: segmentioStates(),
            animationDuration: 0.3
        )
    }
    
    private static func segmentioStates() -> SegmentioStates {
        let font = UIFont.exampleAvenirMedium(ofSize: 13)
        return SegmentioStates(
            defaultState: segmentioState(
                backgroundColor: .clear,
                titleFont: font,
                titleTextColor: ColorPalette.grayChateau
            ),
            selectedState: segmentioState(
                backgroundColor: .cyan,
                titleFont: font,
                titleTextColor: ColorPalette.black
            ),
            highlightedState: segmentioState(
                backgroundColor: ColorPalette.whiteSmoke,
                titleFont: font,
                titleTextColor: ColorPalette.grayChateau
            )
        )
    }
    
    private static func segmentioState(backgroundColor: UIColor, titleFont: UIFont, titleTextColor: UIColor) -> SegmentioState {
        return SegmentioState(
            backgroundColor: backgroundColor,
            titleFont: titleFont,
            titleTextColor: titleTextColor
        )
    }
    
    private static func segmentioIndicatorOptions() -> SegmentioIndicatorOptions {
        return SegmentioIndicatorOptions(
            type: .bottom,
            ratio: 1,
            height: 5,
            color: ColorPalette.coral
        )
    }
    
    private static func segmentioHorizontalSeparatorOptions() -> SegmentioHorizontalSeparatorOptions {
        return SegmentioHorizontalSeparatorOptions(
            type: .topAndBottom,
            height: 1,
            color: ColorPalette.whiteSmoke
        )
    }
    
    private static func segmentioVerticalSeparatorOptions() -> SegmentioVerticalSeparatorOptions {
        return SegmentioVerticalSeparatorOptions(
            ratio: 1,
            color: ColorPalette.whiteSmoke
        )
    }
    
}
