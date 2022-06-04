//
//  UsefulLinksViewViewModel.swift
//  Trombi
//
//  Created by Chris Rusin on 12/23/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import RxSwift
import RxCocoa

public protocol UsefulLinksViewViewModelInterface: ApplicationDataInjecting {
    // MARK: - Input
    var selectedItem: BehaviorRelay<Int?> { get }

    // MARK: - Output
    var usefulLinksTable: Driver<[UsefulLinkCellModel]> { get }
    var openUrl: Signal<String> { get }
}

public final class UsefulLinksViewViewModel: UsefulLinksViewViewModelInterface {

    // MARK: - RxSwift
    private let disposeBag = DisposeBag()
    
    public var modelResult: Single<Any> {
        _modelResult
            .take(1)
            .asSingle()
    }
    
    private var _modelResult = PublishRelay<Any>()

    init(applicationData: ApplicationData) {
        self.applicationData = applicationData
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
        refresh()
    }

    // MARK: - UsefulLinksViewViewModelInterface
    private(set) public var selectedItem: BehaviorRelay<Int?> = BehaviorRelay<Int?>(value: nil)

    public var usefulLinksTable: Driver<[UsefulLinkCellModel]> { return _usefulLinksTable.asDriver() }
    public var openUrl: Signal<String> { return _openUrl.asSignal(onErrorJustReturn: "") }
    
    public var applicationData: ApplicationData = ApplicationData() {
        didSet {
            refresh()
        }
    }
    
    func refresh() {
        let usefulLinkCellsModels = applicationData.usefuleLinks.map({ usefulLink in
            return UsefulLinkCellModel(
                imageUrl: usefulLink.imageUrl,
                title: usefulLink.title,
                description: usefulLink.description
            )
        })

        _usefulLinksTable.accept(usefulLinkCellsModels)
    }

    // MARK: - Private properties
    private let _usefulLinksTable = BehaviorRelay<[UsefulLinkCellModel]>(value: [])
    private let _openUrl = BehaviorRelay<String>(value: "")
}
