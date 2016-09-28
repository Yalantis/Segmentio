//
//  ExampleViewController.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit
import Segmentio

class ExampleViewController: UIViewController {
    
    var segmentioStyle = SegmentioStyle.ImageOverLabel
    
    @IBOutlet private weak var segmentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var segmentioView: Segmentio!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private lazy var viewControllers: [UIViewController] = {
        return self.preparedViewControllers()
    }()
    
    // MARK: - Init
    
    class func create() -> ExampleViewController {
        let board = UIStoryboard(name: "Main", bundle: nil)
        return board.instantiateViewControllerWithIdentifier(String(self)) as! ExampleViewController
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch segmentioStyle {
        case .OnlyLabel, .ImageBeforeLabel, .ImageAfterLabel:
            segmentViewHeightConstraint.constant = 50
        case .OnlyImage:
            segmentViewHeightConstraint.constant = 100
        default:
            break
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupSegmentioView()
        setupScrollView()
        setupBadgeCountForIndex()
    }
    
    private func setupSegmentioView() {
        segmentioView.setup(
            content: segmentioContent(),
            style: segmentioStyle,
            options: segmentioOptions()
        )
        
        segmentioView.selectedSegmentioIndex = selectedSegmentioIndex()
        
        segmentioView.valueDidChange = { [weak self] _, segmentIndex in
            if let scrollViewWidth = self?.scrollView.frame.width {
                let contentOffsetX = scrollViewWidth * CGFloat(segmentIndex)
                self?.scrollView.setContentOffset(
                    CGPoint(x: contentOffsetX, y: 0),
                    animated: true
                )
            }
        }
    }
    
    private func setupBadgeCountForIndex() {
        segmentioView.setupBadgeAtIndex(1, count: 3, color: ColorPalette.WhiteSmokeColor)
    }
    
    private func segmentioContent() -> [SegmentioItem] {
        return [
            SegmentioItem(title: "Tornado", image: UIImage(named: "tornado")),
            SegmentioItem(title: "Earthquakes", image: UIImage(named: "earthquakes")),
            SegmentioItem(title: "Extreme heat", image: UIImage(named: "heat")),
            SegmentioItem(title: "Eruption", image: UIImage(named: "eruption")),
            SegmentioItem(title: "Floods", image: UIImage(named: "floods")),
            SegmentioItem(title: "Wildfires", image: UIImage(named: "wildfires"))
        ]
    }
    
    private func segmentioOptions() -> SegmentioOptions {
        var imageContentMode = UIViewContentMode.Center
        switch segmentioStyle {
        case .ImageBeforeLabel, .ImageAfterLabel:
            imageContentMode = .ScaleAspectFit
        default:
            break
        }
        
        return SegmentioOptions(
            backgroundColor: ColorPalette.WhiteColor,
            maxVisibleItems: 3,
            scrollEnabled: true,
            indicatorOptions: segmentioIndicatorOptions(),
            horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions(),
            verticalSeparatorOptions: segmentioVerticalSeparatorOptions(),
            imageContentMode: imageContentMode,
            labelTextAlignment: .Center,
            segmentStates: segmentioStates()
        )
    }
    
    private func segmentioStates() -> SegmentioStates {
        let font = UIFont.exampleAvenirMediumWithSize(13)
        return SegmentioStates(
            defaultState: segmentioState(
                backgroundColor: UIColor.clearColor(),
                titleFont: font,
                titleTextColor: ColorPalette.GrayChateauColor
            ),
            selectedState: segmentioState(
                backgroundColor: UIColor.clearColor(),
                titleFont: font,
                titleTextColor: ColorPalette.BlackColor
            ),
            highlightedState: segmentioState(
                backgroundColor: ColorPalette.WhiteSmokeColor,
                titleFont: font,
                titleTextColor: ColorPalette.GrayChateauColor
            )
        )
    }
    
    private func segmentioState(backgroundColor backgroundColor: UIColor, titleFont: UIFont, titleTextColor: UIColor) -> SegmentioState {
        return SegmentioState(backgroundColor: backgroundColor, titleFont: titleFont, titleTextColor: titleTextColor)
    }
    
    private func segmentioIndicatorOptions() -> SegmentioIndicatorOptions {
        return SegmentioIndicatorOptions(
            type: .Bottom,
            ratio: 1,
            height: 5,
            color: ColorPalette.CoralColor
        )
    }
    
    private func segmentioHorizontalSeparatorOptions() -> SegmentioHorizontalSeparatorOptions {
        return SegmentioHorizontalSeparatorOptions(
            type: .TopAndBottom,
            height: 1,
            color: ColorPalette.WhiteSmokeColor
        )
    }
    
    private func segmentioVerticalSeparatorOptions() -> SegmentioVerticalSeparatorOptions {
        return SegmentioVerticalSeparatorOptions(
            ratio: 1,
            color: ColorPalette.WhiteSmokeColor
        )
    }
    
    // Example viewControllers
    
    private func preparedViewControllers() -> [ContentViewController] {
        let tornadoController = ContentViewController.create()
        tornadoController.disaster = Disaster(cardName: "Before tornado", hints: Hints.Tornado)
        
        let earthquakesController = ContentViewController.create()
        earthquakesController.disaster = Disaster(cardName: "Before earthquakes", hints: Hints.Earthquakes)
        
        let extremeHeatController = ContentViewController.create()
        extremeHeatController.disaster = Disaster(cardName: "Before extreme heat", hints: Hints.ExtremeHeat)
        
        let eruptionController = ContentViewController.create()
        eruptionController.disaster = Disaster(cardName: "Before eruption", hints: Hints.Eruption)
        
        let floodsController = ContentViewController.create()
        floodsController.disaster = Disaster(cardName: "Before floods", hints: Hints.Floods)
        
        let wildfiresController = ContentViewController.create()
        wildfiresController.disaster = Disaster(cardName: "Before wildfires", hints: Hints.Wildfires)
        
        return [
            tornadoController,
            earthquakesController,
            extremeHeatController,
            eruptionController,
            floodsController,
            wildfiresController
        ]
    }
    
    private func selectedSegmentioIndex() -> Int {
        return 0
    }

    
    // MARK: - Setup container view
    
    private func setupScrollView() {
        scrollView.contentSize = CGSize(
            width: UIScreen.mainScreen().bounds.width * CGFloat(viewControllers.count),
            height: containerView.frame.height
        )
        
        for (index, viewController) in viewControllers.enumerate() {
            viewController.view.frame = CGRect(
                x: UIScreen.mainScreen().bounds.width * CGFloat(index),
                y: 0,
                width: scrollView.frame.width,
                height: scrollView.frame.height
            )
            addChildViewController(viewController)
            scrollView.addSubview(viewController.view, options: .UseAutoresize) // module's extension
            viewController.didMoveToParentViewController(self)
        }
    }
    
    // MARK: - Actions
    
    private func goToControllerAtIndex(index: Int) {
        segmentioView.selectedSegmentioIndex = index
    }
    
}

extension ExampleViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentPage = floor(scrollView.contentOffset.x / scrollView.frame.width)
        segmentioView.selectedSegmentioIndex = Int(currentPage)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 0)
    }
    
}