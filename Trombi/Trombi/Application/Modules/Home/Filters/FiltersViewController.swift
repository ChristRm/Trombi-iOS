//
//  FiltersViewController.swift
//  Trombi
//
//  Created by Christian Rusin on 26/02/2019.
//  Copyright © 2019 Christian Rusin. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

final class FiltersViewController: UIViewController, BottomPanel {

    // MARK: - IBOutlet

    @IBOutlet private weak var filtersCollectionView: UICollectionView?

    @IBOutlet private weak var headerCollectionViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var filtersCollectionViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var bottomViewHeightConstraint: NSLayoutConstraint?

    @IBOutlet private weak var resetButton: UIButton?
    @IBOutlet private weak var applyButton: UIButton?

    // MARK: - Bottom panel
    var panelIdentifier: String?
    
    var widthOfPanel: CGFloat = 375.0
    var heightOfPanel: CGFloat {
        guard let headerCollectionViewHeightConstraint = headerCollectionViewHeightConstraint else {
            fatalError("headerCollectionViewHeightConstraint is nil")
        }

        let screenHeight = UIScreen.main.bounds.height
        let headerCollectionViewHeight = headerCollectionViewHeightConstraint.constant
        let collectionViewHeight = screenHeight * 420.0/812.0 - headerCollectionViewHeight
        let bottomViewHeight: CGFloat = 70.0

        filtersCollectionViewHeightConstraint?.constant = collectionViewHeight
        bottomViewHeightConstraint?.constant = bottomViewHeight

        return collectionViewHeight + bottomViewHeight + headerCollectionViewHeight
    }
    
    weak var bottomPanelDelegate: BottomPanelDelegate?
    
    // MARK: - ViewModel
    var viewModel: FiltersViewViewModelInterface?

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()
    
    private let filtersCollectionViewDataSource: RxCollectionViewSectionedReloadDataSource<FiltersSection> = {
        let dataSource =
            RxCollectionViewSectionedReloadDataSource<FiltersSection>(configureCell: { (_, collectionView, indexPath, cellModel)
                -> UICollectionViewCell in
                
                // to select items from model
                if cellModel.selected {
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                } else {
                    collectionView.deselectItem(at: indexPath, animated: false)
                }
                
                switch cellModel.type {
                case .newcomers:
                    let otherTagCell: OtherTagCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    otherTagCell.titleLabel?.text = cellModel.title
                    otherTagCell.isSelected = cellModel.selected
                    
                    return otherTagCell
                case .team:
                    let teamCell: TeamTagCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    
                    teamCell.titleLabel?.text = cellModel.title
                    teamCell.isSelected = cellModel.selected
                    
                    return teamCell
                }
            })
        
        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let reusableHeader =
                    collectionView.dequeueReusableSupplementaryView(
                        ofKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: "FiltersCollectionViewHeader",
                        for: indexPath
                )
                
                guard let descriptionLabel = reusableHeader.viewWithTag(1) as? UILabel else {
                    fatalError("could not find description label")
                }
                
                descriptionLabel.text = dataSource.sectionModels[indexPath.section].header
                
                return reusableHeader
                
            default: fatalError("Unexpected element kind")
            }
        }
        
        return dataSource
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFiltersCollectionView()
        if let viewModel = viewModel {
            bindViewModel(viewModel)
        }
    }

    // MARK: - binding ViewModel
    private func bindViewModel(_ viewModel: FiltersViewViewModelInterface) {
        
        guard let resetButton = resetButton else { print("Reset button is not set up") ; return }
        
        guard let applyButton = applyButton else { print("Apply button is not set up") ; return }
        
        guard let filtersCollectionView = filtersCollectionView else {
            print("Filters collection view is not set up") ; return
        }
        
        viewModel.filtered.drive(resetButton.rx.isSelected).disposed(by: disposeBag)
        
        resetButton.rx.controlEvent(.touchUpInside).bind { [weak self] in
            self?.viewModel?.resetFilters.accept(Void())
        }.disposed(by: disposeBag)
        
        applyButton.rx.controlEvent(.touchUpInside).bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)

        viewModel.filtersSections.drive(
            filtersCollectionView.rx.items(dataSource: filtersCollectionViewDataSource)
        ).disposed(by: disposeBag)
        
        filtersCollectionView.rx.modelSelected(FilterTagCellModel.self).map({ tag -> FilterTagCellModel in
            var newTag = tag
            newTag.selected = true
            return newTag
        }).bind(to: viewModel.lastUpdatedTagCell).disposed(by: disposeBag)
        
        filtersCollectionView.rx.modelDeselected(FilterTagCellModel.self).map({ tag -> FilterTagCellModel in
            var newTag = tag
            newTag.selected = false
            return newTag
        }).bind(to: viewModel.lastUpdatedTagCell).disposed(by: disposeBag)
    }

    // MARK: - Private methods

    private func configureFiltersCollectionView() {
        filtersCollectionView?.allowsSelection = true
        filtersCollectionView?.allowsMultipleSelection = true

        filtersCollectionView?.register(UINib(nibName: "FiltersCollectionViewHeader", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "FiltersCollectionViewHeader")

        filtersCollectionView?.registerReusableCell(type: OtherTagCollectionViewCell.self)
        filtersCollectionView?.registerReusableCell(type: TeamTagCollectionViewCell.self)

        let tagCellLayout = TagCellLayout(alignment: .left, delegate: self)
        filtersCollectionView?.collectionViewLayout = tagCellLayout
    }
}

extension FiltersViewController: TagCellLayoutDelegate {
    func tagCellLayoutTagSize(layout: TagCellLayout, at indexPath: IndexPath) -> CGSize {
        let tagModel = filtersCollectionViewDataSource.sectionModels[indexPath.section].items[indexPath.row]
        var width: CGFloat = min(calculateWidthOfText(tagModel.title), maximumTagWidth)
        width = max(minimumTagWidth, width)

        return CGSize(width: width, height: 50.0)
    }

    func tagCellLayout(layout: TagCellLayout, heightForHeaderAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }

    func tagCellLayoutInteritemHorizontalSpacing(layout: TagCellLayout) -> CGFloat {
        return 10.0
    }

    func tagCellLayoutInteritemVerticalSpacing(layout: TagCellLayout) -> CGFloat {
        return 10.0
    }

    var minimumTagWidth: CGFloat {
        return widthOfPanel * (64.0/375.0)
    }

    var maximumTagWidth: CGFloat {
        return widthOfPanel * (175.0/375.0)
    }

    private func calculateWidthOfText(_ text: String) -> CGFloat {
        guard text != "" else { return 0.0 }
        let labelOffset: CGFloat = 30.0
        let label: UILabel = UILabel(frame: CGRect(x: 0.0,
                                                   y: 0.0,
                                                   width: CGFloat.greatestFiniteMagnitude,
                                                   height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.boldAppFontOf(size: 15.0)
        label.text = text

        label.sizeToFit()

        return label.frame.width + labelOffset
    }
}
