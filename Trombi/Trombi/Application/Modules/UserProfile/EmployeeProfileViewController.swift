//
//  EmployeeProfileViewController.swift
//  Trombi
//
//  Created by Chris Rusin on 2/10/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import UIKit
import EventKit

final class EmployeeProfileViewController: UIViewController {

    // MARK: - Properties
    private var userImageViewShadowLayer: CALayer?

    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView?
    @IBOutlet private weak var topBlurredImageView: UIImageView?
    @IBOutlet private weak var userImageView: UIImageView?
    @IBOutlet private weak var teamRedirectButton: UIButton?
    @IBOutlet private weak var managerRedirectButton: UIButton?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var posititonLabel: UILabel?

    // MARK: - Input data
    var team: Team?
    var employee: Employee?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = navigationController, !navigationController.isNavigationBarHidden {
            navigationController.setNavigationBarHidden(true, animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    // MARK: - IBAction
    @IBAction func backButtonTouched(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Private
    private func setupTableView() {

        tableView?.registerReusableCell(type: UserInfoTableViewCell.self)
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    private func setupData() {
        guard let employee = employee, let team = team else {
            fatalError("Employee and Team is not setup in EmployeeProfileViewController")
        }
        
        //TODO: missing manager
        managerRedirectButton?.setTitle("Missing", for: .normal)
        teamRedirectButton?.setTitle(team.name, for: .normal)
        nameLabel?.text = employee.name + " " + employee.surname
        posititonLabel?.text = employee.job
        
        let avatarUrl = TrombiApiRequests.baseUrl + employee.avatarUrl
        topBlurredImageView?.sd_setImage(with: URL(string: avatarUrl), completed: nil)
        userImageView?.sd_setImage(with: URL(string: avatarUrl), completed: nil)
    }

    fileprivate func addReminderBirthdayEvent() {
        showAddEventConfirmAlert(confirmed: {
            self.addBirthdayEvent()
        })
    }

    private func addBirthdayEvent() {
        guard let employee = employee else {
            fatalError("Employee is not setup in EmployeeProfileViewController")
        }

        let eventStore: EKEventStore = EKEventStore()

        eventStore.requestAccess(to: .event) { (granted, error) in

            guard granted, error == nil else {
                DispatchQueue.main.async {
                    self.showAddEventFailAlert()
                }
                return
            }

            let userBirthday = employee.birthday

            let currentCalendar = Calendar.current
            let currentYear = currentCalendar.component(.year, from: Date())

            let startDate = currentCalendar.date(bySetting: .year,
                                                 value: currentYear,
                                                 of: userBirthday)

            let event: EKEvent = EKEvent(eventStore: eventStore)

            let numberOfSecondsInDay: TimeInterval = 86400.0
            let numberOfSecondsInHour: TimeInterval = 3600.0

            event.title = "Birthday of \(employee.fullName)"
            event.startDate = startDate
            event.endDate = startDate?.addingTimeInterval(numberOfSecondsInDay)
            event.addRecurrenceRule(EKRecurrenceRule(recurrenceWith: .yearly, interval: 1, end: nil))
            event.notes = "Added from Trombi app"
            event.addAlarm(EKAlarm(relativeOffset: -3.0 * numberOfSecondsInHour))
            event.calendar = eventStore.defaultCalendarForNewEvents

            do {
                try eventStore.save(event, span: .thisEvent)

                let alertController = UIAlertController(title: "Reminder",
                                                        message: "Reminder event has been added to the calendar",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK",
                                                        style: .default,
                                                        handler: nil))

                self.present(alertController, animated: true)
            } catch _ {
                DispatchQueue.main.async {
                    self.showAddEventFailAlert()
                }
            }
        }

    }

    fileprivate func showAddEventConfirmAlert(confirmed: @escaping () -> Void) {
        let alertController = UIAlertController(title: "Reminder",
                                      message: "Add event to the calendar ?",
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: .default,
                                                handler: nil))

        alertController.addAction(UIAlertAction(title: "Add",
                                                style: .default,
                                                handler: { _ in
                                                    confirmed()

        }))

        present(alertController, animated: true)
    }
    
    fileprivate func showAddEventFailAlert() {
        let alertController = UIAlertController(title: "Reminder",
                                                message: "Fail to access calendar, grant an access for Trombi in the settings",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension EmployeeProfileViewController: UITableViewDataSource {

    enum UserProfileSection: Int, CaseIterable {
        case userInfo
        case additionalInfo

        var rows: [UserProfileRow] {
            switch self {
            case .userInfo:
                return [.email]//, .skype, .phone]
            case .additionalInfo:
                return [.birthday, .arrival]
            }
        }
    }

    enum UserProfileRow: String {
        case email = "Email"
//        case skype = "Skype"
//        case phone = "Phone"
        case birthday = "Birthday"
        case arrival = "Arrival"

        var icon: UIImage? {
            switch self {
            case .email:
                return UIImage(named: "icEmail")
//            case .skype:
//                return UIImage(named: "icSkype")
//            case .phone:
//                return UIImage(named: "icPhone")
            case .birthday:
                return UIImage(named: "icBirthday")
            case .arrival:
                return UIImage(named: "icArrival")
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return UserProfileSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userProfileSection = UserProfileSection(rawValue: section) else {
            fatalError("Cannot build UserProfileSection")
        }

        return userProfileSection.rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = UserProfileSection(rawValue: indexPath.section) else {
            fatalError("Cannot build UserProfileSection")
        }

        let userInfoCell: UserInfoTableViewCell = tableView.dequeueReusableCell(for: indexPath)

        guard let user = employee else {
            return userInfoCell
        }

        let row = section.rows[indexPath.row]
        let rowInfo = user[row]

        userInfoCell.titleLabel?.text = row.rawValue
        userInfoCell.iconImageView?.image = row.icon

        userInfoCell.infoLabel?.text = rowInfo

        return userInfoCell
    }

    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView,
                   canPerformAction action: Selector,
                   forRowAt indexPath: IndexPath,
                   withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }

    func tableView(_ tableView: UITableView,
                   performAction action: Selector,
                   forRowAt indexPath: IndexPath,
                   withSender sender: Any?) {
        guard let section = UserProfileSection(rawValue: indexPath.section) else {
            fatalError("Cannot build UserProfileSection")
        }

        guard let user = employee else {
            fatalError("User is not set up")
        }

        let row = section.rows[indexPath.row]
        if action == #selector(copy(_:)) {
            let rowInfo = user[row]

            let pasteboard = UIPasteboard.general
            pasteboard.string = rowInfo
        }
    }
}

// MARK: - UITableViewDelegate
extension EmployeeProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = CGFloat(80.0/733.0) * UIScreen.main.bounds.size.height
        return height < 80.0 ? height : 80.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = UserProfileSection(rawValue: indexPath.section) else {
            fatalError("Cannot build UserProfileSection")
        }

        guard let user = employee else {
            fatalError("User is not set up")
        }

        let row = section.rows[indexPath.row]
        switch row {
//        case .phone:
//            if let phone = user[row] {
//                guard let numberUrl = URL(string: "tel://" + phone) else { return }
//                UIApplication.shared.open(numberUrl, options: [:], completionHandler: { _ in
//                    tableView.deselectRow(at: indexPath, animated: true)
//                })
//            }

        case .email:
            if let email = user[row] {
                if let emailUrl = URL(string: "mailto:\(email)") {
                    UIApplication.shared.open(emailUrl, options: [:], completionHandler: { _ in
                        tableView.deselectRow(at: indexPath, animated: true)
                    })
                }
            }

        case .birthday:
            addReminderBirthdayEvent()
            tableView.deselectRow(at: indexPath, animated: true)

        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension Employee {
    subscript(row: EmployeeProfileViewController.UserProfileRow) -> String? {
        return value(for: row)
    }

    private func value(for row: EmployeeProfileViewController.UserProfileRow) -> String? {
        switch row {
        case .email: return email
//        case .skype: return skype
//        case .phone: return phone
        case .birthday:
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.dateFormat = "MMMM dd"

            return dateFormatter.string(from: birthday)
        case .arrival:
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.dateFormat = "MMMM dd, yyyy"

            return dateFormatter.string(from: arrival)
        }
    }
}
