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

public protocol SettingsViewViewModelInterface: Resultable {
    // MARK: - Input
    var selectedItem: BehaviorRelay<Int?> { get }
    var newUrlSelected: PublishRelay<String?> { get }
    
    // MARK: - Output
    var settingsTable: Driver<[String]> { get }
    var openAlertWithCurrentBaseUrl: Signal<String?> { get }
    var sendEmailToAdress: Signal<String?> { get }
}

extension SettingsViewViewModel: SettingsViewViewModelInterface {

    public typealias ValueType = String?
    
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
    
    public var modelResult: Single<String?> {
        _modelResult
            .take(1)
            .asSingle()
    }
    
    private var _modelResult = PublishRelay<String?>()
    
    // MARK: - SettingsViewViewModelInterface
    private(set) var selectedItem: BehaviorRelay<Int?> = BehaviorRelay<Int?>(value: nil)
    private(set) var newUrlSelected = PublishRelay<String?>()
    
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
        newUrlSelected.bind(to: _modelResult).disposed(by: disposeBag)
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
