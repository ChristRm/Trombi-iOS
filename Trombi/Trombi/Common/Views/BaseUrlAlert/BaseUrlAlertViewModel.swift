//
//  BaseUrlAlertViewModel.swift
//  Trombi
//
//  Created by Chris on 01/04/2020.
//  Copyright © 2020 Christian Rusin . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseUrlAlertViewModel {
    
    // MARK: - RxSwift
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    private(set) var enteredBaseUrl: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    
    // MARK: - Output
    var isEnteredBaseUrlValid: Driver<Bool> {
        return _isEnteredBaseUrlValid.asDriver()
    }
    
    // MARK: - Private properties
    private let _isEnteredBaseUrlValid = BehaviorRelay<Bool>(value: false)
    
    init() {
        setup()
    }
    
    private func setup() {
        enteredBaseUrl.map({ baseUrl -> Bool in
            guard let baseUrl = baseUrl, !baseUrl.isEmpty,
                URL(string: baseUrl + EndpointsHelper.Resource.getPersons) != nil else {
                    return false
            }
            
            return true
        }).bind(to: _isEnteredBaseUrlValid).disposed(by: disposeBag)
    }
    
    // MARK: - Public interface
    
    func setBaseUrl() {
        UserDefaults.set(baseUrl: enteredBaseUrl.value)
    }
}
