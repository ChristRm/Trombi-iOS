//
//  SettingsViewController.swift
//  Trombi
//
//  Created by Chris Rusin on 3/8/20.
//  Copyright © 2020 Christian Rusin . All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {

    enum SettingsRow: String, CaseIterable {
        case email = "Help"
        case birthday = "Base url"
    }
//var usefulLinksTable: <[UsefulLinkCellModel]> { return _usefulLinksTable.asDriver() }
    private let settingsTable: Driver<[String]> = {
        BehaviorRelay<[String]>(value: SettingsRow.allCases.compactMap({ return $0.rawValue })).asDriver()
    }()

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()


        settingsTable.drive(tableView.rx.items(
            cellIdentifier: UsefulLinkTableViewCell.staticReuseIdentifier,
            cellType: UsefulLinkTableViewCell.self)
        ) { (_, usefulLinkTableCellModel, cell) in
            cell.setModel(usefulLinkTableCellModel)
            }.disposed(by: disposeBag)

        tableView.rx.itemSelected
            .asObservable()
            .map({ indexPath -> Int in return indexPath.row })
            .bind(to: viewModel.selectedIte
    }
}
