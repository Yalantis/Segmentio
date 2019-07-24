//
//  Segmentio.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit
import QuartzCore

public typealias SegmentioSelectionCallback = ((_ segmentio: Segmentio, _ selectedSegmentioIndex: Int) -> Void)

open class Segmentio: UIView {
    
    internal struct Points {
        var startPoint: CGPoint
        var endPoint: CGPoint
    }
    
    internal struct ItemInSuperview {
        var collectionViewWidth: CGFloat
        var cellFrameInSuperview: CGRect
        var shapeLayerWidth: CGFloat
        var startX: CGFloat
        var endX: CGFloat
    }
    
    open var valueDidChange: SegmentioSelectionCallback?
    open var selectedSegmentioIndex = -1 {
        didSet {
            if selectedSegmentioIndex != oldValue {
                reloadSegmentio()
                valueDidChange?(self, selectedSegmentioIndex)
            }
        }
    }

    open private(set) var segmentioItems = [SegmentioItem]()
    private var segmentioCollectionView: UICollectionView?
    private var segmentioOptions = SegmentioOptions()
    private var segmentioStyle = SegmentioStyle.imageOverLabel
    private var isPerformingScrollAnimation = false
    private var isCollectionViewScrolling = false
    private var didScrollToSelectedItem = false
    
    private var topSeparatorView: UIView?
    private var bottomSeparatorView: UIView?
    private var indicatorLayer: CAShapeLayer?
    private var selectedLayer: CAShapeLayer?
    
