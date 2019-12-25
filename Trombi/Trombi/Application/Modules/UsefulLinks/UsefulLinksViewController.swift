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

final class UsefulLinksViewController: UIViewController {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - ViewModel
    var viewModel: UsefulLinksViewViewModel?

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewModel = viewModel {
            bindViewModel(viewModel)
        } else {
            print("UsefulLinksViewViewModel is not set up")
        }

        tableView.registerReusableCell(type: UsefulLinkTableViewCell.self)
    }

    // MARK: - binding ViewModel
    private func bindViewModel(_ viewModel: UsefulLinksViewViewModel) {
        viewModel.usefulLinksTable.drive(tableView.rx.items(
            cellIdentifier: UsefulLinkTableViewCell.staticReuseIdentifier,
            cellType: UsefulLinkTableViewCell.self)
        ) { (_, usefulLinkTableCellModel, cell) in
            cell.setModel(usefulLinkTableCellModel)
            }.disposed(by: disposeBag)

        tableView.rx.itemSelected
            .asObservable()
            .map({ indexPath -> Int in return indexPath.row })
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
}
