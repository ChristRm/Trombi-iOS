//
//  BaseUrlAlertController.swift
//  Trombi
//
//  Created by Chris on 01/04/2020.
//  Copyright © 2020 Christian Rusin . All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseUrlAlertController: UIAlertController {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    // MARK: - ViewModel
    private let viewModel = BaseUrlAlertViewModel()

    // MARK: - Private properties
    let acceptedWithBaseUrl = PublishRelay<String?>()
    let canceledWithBaseUrl = PublishRelay<String?>()
    
    convenience init(currentBaseUrl: String?) {
        self.init(
            title: "Set the base url",
            message: "Set the url of server you want Trombi to get data from",
            preferredStyle: .alert
        )

        addTextField(configurationHandler: { [weak self] textField in
            guard let strongSelf = self else { return }
            textField.text = currentBaseUrl
            textField.rx.text.bind(to: strongSelf.viewModel.enteredBaseUrl).disposed(by: strongSelf.disposeBag)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.canceledWithBaseUrl.accept(self?.viewModel.enteredBaseUrl.value)
        })
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.viewModel.setBaseUrl()
            self?.dismiss(animated: true, completion: { [weak self] in
                self?.acceptedWithBaseUrl.accept(self?.viewModel.enteredBaseUrl.value)
            })
        })

        viewModel.isEnteredBaseUrlValid.asObservable().bind(to: okAction.rx.isEnabled).disposed(by: disposeBag)
        
        addAction(cancelAction)
        addAction(okAction)
    }
}
