//
//  Segmentio.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit
import QuartzCore

public typealias SegmentioSelectionCallback = ((segmentio: Segmentio, selectedSegmentioIndex: Int) -> Void)

private let animationDuration: CFTimeInterval = 0.3

public class Segmentio: UIView {
    
    internal struct Points {
        var startPoint: CGPoint
        var endPoint: CGPoint
    }
    
    internal struct Context {
        var isFirstCell: Bool
        var isLastCell: Bool
        var isLastOrPrelastVisibleCell: Bool
        var isFirstOrSecondVisibleCell: Bool
        var isFirstIndex: Bool
    }
    
    internal struct ItemInSuperview {
        var collectionViewWidth: CGFloat
        var cellFrameInSuperview: CGRect
        var shapeLayerWidth: CGFloat
        var startX: CGFloat
        var endX: CGFloat
    }
    
    public var valueDidChange: SegmentioSelectionCallback?
    public var selectedSegmentioIndex = -1 {
        didSet {
            if selectedSegmentioIndex != oldValue {
                reloadSegmentio()
                valueDidChange?(segmentio: self, selectedSegmentioIndex: selectedSegmentioIndex)
            }
        }
    }
    
    private var segmentioCollectionView: UICollectionView?
    private var segmentioItems = [SegmentioItem]()
    private var segmentioOptions = SegmentioOptions()
    private var segmentioStyle = SegmentioStyle.ImageOverLabel
    private var isPerformingScrollAnimation = false
    
    private var topSeparatorView: UIView?
    private var bottomSeparatorView: UIView?
    private var indicatorLayer: CAShapeLayer?
    private var selectedLayer: CAShapeLayer?
    
