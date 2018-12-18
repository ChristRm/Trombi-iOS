//
//  EmployeesViewController.swift
//  Trombi
//
//  Created by Christian Rusin  on 22/11/2018.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit
import RxSwift

final class EmployeesViewController: UIViewController {

    // MARK: - Constants

    fileprivate enum Defaults {

        static let itemTopMarginRatio: CGFloat = CGFloat(20.0/775.0)
        static let itemSideMarginRatio: CGFloat = CGFloat(25.0/375.0)
        static let itemSpacingRatio: CGFloat = CGFloat(15.0/375.0)

        static let itemWidthToHeightRatio = CGFloat(155.0/231.0)

        static let headerHeight = CGFloat(25.0)

        static let additionalMargin = CGFloat(15.0)
    }

    // MARK: - ViewModel
    var viewModel: EmployeesViewViewModel? {
        didSet {
            if let viewModel = viewModel {
                bindViewModel(viewModel)
            }
        }
    }

    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView?

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "People"

        setupCollectionView()
    }

    // MARK: - IBAction

    @IBAction func searchButtonTouched(_ sender: Any) { }

    @IBAction func filterButtonTouched(_ sender: Any) { }

    // MARK: - binding ViewModel
    private func bindViewModel(_ viewModel: EmployeesViewViewModel) {
        viewModel.employees.drive(onNext: { [weak self] (_) in
            self?.collectionView?.reloadData()
        }).disposed(by: disposeBag)
    }

    // MARK: - Private methods

    private func setupCollectionView() {
        collectionView?.registerReusableCell(type: EmployeeCollectionViewCell.self)
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
}

// MARK: - HorizontalFloatingHeaderLayoutDelegate
extension EmployeesViewController: UICollectionViewDelegateFlowLayout {

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
extension EmployeesViewController: UICollectionViewDataSource {

    // MARK: - Collection View Data Source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfEmployees ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let employeeCell: EmployeeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let viewModel = viewModel {
            employeeCell.setModel(viewModel.viewModelForEmployee(at: indexPath.row))
        } else {
            fatalError("EmployeesViewModel is nil")
        }

        return employeeCell
    }
}

// MARK: - UICollectionViewDelegate
extension EmployeesViewController: UICollectionViewDelegate {

}
