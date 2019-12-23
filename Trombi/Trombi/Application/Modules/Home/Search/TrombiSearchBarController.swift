//
//  TrombiSearchBarController.swift
//  Trombi
//
//  Created by Chris Rusin on 9/28/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit

protocol TrombiSearchBarControllerDelegate: class {
    func dismissTapped()
}

class TrombiSearchBarController: UISearchController {

    weak var trombiDelegate: TrombiSearchBarControllerDelegate?

    // Mark this property as lazy to defer initialization until
    // the searchBar property is called.
    private var trombiSearchBar: TrombiSearchBar
    // Override this property to return your custom implementation.
    override var searchBar: UISearchBar { return trombiSearchBar }

    override func viewDidLoad() {
        super.viewDidLoad()
        trombiSearchBar.trombiDelegate = self
    }

    override init(searchResultsController: UIViewController?) {
        self.trombiSearchBar = TrombiSearchBarController.createTrombiSearchBar()
        trombiSearchBar.isTranslucent = false
        super.init(searchResultsController: searchResultsController)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.trombiSearchBar = TrombiSearchBarController.createTrombiSearchBar()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.trombiSearchBar = TrombiSearchBarController.createTrombiSearchBar()
        super.init(coder: aDecoder)
    }

    static func createTrombiSearchBar() -> TrombiSearchBar {
        let trombiSearchBar = TrombiSearchBar(frame: .zero)
        return trombiSearchBar
    }
}

extension TrombiSearchBarController: TrombiSearchBarDelegate {
    func dismissTapped() {
        trombiDelegate?.dismissTapped()
    }
}