    private var isRTL: Bool {
        if #available(iOS 9.0, *) {
            return UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
        } else {
            return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
        }
    }
    private var isFlipped = false
    
    // MARK: - Lifecycle
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        reloadSegmentio()
    }
    
    private func commonInit() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(
            frame: frameForSegmentCollectionView(),
            collectionViewLayout: layout
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = true
        collectionView.isScrollEnabled = segmentioOptions.scrollEnabled
        collectionView.backgroundColor = .clear
        collectionView.accessibilityIdentifier = "segmentio_collection_view"
        
        segmentioCollectionView = collectionView
        
        if let segmentioCollectionView = segmentioCollectionView {
            addSubview(segmentioCollectionView, options: .overlay)
        }
    }
    
    private func frameForSegmentCollectionView() -> CGRect {
        var separatorsHeight: CGFloat = 0
        var collectionViewFrameMinY: CGFloat = 0
        
        if let horizontalSeparatorOptions = segmentioOptions.horizontalSeparatorOptions {
            let separatorHeight = horizontalSeparatorOptions.height
            
            switch horizontalSeparatorOptions.type {
            case .none:
                separatorsHeight = 0
            case .top:
                collectionViewFrameMinY = separatorHeight
                separatorsHeight = separatorHeight
            case .bottom:
                separatorsHeight = separatorHeight
            case .topAndBottom:
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
    
    // MARK: - Setups:
    // MARK: Main setup
    
    open func setup(content: [SegmentioItem], style: SegmentioStyle, options: SegmentioOptions?) {
        segmentioItems = content
        segmentioStyle = style
        
        selectedLayer?.removeFromSuperlayer()
        indicatorLayer?.removeFromSuperlayer()
        
        if let options = options {
            segmentioOptions = options
            segmentioCollectionView?.isScrollEnabled = segmentioOptions.scrollEnabled
            backgroundColor = options.backgroundColor
        }
        
        if segmentioOptions.states.selectedState.backgroundColor != .clear {
            selectedLayer = CAShapeLayer()
            if let selectedLayer = selectedLayer, let sublayer = segmentioCollectionView?.layer {
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
        
        checkForRTLAndFlipIfNeeded()
        setupHorizontalSeparatorIfPossible()
        setupCellWithStyle(segmentioStyle)
        segmentioCollectionView?.reloadData()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupHorizontalSeparatorIfPossible()
    }
    
    open func addBadge(at index: Int, count: Int, color: UIColor = .red) {
        segmentioItems[index].addBadge(count, color: color)
        segmentioCollectionView?.reloadData()
    }
    
    open func removeBadge(at index: Int) {
        segmentioItems[index].removeBadge()
        segmentioCollectionView?.reloadData()
    }
    
    // MARK: Collection view setup
    
    private func setupCellWithStyle(_ style: SegmentioStyle) {
        var cellClass: SegmentioCell.Type {
            switch style {
            case .onlyLabel:
                return SegmentioCellWithLabel.self
            case .onlyImage:
                return SegmentioCellWithImage.self
            case .imageOverLabel:
                return SegmentioCellWithImageOverLabel.self
            case .imageUnderLabel:
                return SegmentioCellWithImageUnderLabel.self
            case .imageBeforeLabel:
                return SegmentioCellWithImageBeforeLabel.self
            case .imageAfterLabel:
                return SegmentioCellWithImageAfterLabel.self
            }
        }
        
        segmentioCollectionView?.register(
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
        
        if type == .top || type == .topAndBottom {
            topSeparatorView = UIView(frame: CGRect.zero)
            setupConstraintsForSeparatorView(
                separatorView: topSeparatorView,
                originY: 0
            )
        }
        
        if type == .bottom || type == .topAndBottom {
            bottomSeparatorView = UIView(frame: CGRect.zero)
            setupConstraintsForSeparatorView(
                separatorView: bottomSeparatorView,
                originY: bounds.maxY - height
            )
        }
    }
    
    private func setupConstraintsForSeparatorView(separatorView: UIView?, originY: CGFloat) {
        guard let horizontalSeparatorOptions = segmentioOptions.horizontalSeparatorOptions,
            let separatorView = separatorView else {
            return
        }
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = horizontalSeparatorOptions.color
        addSubview(separatorView)
        
        let topConstraint = NSLayoutConstraint(
            item: separatorView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: originY
        )
        topConstraint.isActive = true
        
        let leadingConstraint = NSLayoutConstraint(
            item: separatorView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1,
            constant: 0
        )
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(
            item: separatorView,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1,
            constant: 0
        )
        trailingConstraint.isActive = true
        
        let heightConstraint = NSLayoutConstraint(
            item: separatorView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: horizontalSeparatorOptions.height
        )
        heightConstraint.isActive = true
    }
    
    // MARK: CAShapeLayers setup

    private func setupShapeLayer(shapeLayer: CAShapeLayer, backgroundColor: UIColor, height: CGFloat,
                                     sublayer: CALayer) {
        shapeLayer.fillColor = backgroundColor.cgColor
        shapeLayer.strokeColor = backgroundColor.cgColor
        shapeLayer.lineWidth = height
        layer.insertSublayer(shapeLayer, below: sublayer)
    }
    
    // MARK: - Actions:
    // MARK: Reload segmentio
    public func reloadSegmentio() {
        didScrollToSelectedItem = false
        segmentioCollectionView?.collectionViewLayout.invalidateLayout()
        segmentioCollectionView?.reloadData()
        guard selectedSegmentioIndex != -1 else { return }
        moveShapeLayerAtContext()
    }

    // MARK: Move shape layer to item
    
    private func moveShapeLayerAtContext() {
        let itemWitdh = segmentioItems.enumerated().map { (index, _) -> CGFloat in
            return segmentWidth(for: IndexPath(item: index, section: 0))
        }

        var superviewInsets: UIEdgeInsets = .zero
        if #available(iOS 11.0, *) {
            superviewInsets = segmentioCollectionView?.superview?.safeAreaInsets ?? .zero
        }
        
        let isCommonBehaviour = (isFlipped && isRTL) || (!isFlipped && !isRTL)
        
        if let indicatorLayer = indicatorLayer, let options = segmentioOptions.indicatorOptions {
            let item = itemInSuperview(ratio: options.ratio)

            let points = Points(
                item: item,
                atIndex: selectedSegmentioIndex,
                allItemsCellWidth: itemWitdh,
                pointY: indicatorPointY(),
                position: segmentioOptions.segmentPosition,
                style: segmentioStyle,
                insets: superviewInsets,
                isCommonBehaviour: isCommonBehaviour
            )
            let insetX = ((points.endPoint.x - points.startPoint.x) - (item.endX - item.startX))/2
            moveShapeLayer(
                indicatorLayer,
                startPoint: CGPoint(x: points.startPoint.x + insetX, y: points.startPoint.y),
                endPoint: CGPoint(x: points.endPoint.x - insetX, y: points.endPoint.y),
                animated: true
            )
        }
        
        if let selectedLayer = selectedLayer {
            let item = itemInSuperview()

            let points = Points(
                item: item,
                atIndex: selectedSegmentioIndex,
                allItemsCellWidth: itemWitdh,
                pointY: bounds.midY,
                position: segmentioOptions.segmentPosition,
                style: segmentioStyle,
                insets: superviewInsets,
                isCommonBehaviour: isCommonBehaviour
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
        guard selectedSegmentioIndex != -1 else {
            return
        }
        
        let item = itemInSuperview()
        segmentioCollectionView?.scrollRectToVisible(centerRect(for: item), animated: true)
    }

    private func centerRect(for item: ItemInSuperview) -> CGRect {
        guard let collectionView = segmentioCollectionView else {
            fatalError("segmentioCollectionView should exist")
        }
        
        let item = itemInSuperview()
        var centerRect = item.cellFrameInSuperview
        
        if (item.startX + collectionView.contentOffset.x) - (item.collectionViewWidth - centerRect.width) / 2 < 0 {
            centerRect.origin.x = 0
            let widthToAdd = item.collectionViewWidth - centerRect.width
            centerRect.size.width += widthToAdd
        } else if collectionView.contentSize.width - item.endX < (item.collectionViewWidth - centerRect.width) / 2 {
            centerRect.origin.x = collectionView.contentSize.width - item.collectionViewWidth
            centerRect.size.width = item.collectionViewWidth
        } else {
            centerRect.origin.x = item.startX - (item.collectionViewWidth - centerRect.width) / 2
                + collectionView.contentOffset.x
            centerRect.size.width = item.collectionViewWidth
        }
        
        return centerRect
    }
    
    // MARK: Move shape layer
    
    private func moveShapeLayer(_ shapeLayer: CAShapeLayer, startPoint: CGPoint, endPoint: CGPoint,
                                    animated: Bool = false) {
        var endPointWithVerticalSeparator = endPoint
        let isLastItem = selectedSegmentioIndex + 1 == segmentioItems.count
        endPointWithVerticalSeparator.x = endPoint.x - (isLastItem ? 0 : 1)
        
        let shapeLayerPath = UIBezierPath()
        shapeLayerPath.move(to: startPoint)
        shapeLayerPath.addLine(to: endPointWithVerticalSeparator)
        
        if animated == true {
            isPerformingScrollAnimation = true
            isUserInteractionEnabled = false
            
            CATransaction.begin()
            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = shapeLayer.path
            animation.toValue = shapeLayerPath.cgPath
            animation.duration = segmentioOptions.animationDuration
            CATransaction.setCompletionBlock() {
                self.isPerformingScrollAnimation = false
                self.isUserInteractionEnabled = true
            }
            shapeLayer.add(animation, forKey: "path")
            CATransaction.commit()
        }
        
        shapeLayer.path = shapeLayerPath.cgPath
    }
    
    // MARK: - Item in superview
    
    private func itemInSuperview(ratio: CGFloat = 1) -> ItemInSuperview {
        var collectionViewWidth: CGFloat = 0
        var cellWidth: CGFloat = 0
        var cellRect = CGRect.zero
        var shapeLayerWidth: CGFloat = 0
        
        if let collectionView = segmentioCollectionView, selectedSegmentioIndex != -1,
            let cellAttributes = collectionView.layoutAttributesForItem(at: IndexPath(row: selectedSegmentioIndex, section: 0)) {
            cellWidth = segmentWidth(for: IndexPath(row: selectedSegmentioIndex, section: 0))
            collectionViewWidth = collectionView.frame.width
            
            let cellFrameInSuperview = collectionView.convert(cellAttributes.frame, to: collectionView.superview)
            cellRect = CGRect(
                x: cellFrameInSuperview.minX,
                y: 0,
                width: cellWidth,
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

    // MARK: - Segment Width

    private func segmentWidth(for indexPath: IndexPath) -> CGFloat {
        guard let collectionView = segmentioCollectionView else {
            return 0
        }
        
        var width: CGFloat = 0
        let collectionViewWidth = collectionView.frame.width
        
        switch segmentioOptions.segmentPosition {
        case .fixed(let maxVisibleItems):
            let maxItems = maxVisibleItems > segmentioItems.count ? segmentioItems.count : maxVisibleItems
            width = maxItems == 0 ? 0 : floor(collectionViewWidth / CGFloat(maxItems))
            
        case .dynamic:
            guard !segmentioItems.isEmpty else {
                break
            }
            
            var dynamicWidth: CGFloat = 0
            for item in segmentioItems {
                dynamicWidth += Segmentio.intrinsicWidth(for: item, style: segmentioStyle)
            }
            let itemWidth = Segmentio.intrinsicWidth(for: segmentioItems[indexPath.row], style: segmentioStyle)
            width = dynamicWidth > collectionViewWidth ? itemWidth
                : itemWidth + ((collectionViewWidth - dynamicWidth) / CGFloat(segmentioItems.count))
        }
        
        return width
    }

    private static func intrinsicWidth(for item: SegmentioItem, style: SegmentioStyle) -> CGFloat {
        var itemWidth = style.isWithText() ? item.intrinsicWidth : (item.image?.size.width ?? 0)
        itemWidth += style.layoutMargins
        
        if style == .imageAfterLabel || style == .imageBeforeLabel {
            itemWidth += SegmentioCell.segmentTitleLabelHeight
        }
        
        return itemWidth
    }

    // MARK: - Indicator point Y
    
    private func indicatorPointY() -> CGFloat {
        var indicatorPointY: CGFloat = 0
        
        guard let indicatorOptions = segmentioOptions.indicatorOptions else {
            return indicatorPointY
        }
        
        switch indicatorOptions.type {
        case .top:
            indicatorPointY = (indicatorOptions.height / 2)
        case .bottom:
            indicatorPointY = frame.height - (indicatorOptions.height / 2)
        }
        
        guard let horizontalSeparatorOptions = segmentioOptions.horizontalSeparatorOptions else {
            return indicatorPointY
        }
        
        let separatorHeight = horizontalSeparatorOptions.height
        let isIndicatorTop = indicatorOptions.type == .top
        
        switch horizontalSeparatorOptions.type {
        case .none:
            break
        case .top:
            indicatorPointY = isIndicatorTop ? indicatorPointY + separatorHeight : indicatorPointY
        case .bottom:
            indicatorPointY = isIndicatorTop ? indicatorPointY : indicatorPointY - separatorHeight
        case .topAndBottom:
            indicatorPointY = isIndicatorTop ? indicatorPointY + separatorHeight : indicatorPointY - separatorHeight
        }
        
        return indicatorPointY
    }
    
    private func checkForRTLAndFlipIfNeeded() {
        var isDynamicPosition = false
        if case .dynamic = segmentioOptions.segmentPosition {
            isDynamicPosition = true
        }
        if isRTL && isDynamicPosition {
            transform = CGAffineTransform(scaleX: -1, y: 1)
            isFlipped = true
        }
    }
}

// MARK: - UICollectionViewDataSource

extension Segmentio: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentioItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: segmentioStyle.rawValue,
            for: indexPath) as! SegmentioCell
        
        let content = segmentioItems[indexPath.row]
        
        cell.configure(
            content: content,
            style: segmentioStyle,
            options: segmentioOptions,
            isLastCell: indexPath.row == segmentioItems.count - 1
        )
        
        cell.configure(
            selected: (indexPath.row == selectedSegmentioIndex),
            selectedImage: content.selectedImage,
            image: content.image
        )
        
        if isFlipped {
            cell.contentView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension Segmentio: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSegmentioIndex = indexPath.row
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !didScrollToSelectedItem {
            scrollToItemAtContext()
            didScrollToSelectedItem = true
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension Segmentio: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: segmentWidth(for: indexPath), height: collectionView.frame.height)
    }
    
}

// MARK: - UIScrollViewDelegate

extension Segmentio: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isPerformingScrollAnimation {
            return
        }

        if let options = segmentioOptions.indicatorOptions, let indicatorLayer = indicatorLayer {
            let item = itemInSuperview(ratio: options.ratio)
            moveShapeLayer(
                indicatorLayer,
                startPoint: CGPoint(x: item.startX, y: indicatorPointY()),
                endPoint: CGPoint(x: item.endX, y: indicatorPointY()),
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

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isCollectionViewScrolling = false
    }
    
}

extension Segmentio.Points {
    
    init(item: Segmentio.ItemInSuperview, atIndex index: Int, allItemsCellWidth: [CGFloat], pointY: CGFloat, position: SegmentioPosition, style: SegmentioStyle, insets: UIEdgeInsets, isCommonBehaviour: Bool) {
        let cellWidth = item.cellFrameInSuperview.width
        var startX = item.startX
        var endX = item.endX
        var spaceBefore: CGFloat = isCommonBehaviour ? insets.left : -insets.right
        var spaceAfter: CGFloat = isCommonBehaviour ? -insets.right : insets.left
        var i = 0
        allItemsCellWidth.forEach { width in
            if i < index { spaceBefore += width }
            if i > index { spaceAfter += width }
            i += 1
        }
        // Cell will try to position itself in the middle, unless it can't because
        // the collection view has reached the beginning or end
        startX = (item.collectionViewWidth / 2) - (cellWidth / 2 )
        if spaceBefore < (item.collectionViewWidth - cellWidth) / 2 {
            startX = isCommonBehaviour ? spaceBefore : item.collectionViewWidth - spaceBefore - cellWidth
        }
        if spaceAfter < (item.collectionViewWidth - cellWidth) / 2 {
            startX = isCommonBehaviour ? item.collectionViewWidth - spaceAfter - cellWidth : spaceAfter
        }
        endX = startX + cellWidth
        
        startPoint = CGPoint(x: startX, y: pointY)
        endPoint = CGPoint(x: endX, y: pointY)
    }
    
}
