//
//  TagCellLayout.swift
//  TagCellLayout
//
//  Created by Ritesh-Gupta on 20/11/15.
//  Copyright © 2015 Ritesh. All rights reserved.
//

import Foundation
import UIKit

public class TagCellLayout: UICollectionViewLayout {
	
	let alignment: LayoutAlignment

	var layoutInfoList: [LayoutInfo] = []

    var headersLayoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]

    func layoutInfo(forItemAt indexPath: IndexPath) -> LayoutInfo? {
        return layoutInfoList.filter({ $0.indexPath == indexPath }).first
    }

    func setLayoutInfo(_ layoutInfo: LayoutInfo, forItemAt indexPath: IndexPath) {
        if let index = layoutInfoList.firstIndex(where: { $0.indexPath == indexPath }) {
            layoutInfoList.remove(at: index)
            layoutInfoList.append(layoutInfo)
        }
    }

	weak var delegate: TagCellLayoutDelegate?
	
	// MARK: - Init Methods
	
	public init(alignment: LayoutAlignment = .left, delegate: TagCellLayoutDelegate?) {
		self.delegate = delegate
		self.alignment = alignment
		super.init()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		alignment = .left
		super.init(coder: aDecoder)
	}
	
	override convenience init() {
		self.init(delegate: nil)
	}
	
	// MARK: - UICollectionViewLayout override Methods
	
	override public func prepare() {
		resetLayoutState()
		setupTagCellLayout()
	}

	public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		guard layoutInfoList.count > indexPath.row else { return nil }
		return layoutInfoList[indexPath.row].layoutAttribute
	}
	
	override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard !layoutInfoList.isEmpty else { return nil }
        
		var attributes =  layoutInfoList.compactMap({ $0.layoutAttribute })
        attributes += headersLayoutAttributes.values

		return attributes.filter { rect.intersects($0.frame) }
	}
	
	override public var collectionViewContentSize: CGSize {
		let width = collectionViewWidth
		var height = layoutInfoList
            .filter { $0.isFirstElementInLayoutRow }
			.reduce(0, { $0 + $1.layoutAttribute.frame.height +
                (delegate?.tagCellLayoutInteritemVerticalSpacing(layout: self) ?? 0.0) })
        let numberOfSections: CGFloat = CGFloat(collectionView?.numberOfSections ?? 0)
        
        height += numberOfSections * (delegate?.tagCellLayout(layout: self,
                                                              heightForHeaderAt: IndexPath(row: 0, section: 0)) ?? 0.0)
		return CGSize(width: width, height: height)
	}

    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                                              at indexPath: IndexPath) ->
        UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return headersLayoutAttributes[indexPath]

        default:
            return nil
        }
    }
}

// MARK: - Private Methods

private extension TagCellLayout {

    var sectionsCount: Int {
        return collectionView?.numberOfSections ?? 0
    }

    func tagsCount(in section: Int) -> Int {
        return collectionView?.numberOfItems(inSection: section) ?? 0
    }
	
	var collectionViewWidth: CGFloat {
		return collectionView?.frame.size.width ?? 0
	}

    // MARK: - Layout setup

	func setupTagCellLayout() {
		// delegate and collectionview shouldn't be nil
		guard delegate != nil, collectionView != nil else {
			// otherwise throwing an error
			handleErrorState()
			return
		}
		// basic layout setup which is independent of TagAlignment type
		basicLayoutSetup()
	}

    // MARK: - Basic layout setup

	func basicLayoutSetup() {
		// asking the client for a fixed tag height
		// iterating over every tag and constructing its layout attribute
        (0..<sectionsCount).forEach { section in
            (0..<tagsCount(in: section)).forEach({ row in
                createLayoutAttributes(forTagAt: IndexPath(row: row, section: section))
            })
        }
	}

    // MARK: - Create layout attributes
    func createLayoutAttributes(forTagAt indexPath: IndexPath) {
		// calculating tag-size
        let tagSize = delegate!.tagCellLayoutTagSize(layout: self, at: indexPath)

        if indexPath.row == 0 {
            headersLayoutAttributes[indexPath] = headerCellLayoutInfo(forHeaderAt: indexPath)
        }
        let layoutInfo = tagCellLayoutInfo(forTagAt: indexPath, tagSize: tagSize)
        layoutInfoList.append(layoutInfo)
	}
	
