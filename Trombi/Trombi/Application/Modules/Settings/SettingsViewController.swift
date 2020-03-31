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

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - ViewModel
    var viewModel: SettingsViewViewModel?

    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let tableView = tableView else {
            print("Table view is not set up")
            return
        }

        tableView.separatorColor = UIColor(redInt: 226, greenInt: 222, blueInt: 221, alpha: 1.0)
        tableView.tableFooterView = UIView()
        tableView.registerReusableCell(type: SettingsTableViewCell.self)
    
        if let viewModel = viewModel {
            bindViewModel(viewModel)
        } else {
            print("SearchViewViewModel is not set up")
        }
    }
    
    // MARK: - binding ViewModel
    private func bindViewModel(_ viewModel: SettingsViewViewModel) {
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
        }).subscribe({ event in
            switch event {
            case .next(let currentBaseUrl):
                let alert = UIAlertController(
                    title: "Set the base url",
                    message: "Set the url of server you want Trombi to get data from",
                    preferredStyle: .alert
                )
                
                alert.addTextField(configurationHandler: { [weak self] textField in
                    guard let strongSelf = self else { return }
                    textField.text = currentBaseUrl
                    textField.rx.text.bind(to: viewModel.enteredBaseUrl).disposed(by: strongSelf.disposeBag)
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    viewModel.setBaseUrl()
                })
                
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                
                viewModel.isEnteredBaseUrlValid.drive(okAction.rx.isEnabled).disposed(by: self.disposeBag)
                
                self.present(alert, animated: true, completion: nil)
            default:
                break
            }
        }).disposed(by: disposeBag)
    }
}