    private var cachedOrientation: UIInterfaceOrientation? = UIApplication.sharedApplication().statusBarOrientation {
        didSet {
            if cachedOrientation != oldValue {
                reloadSegmentio()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        setupSegmentedCollectionView()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(Segmentio.handleOrientationNotification),
            name: UIDeviceOrientationDidChangeNotification,
            object: nil
        )
    }
    
    private func setupSegmentedCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsZero
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(
            frame: frameForSegmentCollectionView(),
            collectionViewLayout: layout
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.pagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = true
        collectionView.scrollEnabled = segmentioOptions.scrollEnabled
        collectionView.backgroundColor = UIColor.clearColor()
        
        segmentioCollectionView = collectionView
        
        if let segmentioCollectionView = segmentioCollectionView {
            addSubview(segmentioCollectionView, options: .Overlay)
        }
    }
    
    private func frameForSegmentCollectionView() -> CGRect {
        var separatorsHeight: CGFloat = 0
        var collectionViewFrameMinY: CGFloat = 0
        
        if let horizontalSeparatorOptions = segmentioOptions.horizontalSeparatorOptions {
            let separatorHeight = horizontalSeparatorOptions.height
            
            switch horizontalSeparatorOptions.type {
            case .Top:
                collectionViewFrameMinY = separatorHeight
                separatorsHeight = separatorHeight
            case .Bottom:
                separatorsHeight = separatorHeight
            case .TopAndBottom:
                collectionViewFrameMinY = separatorHeight
                separatorsHeight = separatorHeight * 2
            }
        }
        
        return CGRect(
            x: 0,
            y: collectionViewFrameMinY,
            width: bounds.width,
            height: bounds.height - separatorsHeight
        )
    }
    
    // MARK: - Handle orientation notification
    
    @objc private func handleOrientationNotification() {
         cachedOrientation = UIApplication.sharedApplication().statusBarOrientation
    }
    
    // MARK: - Setups:
    // MARK: Main setup
    
    public func setup(content content: [SegmentioItem], style: SegmentioStyle, options: SegmentioOptions?) {
        segmentioItems = content
        segmentioStyle = style
        
        selectedLayer?.removeFromSuperlayer()
        indicatorLayer?.removeFromSuperlayer()
        
        if let options = options {
            segmentioOptions = options
            segmentioCollectionView?.scrollEnabled = segmentioOptions.scrollEnabled
            backgroundColor = options.backgroundColor
        }
        
        if segmentioOptions.states.selectedState.backgroundColor != UIColor.clearColor() {
            selectedLayer = CAShapeLayer()
            if let selectedLayer = selectedLayer, sublayer = segmentioCollectionView?.layer {
                setupShapeLayer(
                    shapeLayer: selectedLayer,
                    backgroundColor: segmentioOptions.states.selectedState.backgroundColor,
                    height: bounds.height,
                    sublayer: sublayer
                )
            }
        }
        
        if let indicatorOptions = segmentioOptions.indicatorOptions {
            indicatorLayer = CAShapeLayer()
            if let indicatorLayer = indicatorLayer {
                setupShapeLayer(
                    shapeLayer: indicatorLayer,
                    backgroundColor: indicatorOptions.color,
                    height: indicatorOptions.height,
                    sublayer: layer
                )
            }
        }
        
        setupHorizontalSeparatorIfPossible()
        setupCellWithStyle(segmentioStyle)
        segmentioCollectionView?.reloadData()
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupHorizontalSeparatorIfPossible()
    }
    
    public func setupBadgeAtIndex(index: Int, count: Int, color: UIColor) {
        segmentioItems[index].setupBadgeWithCount(count)
        segmentioCollectionView?.reloadData()
    }
    
    // MARK: Collection view setup
    
    private func setupCellWithStyle(style: SegmentioStyle) {
        var cellClass: SegmentioCell.Type {
            switch style {
            case .OnlyLabel:
                return SegmentioCellWithLabel.self
            case .OnlyImage:
                return SegmentioCellWithImage.self
            case .ImageOverLabel:
                return SegmentioCellWithImageOverLabel.self
            case .ImageUnderLabel:
                return SegmentioCellWithImageUnderLabel.self
            case .ImageBeforeLabel:
                return SegmentioCellWithImageBeforeLabel.self
            case .ImageAfterLabel:
                return SegmentioCellWithImageAfterLabel.self
            }
        }
        
        segmentioCollectionView?.registerClass(
            cellClass,
            forCellWithReuseIdentifier: segmentioStyle.rawValue
        )
        
        segmentioCollectionView?.layoutIfNeeded()
    }
    
    // MARK: Horizontal separators setup
    
    private func setupHorizontalSeparatorIfPossible() {
        if superview != nil && segmentioOptions.horizontalSeparatorOptions != nil {
            setupHorizontalSeparator()
        }
    }
    
    private func setupHorizontalSeparator() {
        topSeparatorView?.removeFromSuperview()
        bottomSeparatorView?.removeFromSuperview()
        
        guard let horizontalSeparatorOptions = segmentioOptions.horizontalSeparatorOptions else {
            return
        }
        
        let height = horizontalSeparatorOptions.height
        let type = horizontalSeparatorOptions.type
        
        if type == .Top || type == .TopAndBottom {
            topSeparatorView = UIView(frame: CGRectZero)
            setupConstraintsForSeparatorView(
                separatorView: topSeparatorView,
                originY: 0
            )
        }
        
        if type == .Bottom || type == .TopAndBottom {
            bottomSeparatorView = UIView(frame: CGRectZero)
            setupConstraintsForSeparatorView(
                separatorView: bottomSeparatorView,
                originY: frame.maxY - height
            )
        }
    }
    
    private func setupConstraintsForSeparatorView(separatorView separatorView: UIView?, originY: CGFloat) {
        guard let horizontalSeparatorOptions = segmentioOptions.horizontalSeparatorOptions, separatorView = separatorView else {
            return
        }
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = horizontalSeparatorOptions.color
        addSubview(separatorView)
        
        let topConstraint = NSLayoutConstraint(
            item: separatorView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: superview,
            attribute: .Top,
            multiplier: 1,
            constant: originY
        )
        topConstraint.active = true
        
        let leadingConstraint = NSLayoutConstraint(
            item: separatorView,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Leading,
            multiplier: 1,
            constant: 0
        )
        leadingConstraint.active = true
        
        let trailingConstraint = NSLayoutConstraint(
            item: separatorView,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Trailing,
            multiplier: 1,
            constant: 0
        )
        trailingConstraint.active = true
        
        let heightConstraint = NSLayoutConstraint(
            item: separatorView,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1,
            constant: horizontalSeparatorOptions.height
        )
        heightConstraint.active = true
    }
    
    // MARK: CAShapeLayers setup

    private func setupShapeLayer(shapeLayer shapeLayer: CAShapeLayer, backgroundColor: UIColor, height: CGFloat, sublayer: CALayer) {
        shapeLayer.fillColor = backgroundColor.CGColor
        shapeLayer.strokeColor = backgroundColor.CGColor
        shapeLayer.lineWidth = height
        layer.insertSublayer(shapeLayer, below: sublayer)
    }
    
    // MARK: - Actions:
    // MARK: Reload segmentio
    private func reloadSegmentio() {
        segmentioCollectionView?.reloadData()
        scrollToItemAtContext()
        moveShapeLayerAtContext()
    }

    // MARK: Move shape layer to item
    
    private func moveShapeLayerAtContext() {
        if let indicatorLayer = indicatorLayer, let options = segmentioOptions.indicatorOptions {
            let item = itemInSuperview(ratio: options.ratio)
            let context = contextForItem(item)
            
            let points = Points(
                context: context,
                item: item,
                pointY: indicatorPointY()
            )
            
            moveShapeLayer(
                indicatorLayer,
                startPoint: points.startPoint,
                endPoint: points.endPoint,
                animated: true
            )
        }
        
        if let selectedLayer = selectedLayer {
            let item = itemInSuperview()
            let context = contextForItem(item)
            
            let points = Points(
                context: context,
                item: item,
                pointY: bounds.midY
            )
            
            moveShapeLayer(
                selectedLayer,
                startPoint: points.startPoint,
                endPoint: points.endPoint,
                animated: true
            )
        }
    }
    
    // MARK: Scroll to item
    
    private func scrollToItemAtContext() {
        guard let numberOfSections = segmentioCollectionView?.numberOfSections() else {
            return
        }
        
        let item = itemInSuperview()
        let context = contextForItem(item)
        
        if context.isLastOrPrelastVisibleCell == true {
            let newIndex = selectedSegmentioIndex + (context.isLastCell ? 0 : 1)
            let newIndexPath = NSIndexPath(forItem: newIndex, inSection: numberOfSections - 1)
            segmentioCollectionView?.scrollToItemAtIndexPath(
                newIndexPath,
                atScrollPosition: .None,
                animated: true
            )
        }
        
        if context.isFirstOrSecondVisibleCell == true {
            let newIndex = selectedSegmentioIndex - (context.isFirstIndex ? 1 : 0)
            let newIndexPath = NSIndexPath(forItem: newIndex, inSection: numberOfSections - 1)
            segmentioCollectionView?.scrollToItemAtIndexPath(
                newIndexPath,
                atScrollPosition: .None,
                animated: true
            )
        }
    }
    
    // MARK: Move shape layer
    
    private func moveShapeLayer(shapeLayer: CAShapeLayer, startPoint: CGPoint, endPoint: CGPoint, animated: Bool = false) {
        var endPointWithVerticalSeparator = endPoint
        let isLastItem = selectedSegmentioIndex + 1 == segmentioItems.count
        endPointWithVerticalSeparator.x = endPoint.x - (isLastItem ? 0 : 1)
        
        let shapeLayerPath = UIBezierPath()
        shapeLayerPath.moveToPoint(startPoint)
        shapeLayerPath.addLineToPoint(endPointWithVerticalSeparator)
        
        if animated == true {
            isPerformingScrollAnimation = true
            userInteractionEnabled = false
            
            CATransaction.begin()
            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = shapeLayer.path
            animation.toValue = shapeLayerPath.CGPath
            animation.duration = animationDuration
            CATransaction.setCompletionBlock() {
                self.isPerformingScrollAnimation = false
                self.userInteractionEnabled = true
            }
            shapeLayer.addAnimation(animation, forKey: "path")
            CATransaction.commit()
        }
        
        shapeLayer.path = shapeLayerPath.CGPath
    }
    
    // MARK: - Context for item
    
    private func contextForItem(item: ItemInSuperview) -> Context {
        let cellFrame = item.cellFrameInSuperview
        let cellWidth = cellFrame.width
        let lastCellMinX = floor(item.collectionViewWidth - cellWidth)
        let minX = floor(cellFrame.minX)
        let maxX = floor(cellFrame.maxX)
        
        let isLastVisibleCell = maxX >= item.collectionViewWidth
        let isLastVisibleCellButOne = minX < lastCellMinX && maxX > lastCellMinX
        
        let isFirstVisibleCell = minX <= 0
        let isNextAfterFirstVisibleCell = minX < cellWidth && maxX > cellWidth
        
        return Context(
            isFirstCell: selectedSegmentioIndex == 0,
            isLastCell: selectedSegmentioIndex == segmentioItems.count - 1,
            isLastOrPrelastVisibleCell: isLastVisibleCell || isLastVisibleCellButOne,
            isFirstOrSecondVisibleCell: isFirstVisibleCell || isNextAfterFirstVisibleCell,
            isFirstIndex: selectedSegmentioIndex > 0
        )
    }
    
    // MARK: - Item in superview
    
    private func itemInSuperview(ratio ratio: CGFloat = 1) -> ItemInSuperview {
        var collectionViewWidth: CGFloat = 0
        var cellWidth: CGFloat = 0
        var cellRect = CGRectZero
        var shapeLayerWidth: CGFloat = 0
        
        if let collectionView = segmentioCollectionView {
            collectionViewWidth = collectionView.frame.width
            let maxVisibleItems = segmentioOptions.maxVisibleItems > segmentioItems.count ? CGFloat(segmentioItems.count) : CGFloat(segmentioOptions.maxVisibleItems)
            cellWidth = floor(collectionViewWidth / maxVisibleItems)
            
            cellRect = CGRect(
                x: floor(CGFloat(selectedSegmentioIndex) * cellWidth - collectionView.contentOffset.x),
                y: 0,
                width: floor(collectionViewWidth / maxVisibleItems),
                height: collectionView.frame.height
            )
            
            shapeLayerWidth = floor(cellWidth * ratio)
        }
        
        return ItemInSuperview(
            collectionViewWidth: collectionViewWidth,
            cellFrameInSuperview: cellRect,
            shapeLayerWidth: shapeLayerWidth,
            startX: floor(cellRect.midX - (shapeLayerWidth / 2)),
            endX: floor(cellRect.midX + (shapeLayerWidth / 2))
        )
    }
    
    // MARK: - Indicator point Y
    
    private func indicatorPointY() -> CGFloat {
        var indicatorPointY: CGFloat = 0
        
        guard let indicatorOptions = segmentioOptions.indicatorOptions else {
            return indicatorPointY
        }
        
        switch indicatorOptions.type {
        case .Top:
            indicatorPointY = (indicatorOptions.height / 2)
        case .Bottom:
            indicatorPointY = frame.height - (indicatorOptions.height / 2)
        }
        
        guard let horizontalSeparatorOptions = segmentioOptions.horizontalSeparatorOptions else {
            return indicatorPointY
        }
        
        let separatorHeight = horizontalSeparatorOptions.height
        let isIndicatorTop = indicatorOptions.type == .Top
        
        switch horizontalSeparatorOptions.type {
        case .Top:
            indicatorPointY = isIndicatorTop ? indicatorPointY + separatorHeight : indicatorPointY
        case .Bottom:
            indicatorPointY = isIndicatorTop ? indicatorPointY : indicatorPointY - separatorHeight
        case .TopAndBottom:
            indicatorPointY = isIndicatorTop ? indicatorPointY + separatorHeight : indicatorPointY - separatorHeight
        }
        
        return indicatorPointY
    }
}

// MARK: - UICollectionViewDataSource

extension Segmentio: UICollectionViewDataSource {
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentioItems.count ?? 0
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            segmentioStyle.rawValue,
            forIndexPath: indexPath) as! SegmentioCell
        
