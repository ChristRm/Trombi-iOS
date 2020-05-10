//
//  EmployeeCollectionViewCell.swift
//  Trombi
//
//  Created by Chris Rusin on 12/18/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit
import SDWebImage

struct EmployeeCellModel {

    let employee: Employee
    let team: Team?

    init(employee: Employee, team: Team?) {
        self.employee = employee
        self.team = team
    }

    var imageUrl: String {
        return employee.avatarUrl
    }

    var nameText: String {
        return employee.fullName
    }

    var teamNameText: String {
        return team?.name ?? "No team"
    }

    var positionText: String {
        return employee.job
    }
}

final class EmployeeCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: ShadowedImageView?

    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var positionLabel: UILabel?
    @IBOutlet private weak var teamLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        initShadows()
    }

    func setModel(_ model: EmployeeCellModel) {
        let avatarUrl = TrombiApiRequests.baseUrl + model.imageUrl
        imageView?.setImage(with: URL(string: avatarUrl), completed: nil)
        
        imageView?.contentMode = .scaleAspectFill

        nameLabel?.text = model.nameText
        teamLabel?.text = model.teamNameText
        positionLabel?.text = model.positionText
    }

    // MARK: - Private
    private func initShadows() {
        // shadow for team label over the image
        teamLabel?.layer.shadowColor = UIColor.black.cgColor
        teamLabel?.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        teamLabel?.layer.shadowOpacity = 0.65
        teamLabel?.layer.shadowRadius = 5.0
    }
}
