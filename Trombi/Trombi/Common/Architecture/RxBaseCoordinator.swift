//
//  RxBaseCoordinator.swift
//  Trombi
//
//  Created by Kristian Rusyn on 26/05/2022.
//  Copyright © 2022 Christian Rusin . All rights reserved.
//

import RxSwift

// https://benoitpasquier.com/integrate-coordinator-pattern-in-rxswift/
// https://medium.com/better-programming/reactive-mvvm-and-the-coordinator-pattern-done-right-88248baf8ca5
// TODO: migrate to abstraction to get rid of coupling from RxSwift
open class RxBaseCoordinator<ResultType>: NSObject, DeepLinkOptionProcessCapable {

    public var isPopulated: Bool {
        !childCoordinators.isEmpty
    }

    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()

    public var bag = DisposeBag()


    @discardableResult
    open func coordinate<T>(to coordinator: RxBaseCoordinator<T>, with option: DeepLinkBase? = nil) -> Single<T> {
        store(coordinator: coordinator)
        return coordinator.start(with: option)
            .do(onSuccess: { [weak self, unowned coordinator] _ in
                self?.release(coordinator: coordinator)
            }, onError: { [weak self, unowned coordinator] err in
                self?.release(coordinator: coordinator)
            })
    }

    open func start(with option: DeepLinkBase? = nil) -> Single<ResultType> {
        fatalError("start() method must be implemented at child coordinator")
    }
    
    open func addChild(coordinator: RxBaseCoordinator) {
        store(coordinator: coordinator)
    }
    
    open func resetCoordinator() {
        childCoordinators.removeAll()
    }
    
    open func remove(coordinator: RxBaseCoordinator) {
        release(coordinator: coordinator)
    }
    
    open func handle(deepLink: DeepLinkBase) {
        childCoordinators.forEach { _, coordinator in
            if let rxCoordinator = coordinator as? DeepLinkOptionProcessCapable {
                rxCoordinator.handle(deepLink: deepLink)
            }
        }
    }
    
    // MARK: - Private

    private func store<T>(coordinator: RxBaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func release<T>(coordinator: RxBaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
}