        cell.configure(
            content: segmentioItems[indexPath.row],
            style: segmentioStyle,
            options: segmentioOptions,
            isLastCell: indexPath.row == segmentioItems.count - 1
        )
        
        cell.configure(selected: (indexPath.row == selectedSegmentioIndex))
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension Segmentio: UICollectionViewDelegate {
    
    public func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedSegmentioIndex = indexPath.row
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension Segmentio: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let maxVisibleItems = segmentioOptions.maxVisibleItems > segmentioItems.count ? CGFloat(segmentioItems.count) : CGFloat(segmentioOptions.maxVisibleItems)
        return CGSize(
            width: floor(collectionView.frame.width / maxVisibleItems),
            height: collectionView.frame.height
        )
    }
    
}

// MARK: - UIScrollViewDelegate

extension Segmentio: UIScrollViewDelegate {

    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if isPerformingScrollAnimation == true {
            return
        }
        
        if let options = segmentioOptions.indicatorOptions, indicatorLayer = indicatorLayer {
            let item = itemInSuperview(ratio: options.ratio)
            moveShapeLayer(
                indicatorLayer,
                startPoint: CGPointMake(item.startX, indicatorPointY()),
                endPoint: CGPointMake(item.endX, indicatorPointY()),
                animated: false
            )
        }
        
