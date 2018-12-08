//
//  LoadsChain.swift
//  Legrand
//
//  Created by Chris Rusin on 12/27/17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

import Foundation

typealias LoadingResultHandler = (success: () -> Void, failure: (_ error: Error) -> Void)

protocol ChainLoadingProtocol {
    func loadData(_ resultHandler: LoadingResultHandler)
}

class LoadsChain {
    var loadsToExecute: [ChainLoadingProtocol]
    fileprivate var succeedLoads: [ChainLoadingProtocol] = []

    init(chain: [ChainLoadingProtocol]) {
        loadsToExecute = chain
    }

    convenience init() {
        self.init(chain: [])
    }

    func executeChain(_ success: @escaping ([ChainLoadingProtocol]) -> Void,
                      failure: @escaping (_ succeedLoads: [ChainLoadingProtocol], _ error: Error) -> Void) {
        executeNextElement(success, failure: failure)
    }

    fileprivate func executeNextElement(_ success: @escaping ([ChainLoadingProtocol]) -> Void,
                                        failure: @escaping ([ChainLoadingProtocol], Error) -> Void) {
        if let firstElement = loadsToExecute.first {
            firstElement.loadData((success: {
                self.succeedLoads.append(self.loadsToExecute.removeFirst())
                self.executeNextElement(success, failure: failure)
                }, failure: { error in
                    failure(self.succeedLoads, error)
            }))
        } else {
            success(self.succeedLoads)
        }
    }
}
