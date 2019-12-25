//
//  EmployeesViewController.swift
//  Trombi
//
//  Created by Christian Rusin  on 22/11/2018.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {

    // MARK: - ViewModel
    var viewModel: HomeViewViewModel? {
        didSet {
            if let viewModel = viewModel {
                bindViewModel(viewModel)
            }
        }
    }

    // MARK: - IBOutlet
    @IBOutlet private weak var collectionView: UICollectionView?
    @IBOutlet private weak var filterBarButtonItem: UIBarButtonItem?

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let viewModel = viewModel else { return }

        if segue.identifier == String(describing: FiltersPanelViewController.self) {
            if let filtersPanelViewController = segue.destination as? FiltersPanelViewController {
                filtersPanelViewController.filtersViewViewModel = viewModel.filtersViewViewModel
            }
        } else if segue.identifier == String(describing: EmployeeProfileViewController.self) {
            if let userProfileViewController = segue.destination as? EmployeeProfileViewController {
                if let employeeInfo = sender as? EmployeeCellModel {
                    userProfileViewController.team = employeeInfo.team
                    userProfileViewController.employee = employeeInfo.employee
                }
            }
        } else if segue.identifier == String(describing: SearchViewController.self) {
            if let navigationController = segue.destination as? UINavigationController,
                let searchViewController = navigationController.viewControllers.first as? SearchViewController {
                searchViewController.viewModel = SearchViewViewModel(applicationData: viewModel.applicationData)
            }
        }
    }

    // MARK: - IBAction

    @IBAction func searchButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: String(describing: SearchViewController.self), sender: nil)
    }

    @IBAction func filterButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: String(describing: FiltersPanelViewController.self), sender: nil)
    }

    // MARK: - binding ViewModel
    private func bindViewModel(_ viewModel: HomeViewViewModel) {
        viewModel.employeesSections.drive(onNext: { [weak self] _ in
            self?.collectionView?.reloadData()
        }).disposed(by: disposeBag)
    }

    // MARK: - Private methods

    private func setupCollectionView() {
        collectionView?.registerReusableCell(type: EmployeeCollectionViewCell.self)
        collectionView?.register(UINib(nibName: "EmployeesCollectionViewHeader", bundle: nil),
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: "EmployeesCollectionViewHeader")
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
}

// MARK: - Constants

extension HomeViewController {
    fileprivate enum Defaults {

        static let itemTopMarginRatio: CGFloat = CGFloat(20.0/775.0)
        static let itemSideMarginRatio: CGFloat = CGFloat(25.0/375.0)
        static let itemSpacingRatio: CGFloat = CGFloat(15.0/375.0)

        static let itemWidthToHeightRatio = CGFloat(155.0/231.0)

        static let headerHeight = CGFloat(40.0)

        static let additionalMargin = CGFloat(15.0)
    }
}

// MARK: - HorizontalFloatingHeaderLayoutDelegate
extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: Defaults.headerHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth(), height: itemHeight())
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Defaults.itemTopMarginRatio * view.bounds.height,
                            left: sideMargin(),
                            bottom: 0.0,
                            right: sideMargin())
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return view.bounds.height * Defaults.itemTopMarginRatio
    }

    private func sideMargin() -> CGFloat {
        let margin = view.bounds.width * Defaults.itemSideMarginRatio
        return margin
    }

    private func itemWidth() -> CGFloat {
        let width = view.bounds.width - sideMargin() * 2.0
        return width / CGFloat(2.0) - (view.bounds.width * Defaults.itemSpacingRatio) / 2.0
    }

    private func itemHeight() -> CGFloat {
        return itemWidth() * (1.0 / Defaults.itemWidthToHeightRatio)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {

    // MARK: - Collection View Data Source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfEmployeesSections() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.employeeSectionAtIndex(section).cells.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let employeeCell: EmployeeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let viewModel = viewModel {
            employeeCell.setModel(viewModel.employeeSectionAtIndex(indexPath.section).cells[indexPath.row])
        } else {
            fatalError("EmployeesViewModel is nil")
        }

        return employeeCell
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
                                                                withReuseIdentifier: "EmployeesCollectionViewHeader",
                                                                for: indexPath)

            guard let descriptionLabel = reusableHeader.viewWithTag(1) as? UILabel else {
                fatalError("could not find description label")
            }

            descriptionLabel.text = viewModel.employeeSectionAtIndex(indexPath.section).title

            return reusableHeader

        default: fatalError("Unexpected element kind")
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = viewModel?.employeeSectionAtIndex(indexPath.section).cells[indexPath.row] {
            performSegue(withIdentifier: String(describing: EmployeeProfileViewController.self), sender: data)
        } else {
            fatalError("EmployeesViewModel is nil")
        }
    }
}
