//
//  SplashViewController.swift
//  Trombi
//
//  Created by Chris Rusin on 12/25/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SplashViewController: UIViewController, Resultable {
    
    typealias ValueType = ApplicationData

    var modelResult: Single<ApplicationData> {
        _modelResult
            .take(1)
            .asSingle()
    }
    
    public var bag = DisposeBag()
    
    private var _modelResult = PublishRelay<ApplicationData>()

    // MARK: - RxSwift

    private let disposeBag = DisposeBag()

    private let _applicationData = BehaviorRelay<ApplicationData?>(value: nil)
    
    init() {
        super.init(nibName: SplashViewController.identifier, bundle: SplashViewController.bundle)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func getApplicationData() {
        let getEmployees = TrombiAPI.sharedAPI.getEmployees()
        let getTeams = TrombiAPI.sharedAPI.getTeams()
        let getUsefulLinks = TrombiAPI.sharedAPI.getUsefulLinks()

        let observable: Observable<ApplicationData> = Observable.zip(
            getEmployees,
            getTeams,
            getUsefulLinks,
            resultSelector: { (employees: [Employee], teams: [Team], usefulLinks: [UsefulLink]) in
                let applicationData = ApplicationData(
                    employees: employees,
                    teams: teams,
                    usefuleLinks: usefulLinks
                )

                return applicationData
            })
        
        observable
            .do(onNext: { [weak self] _ in
                self?.activityIndicatorView.isHidden = true
            }, onError: { [weak self] error in
                self?.handleError(error as NSError)
            })
            .subscribe(onNext: { [weak self] applicationData in
                self?._modelResult.accept(applicationData)
            })
            .disposed(by: disposeBag)

//        activityIndicatorView.isHidden = false
//
//        observable.observeOn(MainScheduler.instance)
//            .subscribe({ [weak self] event in
//                self?.activityIndicatorView.isHidden = true
//                switch event {
//                case .next(let applicationData):
//                    self?._applicationData.accept(applicationData)
//                case .error(let error):
//                    self?.handleError(error as NSError)
//                default: break
//                }
//        }).disposed(by: disposeBag)
    }

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.startAnimating()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getApplicationData()
    }

    override var shouldAutorotate: Bool {
        return false
    }

    private func handleError(_ error: NSError) {
        if error.code == NSURLErrorCannotConnectToHost ||
            error.code == NSURLErrorCannotFindHost ||
            error.code ==  NSURLErrorUnsupportedURL {
            showSetBaseUrlAlert()
        } else {
            showErrorAlert(description: error.localizedDescription)
        }
    }
    
    private func showSetBaseUrlAlert() {
        let alert = BaseUrlAlertController(currentBaseUrl: TrombiApiRequests.baseUrl)
        alert.acceptedWithBaseUrl.asObservable().filter({ baseUrl -> Bool in
            return baseUrl != nil
        }).subscribe({ [weak self] event in
            switch event {
            case .next:
                self?.getApplicationData()
            default:
                break
            }
        }).disposed(by: disposeBag)

        alert.canceledWithBaseUrl.asObservable().filter({ baseUrl -> Bool in
            return baseUrl != nil
        }).subscribe({ [weak self] event in
            switch event {
            case .next:
                self?.getApplicationData()
            default:
                break
            }
        }).disposed(by: disposeBag)

        present(alert, animated: true, completion: nil)
    }
    
    private func showErrorAlert(description: String) {
        let alert = UIAlertController(
            title: "Error",
            message: description,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            self?.getApplicationData()
        }))

        self.present(alert, animated: true, completion: nil)
    }
}
