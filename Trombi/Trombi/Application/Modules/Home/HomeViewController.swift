//
//  HomeViewController.swift
//  Trombi
//
//  Created by Christian Rusin  on 22/11/2018.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewController: UIViewController {

    // MARK: - ViewModel
    var viewModel: HomeViewViewModel?

    // MARK: - IBOutlet
    @IBOutlet private weak var collectionView: UICollectionView?
    @IBOutlet private weak var filterBarButtonItem: UIBarButtonItem?

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.configurate()
        
        if let viewModel = viewModel {
            bindViewModel(viewModel)
        } else {
            print("UsefulLinksViewViewModel is not set up")
        }
        
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
        guard let collectionView = collectionView else {
            print("collectionView is not set up")
            return
        }

        let dataSource =
            RxCollectionViewSectionedReloadDataSource<EmployeesSection>(
                configureCell: { (_, collectionView, indexPath, cellModel) -> UICollectionViewCell in
                    let cell: EmployeeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.setModel(cellModel)
                    
                    return cell
            })

        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let reusableHeader =
                    collectionView.dequeueReusableSupplementaryView(
                        ofKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: "EmployeesCollectionViewHeader",
                        for: indexPath
                )
                
                guard let descriptionLabel = reusableHeader.viewWithTag(1) as? UILabel else {
                    fatalError("could not find the description label")
                }
                
                guard let rightSideImageView = reusableHeader.viewWithTag(2) as? UIImageView else {
                    fatalError("could not find the image")
                }
                
                let section = dataSource.sectionModels[indexPath.section]
                descriptionLabel.text = section.header
                rightSideImageView.image = section.rightSideImage
                
                return reusableHeader
            default: fatalError("Unexpected element kind")
            }
        }

        viewModel.employeesSections.drive(collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
                
        viewModel.filtersViewViewModel.filtered.drive(onNext: { [weak self] filtered in
            self?.filterBarButtonItem?.image = filtered ? UIImage(named: "icFiltered") : UIImage(named: "icFilter")
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    // MARK: - Private methods

    private func setupCollectionView() {
        collectionView?.registerReusableCell(type: EmployeeCollectionViewCell.self)
        collectionView?.register(
            UINib(
                nibName: "EmployeesCollectionViewHeader",
                bundle: nil
            ),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "EmployeesCollectionViewHeader"
        )
        
        collectionView?.rx.modelSelected(EmployeeCellModel.self).subscribe(
            onNext: { [weak self] cell in
                self?.performSegue(
                    withIdentifier: String(describing: EmployeeProfileViewController.self),
                    sender: cell
                )
        }, onError: nil,
           onCompleted: nil,
           onDisposed: nil
        ).disposed(by: disposeBag)
        
        collectionView?.rx.setDelegate(self).disposed(by: disposeBag)
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
