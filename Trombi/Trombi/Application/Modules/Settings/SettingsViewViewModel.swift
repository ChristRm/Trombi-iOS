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

protocol SettingsViewViewModelInterface {
    // MARK: - Input
    var selectedItem: BehaviorRelay<Int?> { get }
    var finishedWithBaseUrl: BehaviorRelay<String?> { get }
    
    // MARK: - Output
    var settingsTable: Driver<[String]> { get }
    var openAlertWithCurrentBaseUrl: Signal<String?> { get }
    var sendEmailToAdress: Signal<String?> { get }
}

extension SettingsViewViewModel: SettingsViewViewModelInterface {

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
    
    // MARK: - SettingsViewViewModelInterface
    private(set) var selectedItem: BehaviorRelay<Int?> = BehaviorRelay<Int?>(value: nil)
    private(set) var finishedWithBaseUrl: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    
    let settingsTable: Driver<[String]> = {
        BehaviorRelay<[String]>(value: SettingsRow.allCases.compactMap({ return $0.rawValue })).asDriver()
    }()
    var openAlertWithCurrentBaseUrl: Signal<String?> { return _openAlertWithCurrentBaseUrl.asSignal(onErrorJustReturn: nil) }
    var sendEmailToAdress: Signal<String?> { return _sendEmailToAdress.asSignal(onErrorJustReturn: nil) }
    
    // MARK: - Private properties
    private let _settingsTable = BehaviorRelay<[EmployeeSearchCellModel]>(value: [])
    private let _openAlertWithCurrentBaseUrl = BehaviorRelay<String?>(value: nil)
    private let _sendEmailToAdress = BehaviorRelay<String?>(value: nil)
    
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
    }
}
