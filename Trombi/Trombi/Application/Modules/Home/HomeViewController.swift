//
//  HomeViewController.swift
//  Trombi
//
//  Created by Christian Rusin on 22/11/2018.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

public final class HomeViewController<ViewModel: HomeViewViewModelInterface>: UIViewController, UICollectionViewDelegateFlowLayout {

    // MARK: - ViewModel
    public var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: HomeViewController.identifier, bundle: HomeViewController.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IBOutlet
    @IBOutlet private weak var collectionView: UICollectionView?
    
    private var filterBarButtonItem: UIBarButtonItem?
    private var searchBarButtonItem: UIBarButtonItem?

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationTitle()
        
        setupCollectionView()
        setupNavigationItems()
        bindViewModel()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - binding ViewModel
    private func bindViewModel() {
        bindCollectionView()
        
        searchBarButtonItem?
            .rx
            .tap
            .bind(to: viewModel.openSearch)
            .disposed(by: disposeBag)
        
        filterBarButtonItem?
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.openFilters()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Private methods
    
    private func bindCollectionView() {
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
                let reusableHeader: EmployeesCollectionViewHeader =
                    collectionView.dequeueReusableHeader(for: indexPath)

                let section = dataSource.sectionModels[indexPath.section]

                reusableHeader.setDescriptionLeftLabel(section.header)
                reusableHeader.setRightSideImage(section.rightSideImage)
                
                return reusableHeader
            default: fatalError("Unexpected element kind")
            }
        }

        viewModel.employeesSections.drive(collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
                
        viewModel.filtersViewViewModel.filtered.drive(onNext: { [weak self] filtered in
            self?.filterBarButtonItem?.image = filtered ? UIImage(named: "icFiltered") : UIImage(named: "icFilter")
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    private func setupNavigationTitle() {
        navigationController?.navigationBar.configurate()
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupCollectionView() {
        collectionView?.registerReusableCell(type: EmployeeCollectionViewCell.self)
        collectionView?.registerReusableHeader(type: EmployeesCollectionViewHeader.self)

        collectionView?.rx.modelSelected(EmployeeCellModel.self)
            .subscribe(
            onNext: { [weak self] cell in
                guard let team = cell.team else { return }
                
                self?.viewModel
                    .openEmployee
                    .onNext(EmployeeAndTeam(cell.employee, team))
        }).disposed(by: disposeBag)
    
        collectionView?.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func setupNavigationItems() {
        filterBarButtonItem = UIBarButtonItem(image: UIImage(named: "icFilter"), style: .plain, target: nil, action: nil)
        filterBarButtonItem?.rx.tap.subscribe(onNext: {
            print("tap")
        }).disposed(by: disposeBag)
        
        searchBarButtonItem = UIBarButtonItem(image: UIImage(named: "icSearch"), style: .plain, target: nil, action: nil)
        searchBarButtonItem?.tintColor = UIColor.mainBlackColor
        
        self.navigationItem.rightBarButtonItems = [filterBarButtonItem!, searchBarButtonItem!]
    }

    private func sideMargin() -> CGFloat {
        let margin = view.bounds.width * HomeDefaults.itemSideMarginRatio
        return margin
    }

    private func itemWidth() -> CGFloat {
        let width = view.bounds.width - sideMargin() * 2.0
        return width / CGFloat(2.0) - (view.bounds.width * HomeDefaults.itemSpacingRatio) / 2.0
    }

    private func itemHeight() -> CGFloat {
        return itemWidth() * (1.0 / HomeDefaults.itemWidthToHeightRatio)
    }
    
    private func openFilters() {
        let filtersStoryboard =
            UIStoryboard(name: "Filters",
                         bundle: FiltersPanelViewController.bundle)
        
        guard let filtersPanelViewController =
            filtersStoryboard.instantiateViewController(withIdentifier:
                                                            FiltersPanelViewController.storyboardIdentifier) as? FiltersPanelViewController else {
            print("Failed to load FiltersPanelViewController")
            return
        }
        
        filtersPanelViewController.filtersViewViewModel = viewModel.filtersViewViewModel
        present(filtersPanelViewController, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    @objc(collectionView:layout:referenceSizeForHeaderInSection:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: HomeDefaults.headerHeight)
    }

    @objc(collectionView:layout:sizeForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth(), height: itemHeight())
    }

    @objc(collectionView:layout:insetForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: HomeDefaults.itemTopMarginRatio * view.bounds.height,
                            left: sideMargin(),
                            bottom: 0.0,
                            right: sideMargin())
    }

    @objc(collectionView:layout:minimumLineSpacingForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return view.bounds.height * HomeDefaults.itemTopMarginRatio
    }
}

// MARK: - Constants
fileprivate enum HomeDefaults {
    
    static let itemTopMarginRatio: CGFloat = CGFloat(20.0/775.0)
    static let itemSideMarginRatio: CGFloat = CGFloat(25.0/375.0)
    static let itemSpacingRatio: CGFloat = CGFloat(15.0/375.0)
    
    static let itemWidthToHeightRatio = CGFloat(155.0/231.0)
    
    static let headerHeight = CGFloat(40.0)
    
    static let additionalMargin = CGFloat(15.0)
}