	func tagCellLayoutInfo(forTagAt indexPath: IndexPath, tagSize: CGSize) -> LayoutInfo {
		// local data-structure (TagCellLayoutInfo) that has been used in this library to store attribute and white-space info
        var previousIndexPath: IndexPath
        let firstInSection = indexPath.row == 0
        
        if indexPath.section != 0 && indexPath.row == 0 {
            previousIndexPath =
                IndexPath(row: (collectionView?.numberOfItems(inSection: indexPath.section - 1) ?? 0) - 1,
                          section: indexPath.section - 1)
        } else {
            previousIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        }

        var isFirstElementInLayoutRow: Bool = false

        let previousTagFrame = tagFrame(forTagAt: previousIndexPath)
		var newTagFrame = previousTagFrame
		newTagFrame.size = tagSize
		
		// if next tag goes out of screen then move it to next row
        if shouldMoveTagToNextRow(tagIndexPath: previousIndexPath,
                                  tagWidth: tagSize.width) || firstInSection {
			newTagFrame.origin.y += previousTagFrame.height +
                (delegate?.tagCellLayoutInteritemVerticalSpacing(layout: self) ?? 0.0)
            if firstInSection {
                newTagFrame.origin.y += delegate?.tagCellLayout(layout: self, heightForHeaderAt: indexPath) ?? 0.0
            }

            isFirstElementInLayoutRow = true
		}

        if isFirstElementInLayoutRow {
            newTagFrame.origin.x = (delegate?.tagCellLayoutInteritemHorizontalSpacing(layout: self) ?? 0.0)
        }

		let attribute = createCollectionViewLayoutAttributes(forTagAt: indexPath, tagFrame: newTagFrame)
        let info = LayoutInfo(indexPath: indexPath,
                              layoutAttribute: attribute,
                              isFirstElementInLayoutRow: isFirstElementInLayoutRow)
		return info
	}

    func headerCellLayoutInfo(forHeaderAt indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        // local data-structure (TagCellLayoutInfo) that has been used in this library to store attribute and white-space info

        var headerFrame: CGRect = .zero
        if indexPath.section != 0 {
            let previousIndexPath =
                IndexPath(row: (collectionView?.numberOfItems(inSection: indexPath.section - 1) ?? 0) - 1,
                          section: indexPath.section - 1)

            let previousTagFrame = tagFrame(forTagAt: previousIndexPath)
            headerFrame = previousTagFrame
            headerFrame.origin.y += previousTagFrame.size.height
        }

        headerFrame.origin.x = 0.0
        headerFrame.size = CGSize(width: collectionViewWidth,
                                  height: (delegate?.tagCellLayout(layout: self, heightForHeaderAt: indexPath) ?? 0.0))

        let attribute = createCollectionViewHeaderLayoutAttributes(forHeaderAt: indexPath, headerFrame: headerFrame)

        return attribute
    }

    func shouldMoveTagToNextRow(tagIndexPath: IndexPath, tagWidth: CGFloat) -> Bool {
        let currentTagFrame = tagFrame(forTagAt: tagIndexPath)
        return ((currentTagFrame.origin.x + tagWidth) > collectionViewWidth)
    }

    func createCollectionViewLayoutAttributes(forTagAt indexPath: IndexPath,
                                              tagFrame: CGRect) -> UICollectionViewLayoutAttributes {
        let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        layoutAttribute.frame = tagFrame
        return layoutAttribute
    }
    
    func createCollectionViewHeaderLayoutAttributes(forHeaderAt indexPath: IndexPath,
                                                    headerFrame: CGRect) -> UICollectionViewLayoutAttributes {
        let headerAttribute =
            UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                             with: indexPath)
        headerAttribute.frame = headerFrame
        return headerAttribute
    }
    
	func tagFrame(forTagAt indexPath: IndexPath) -> CGRect {
        var frame: CGRect = .zero
        
        if let info = layoutInfo(forItemAt: indexPath)?.layoutAttribute {
            frame = info.frame
            frame.origin.x += info.bounds.width +
                (delegate?.tagCellLayoutInteritemHorizontalSpacing(layout: self) ?? 0.0)
        }
        return frame
	}
	
	func handleErrorState() {
		print("TagCollectionViewCellLayout is not properly configured")
	}
	
	func resetLayoutState() {
        layoutInfoList = []
	}
}
