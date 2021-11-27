//
//  UsefulLinksViewViewModel.swift
//  Trombi
//
//  Created by Chris Rusin on 12/23/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import RxSwift
import RxCocoa

protocol UsefulLinksViewViewModelInterface: ApplicationDataInjecting {
    // MARK: - Input
    var selectedItem: BehaviorRelay<Int?> { get }

    // MARK: - Output
    var usefulLinksTable: Driver<[UsefulLinkCellModel]> { get }
    var openUrl: Signal<String> { get }
}

final class UsefulLinksViewViewModel: UsefulLinksViewViewModelInterface {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()

    init() {
        selectedItem.subscribe { [weak self] event in
            switch event {
            case .next(let index):
                if let index = index, let applicationData = self?.applicationData {
                    self?._openUrl.accept(applicationData.usefuleLinks[index].url)
                }
            default:
                break
            }
        }.disposed(by: disposeBag)
    }

    // MARK: - UsefulLinksViewViewModelInterface
    private(set) var selectedItem: BehaviorRelay<Int?> = BehaviorRelay<Int?>(value: nil)

    var usefulLinksTable: Driver<[UsefulLinkCellModel]> { return _usefulLinksTable.asDriver() }
    var openUrl: Signal<String> { return _openUrl.asSignal(onErrorJustReturn: "") }
    
    public var applicationData: ApplicationData = ApplicationData() {
        didSet {
            let usefulLinkCellsModels = applicationData.usefuleLinks.map({ usefulLink in
                return UsefulLinkCellModel(
                    imageUrl: usefulLink.imageUrl,
                    title: usefulLink.title,
                    description: usefulLink.description
                )
            })

            _usefulLinksTable.accept(usefulLinkCellsModels)
        }
    }

    // MARK: - Private properties
    private let _usefulLinksTable = BehaviorRelay<[UsefulLinkCellModel]>(value: [])
    private let _openUrl = BehaviorRelay<String>(value: "")
}
