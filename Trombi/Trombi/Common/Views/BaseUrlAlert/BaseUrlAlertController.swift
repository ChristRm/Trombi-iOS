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
    
    var acceptedWithBaseUrl: Signal<String?> {
        return _acceptedWithBaseUrl.asSignal(onErrorJustReturn: nil)
    }
    
    var canceledWithBaseUrl: Signal<String?> {
        return _canceledWithBaseUrl.asSignal(onErrorJustReturn: nil)
    }

    // MARK: - Private properties
    private let _acceptedWithBaseUrl = BehaviorRelay<String?>(value: nil)
    private let _canceledWithBaseUrl = BehaviorRelay<String?>(value: nil)
    
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
            self?._canceledWithBaseUrl.accept(self?.viewModel.enteredBaseUrl.value)
        })
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.viewModel.setBaseUrl()
            self?._acceptedWithBaseUrl.accept(self?.viewModel.enteredBaseUrl.value)
            self?.dismiss(animated: true, completion: nil)
        })

        viewModel.isEnteredBaseUrlValid.asObservable().bind(to: okAction.rx.isEnabled).disposed(by: disposeBag)
        
        addAction(cancelAction)
        addAction(okAction)
    }
}
