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

class SettingsViewController<ViewModel: SettingsViewViewModelInterface>: UIViewController {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - ViewModel
    let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: SettingsViewController.identifier, bundle: SettingsViewController.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.configurate()
        
        guard let tableView = tableView else {
            print("Table view is not set up")
            return
        }

        tableView.separatorColor = UIColor(redInt: 226, greenInt: 222, blueInt: 221, alpha: 1.0)
        tableView.tableFooterView = UIView()
        tableView.registerReusableCell(type: SettingsTableViewCell.self)
    
        bindViewModel()
    }
    
    // MARK: - binding ViewModel
    private func bindViewModel() {
        guard let tableView = tableView else {
            print("Table view is not set up")
            return
        }
        
        viewModel.settingsTable.drive(tableView.rx.items(
            cellIdentifier: SettingsTableViewCell.staticReuseIdentifier,
            cellType: SettingsTableViewCell.self)
        ) { (_, settingName, cell) in
            cell.setNameLabel(settingName)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asObservable()
            .map({ [weak self] indexPath -> Int in
                self?.tableView?.deselectRow(at: indexPath, animated: true)
                return indexPath.row
            })
            .bind(to: viewModel.selectedItem)
            .disposed(by: disposeBag)
        
        viewModel.sendEmailToAdress.asObservable().filter({ baseUrl -> Bool in
            return baseUrl != nil
        }).subscribe({ event in
            switch event {
            case .next(let helpUrl):
                if let helpUrl = helpUrl, let emailUrl = URL(string: "mailto:\(helpUrl)") {
                    UIApplication.shared.open(emailUrl, options: [:], completionHandler: nil)
                }
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        viewModel.openAlertWithCurrentBaseUrl.asObservable().filter({ baseUrl -> Bool in
            return baseUrl != nil
        }).subscribe({ [weak self] event in
            guard let strongSelf = self else { return }

            switch event {
            case .next(let currentBaseUrl):
                let alert = BaseUrlAlertController(currentBaseUrl: currentBaseUrl)

                alert.acceptedWithBaseUrl
                    .bind(to: strongSelf.viewModel.newUrlSelected)
                    .disposed(by: strongSelf.disposeBag)

                strongSelf.present(alert, animated: true, completion: nil)
            default:
                break
            }
        }).disposed(by: disposeBag)
    }
}
