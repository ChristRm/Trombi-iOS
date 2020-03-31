//
//  SettingsViewViewModel.swift
//  Trombi
//
//  Created by Christian Rusin on 30/03/2020.
//  Copyright © 2020 Christian Rusin . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

fileprivate extension SettingsViewViewModel {
    
    enum Defaults {
        static let helpUrl: String = "christianrusinm@gmail.com"
    }
    
    enum SettingsRow: String, CaseIterable {
        case needHelp = "Need help"
        case baseUrl = "Base url"
    }
}

final class SettingsViewViewModel {
    
    // MARK: - RxSwift
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    private(set) var selectedItem: BehaviorRelay<Int?> = BehaviorRelay<Int?>(value: nil)
    private(set) var enteredBaseUrl: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    
    // MARK: - Output
    let settingsTable: Driver<[String]> = {
        BehaviorRelay<[String]>(value: SettingsRow.allCases.compactMap({ return $0.rawValue })).asDriver()
    }()
    var openAlertWithCurrentBaseUrl: Signal<String?> { return _openAlertWithCurrentBaseUrl.asSignal(onErrorJustReturn: nil) }
    var sendEmailToAdress: Signal<String?> { return _sendEmailToAdress.asSignal(onErrorJustReturn: nil) }
    
    var isEnteredBaseUrlValid: Driver<Bool> {
        return _isEnteredBaseUrlValid.asDriver()
    }
    
    // MARK: - Private properties
    private let _settingsTable = BehaviorRelay<[EmployeeSearchCellModel]>(value: [])
    private let _openAlertWithCurrentBaseUrl = BehaviorRelay<String?>(value: nil)
    private let _sendEmailToAdress = BehaviorRelay<String?>(value: nil)
    
    private let _isEnteredBaseUrlValid = BehaviorRelay<Bool>(value: false)
    
    init() {
        setup()
    }
    
    private func setup() {
        selectedItem.subscribe({ [weak self] event in
            switch event {
            case .next(let row):
                guard let row = row else { return }
                guard let settingsRow = SettingsRow(rawValue: SettingsRow.allCases[row].rawValue) else {
                    return
                }
                
                switch settingsRow {
                case .needHelp:
                    self?._sendEmailToAdress.accept(Defaults.helpUrl)
                case .baseUrl:
                    self?._openAlertWithCurrentBaseUrl.accept(TrombiApiRequests.baseUrl)
                }
            default: break
            }
        }).disposed(by: disposeBag)
        
        enteredBaseUrl.map({ baseUrl -> Bool in
            guard let baseUrl = baseUrl, !baseUrl.isEmpty,
                let _ = URL(string: baseUrl + EndpointsHelper.Resource.getPersons) else {
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
