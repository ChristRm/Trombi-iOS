//
//  UsefulLinksViewController.swift
//  Trombi
//
//  Created by Chris Rusin on 12/23/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit
import SafariServices
import RxSwift
import RxCocoa

final class UsefulLinksViewController<ViewModel: UsefulLinksViewViewModelInterface>: UIViewController {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - ViewModel
    let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: UsefulLinksViewController.identifier, bundle: UsefulLinksViewController.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationTitle()
        
        tableView?.registerReusableCell(type: UsefulLinkTableViewCell.self)
        bindViewModel(viewModel)
    }

    // MARK: - binding ViewModel
    private func bindViewModel(_ viewModel: UsefulLinksViewViewModelInterface) {
        guard let tableView = tableView else {
            print("tableView is not set up")
            return
        }
        
        viewModel.usefulLinksTable.drive(tableView.rx.items(
            cellIdentifier: UsefulLinkTableViewCell.staticReuseIdentifier,
            cellType: UsefulLinkTableViewCell.self)
        ) { (_, usefulLinkTableCellModel, cell) in
            cell.setModel(usefulLinkTableCellModel)
            }.disposed(by: disposeBag)

        tableView.rx.itemSelected
            .asObservable()
            .map({ [weak self] indexPath -> Int in
                self?.tableView?.deselectRow(at: indexPath, animated: true)
                return indexPath.row
            })
            .bind(to: viewModel.selectedItem)
            .disposed(by: disposeBag)

        viewModel.openUrl.asObservable().subscribe { [weak self] event in
            switch event {
            case .next(let url):
                if let url = URL(string: url) {
                let safariViewController = SFSafariViewController(url: url)
                    self?.present(safariViewController, animated: true, completion: nil)
                }
            default:
                break
            }
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    private func setupNavigationTitle() {
        navigationController?.navigationBar.configurate()
        navigationItem.title = "Useful links"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
