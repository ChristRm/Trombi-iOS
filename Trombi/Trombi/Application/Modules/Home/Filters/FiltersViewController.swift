//
//  FiltersViewController.swift
//  Legrand
//
//  Created by Christian Rusin  on 28/08/2018.
//  Copyright © 2018 Netatmo. All rights reserved.
//

import UIKit
import RxSwift

// MARK: - Constants
extension FiltersViewController {
    enum Defaults {
//        static let
    }
}

final class FiltersViewController: UIViewController, BottomPanel {

    // MARK: - ViewModel definition

    // MARK: - IBOutlet

    @IBOutlet private weak var filtersCollectionView: UICollectionView?

    @IBOutlet private weak var headerCollectionViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var filtersCollectionViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var bottomViewHeightConstraint: NSLayoutConstraint?

    // MARK: - DasboardBottomBar
    var panelIdentifier: String?
    
    var widthOfPanel: CGFloat = 375.0
    var heightOfPanel: CGFloat {
        guard let headerCollectionViewHeightConstraint = headerCollectionViewHeightConstraint else {
            fatalError("headerCollectionViewHeightConstraint is nil")
        }

        let screenHeight = UIScreen.main.bounds.height
        let headerCollectionViewHeight = headerCollectionViewHeightConstraint.constant
        let collectionViewHeight = screenHeight * 320.0/812.0 - headerCollectionViewHeight
        let bottomViewHeight: CGFloat = 70.0

        filtersCollectionViewHeightConstraint?.constant = collectionViewHeight
        bottomViewHeightConstraint?.constant = bottomViewHeight

        return collectionViewHeight + bottomViewHeight + headerCollectionViewHeight
    }
    
    weak var bottomPanelDelegate: BottomPanelDelegate?
    
    // MARK: - ViewModel
    var viewModel: FiltersViewViewModel? {
        didSet {
            if let viewModel = viewModel {
                bindViewModel(viewModel)
            }
        }
    }

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFiltersCollectionView()
    }

    // MARK: - IBAction

    @IBAction func doneButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func resetButtonTouched(_ sender: Any) {
        viewModel?.resetFilters()
    }

    // MARK: - binding ViewModel
    private func bindViewModel(_ viewModel: FiltersViewViewModel) {
        viewModel.sectionsTags.drive(onNext: { [weak self] (_) in
            self?.filtersCollectionView?.reloadData()
        }).disposed(by: disposeBag)
    }

    // MARK: - Private methods

    func configureFiltersCollectionView() {
        filtersCollectionView?.delegate = self
        filtersCollectionView?.dataSource = self
        filtersCollectionView?.allowsSelection = true
        filtersCollectionView?.allowsMultipleSelection = true

        filtersCollectionView?.register(UINib(nibName: "FiltersCollectionViewHeader", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "FiltersCollectionViewHeader")

        filtersCollectionView?.registerReusableCell(type: OtherTagCollectionViewCell.self)
        filtersCollectionView?.registerReusableCell(type: DepartmentTagCollectionViewCell.self)

        let tagCellLayout = TagCellLayout(alignment: .left, delegate: self)
        filtersCollectionView?.collectionViewLayout = tagCellLayout
    }
}

// MARK: - UICollectionViewDataSource
extension FiltersViewController: UICollectionViewDataSource {

    // MARK: - Collection View Data Source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(section: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else {
            fatalError("View model is nil but collection view is not empty")
        }

        let tagViewModel = viewModel.viewModelForTag(indexPath)
        switch tagViewModel.type {
        case .other:
            let otherTagCell: OtherTagCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            otherTagCell.titleLabel?.text = tagViewModel.title
            otherTagCell.isSelected = tagViewModel.selected

            if tagViewModel.selected {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            } else {
                collectionView.deselectItem(at: indexPath, animated: false)
            }

            return otherTagCell
        case .department:
            let departmentCell: DepartmentTagCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            departmentCell.titleLabel?.text = tagViewModel.title
            departmentCell.isSelected = tagViewModel.selected

            if tagViewModel.selected {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            } else {
                collectionView.deselectItem(at: indexPath, animated: false)
            }

            return departmentCell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let viewModel = viewModel else {
            fatalError("View model is nil but collection view is not empty")
        }

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reusableHeader =
                collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                withReuseIdentifier: "FiltersCollectionViewHeader",
                                                                for: indexPath)

            guard let descriptionLabel = reusableHeader.viewWithTag(1) as? UILabel else {
                fatalError("could not find description label")
            }

            descriptionLabel.text = viewModel.tagSectionTitles[indexPath.section]

            return reusableHeader

        default: fatalError("Unexpected element kind")
        }
    }
}

// MARK: - UICollectionViewDelegate
extension FiltersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didChangeTagAt(indexPath, selected: true)
    }

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel?.didChangeTagAt(indexPath, selected: false)
    }
}

extension FiltersViewController: TagCellLayoutDelegate {
    func tagCellLayoutTagSize(layout: TagCellLayout, at indexPath: IndexPath) -> CGSize {
        guard let viewModel = viewModel else {
            fatalError("View model is nil but collection view is not empty")
        }

        let tagViewModel = viewModel.viewModelForTag(indexPath)
        var width: CGFloat = min(calculateWidthOfText(tagViewModel.title), maximumTagWidth)
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