        if let selectedLayer = selectedLayer {
            let item = itemInSuperview()
            moveShapeLayer(
                selectedLayer,
                startPoint: CGPoint(x: item.startX, y: bounds.midY),
                endPoint: CGPoint(x: item.endX, y: bounds.midY),
                animated: false
            )
        }
    }
    
}

extension Segmentio.Points {
    
    init(context: Segmentio.Context, item: Segmentio.ItemInSuperview, pointY: CGFloat) {
        let cellWidth = item.cellFrameInSuperview.width
        
        var startX = item.startX
        var endX = item.endX
        
        if context.isFirstCell == false && context.isLastCell == false {
            if context.isLastOrPrelastVisibleCell == true {
                let updatedStartX = item.collectionViewWidth - (cellWidth * 2) + ((cellWidth - item.shapeLayerWidth) / 2)
                startX = updatedStartX
                let updatedEndX = updatedStartX + item.shapeLayerWidth
                endX = updatedEndX
            }
            
            if context.isFirstOrSecondVisibleCell == true {
                let updatedEndX = (cellWidth * 2) - ((cellWidth - item.shapeLayerWidth) / 2)
                endX = updatedEndX
                let updatedStartX = updatedEndX - item.shapeLayerWidth
                startX = updatedStartX
            }
        }
        
        if context.isFirstCell == true {
            startX = (cellWidth - item.shapeLayerWidth) / 2
            endX = startX + item.shapeLayerWidth
        }
        
        if context.isLastCell == true {
            startX = item.collectionViewWidth - cellWidth + (cellWidth - item.shapeLayerWidth) / 2
            endX = startX + item.shapeLayerWidth
        }
        
        startPoint = CGPoint(x: startX, y: pointY)
        endPoint = CGPoint(x: endX, y: pointY)
    }
    
}