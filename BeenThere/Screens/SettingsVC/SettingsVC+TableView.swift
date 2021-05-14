//
//  SettingsVC+TableView.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 3/10/21.
//

import UIKit
import MessageUI

extension SettingsVC {
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<SettingsSection, SettingsItem>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in

            switch item {
            case .greeting:
                return tableView.dequeueReusableCell(withIdentifier: GreetingCell.identifier, for: indexPath) as! GreetingCell
            case .why:
                let cell = tableView.dequeueReusableCell(withIdentifier: BTBasicTVCell.identifier, for: indexPath) as! BTBasicTVCell
                
                cell.set(text: item.description)
                return cell
                
            case .colophon:
                let cell = tableView.dequeueReusableCell(withIdentifier: BTBasicTVCell.identifier, for: indexPath) as! BTBasicTVCell
                
                cell.set(text: item.description)
                return cell
            case .acknowledgements:
                let cell = tableView.dequeueReusableCell(withIdentifier: BTBasicTVCell.identifier, for: indexPath) as! BTBasicTVCell
                
                cell.set(text: item.description)
                return cell
            case .contact:
                let cell = tableView.dequeueReusableCell(withIdentifier: BTSymbolAndLabelTVCell.identifier, for: indexPath) as! BTSymbolAndLabelTVCell

                cell.set(symbol: "envelope.circle.fill", text: item.description)
                return cell
            case .review:
                let cell = tableView.dequeueReusableCell(withIdentifier: BTSymbolAndLabelTVCell.identifier, for: indexPath) as! BTSymbolAndLabelTVCell
                
                cell.set(symbol: "pencil.circle.fill", text: item.description, color: .systemYellow)
                return cell
            }
        }
    }


    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SettingsSection, SettingsItem>()
        snapshot.appendSections(SettingsSection.allCases)

        for section in SettingsSection.allCases {
            snapshot.appendItems(section.items, toSection: section)
        }
        
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }


    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.delegate = self
        tableView.register(GreetingCell.self, forCellReuseIdentifier: GreetingCell.identifier)
        tableView.register(BTBasicTVCell.self, forCellReuseIdentifier: BTBasicTVCell.identifier)
        tableView.register(BTSymbolAndLabelTVCell.self, forCellReuseIdentifier: BTSymbolAndLabelTVCell.identifier)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .greeting: return ()
        case .why:
            let destVC = InfoVC(text: item.text, title: item.description)
            navigationController?.pushViewController(destVC, animated: true)
        case .colophon:
            let destVC = InfoVC(text: item.text, title: item.description)
            navigationController?.pushViewController(destVC, animated: true)
        case .acknowledgements:
            let destVC = InfoVC(text: item.text, title: item.description)
            navigationController?.pushViewController(destVC, animated: true)
        case .contact: self.sendEmail()
        case .review: redirectToAppStore()
        }
    }
    

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        configureFooterView(section: section)
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionType = SettingsSection(rawValue: section)
        
        return sectionType == .app ? 40 : 20
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        configureHeaderView(section: section)
    }


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? smallSectionHeight : largeSectionHeight
    }
    
    
    func configureHeaderView(section: Int) -> UIView? {
        let sectionType = SettingsSection(rawValue: section)
        let headerView = UIView()
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -2)
        ])
        
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.withRoundedFont(size: 18)
        headerView.backgroundColor = .clear
        
        if sectionType == .greeting {
            label.text = ""
        } else if sectionType == .info {
            label.text = "INFO"
        } else {
            label.text = "APP"
        }
        
        return headerView
    }
    
    func configureFooterView(section: Int) -> UIView? {
        let sectionType = SettingsSection(rawValue: section)
        let footerView = UIView()
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: footerView.bottomAnchor)
        ])
        
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.withRoundedFont(size: 18)
        footerView.backgroundColor = .clear
        
        if sectionType == .greeting {
            label.text = ""
        } else if sectionType == .info {
            label.text = ""
        } else {
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                label.text = "version \(version)"
            }
        }
        
        return footerView
    }

}


extension SettingsVC: MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["peyton.shetler@gmail.com"])
            mail.setMessageBody("<p>Hey Peyton,</p>", isHTML: true)

            present(mail, animated: true)
            self.tableView.deselectRow(at: [2, 0], animated: true)
        } else {
            self.tableView.deselectRow(at: [2, 0], animated: true)
            presentBTErrorAlertOnMainThread(error: .cantSendEmail, completion: nil)
        }
    }
    

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.tableView.deselectRow(at: [2, 0], animated: true)
        controller.dismiss(animated: true)
    }
    
    
    func redirectToAppStore() {
        let appStoreId = "1564359482"
        let url = URL(string: "itms://itunes.apple.com/app/\(appStoreId)")

        if let url = url {
            UIApplication.shared.open((url), options:[:], completionHandler: nil)
            self.tableView.deselectRow(at: [2, 1], animated: true)
        } else {
            self.tableView.deselectRow(at: [2, 1], animated: true)
        }
    }
}


enum SettingsSection: Int, CaseIterable {
    case greeting
    case info
    case app

    var items: [SettingsItem] {
        switch self {
        case .greeting: return [.greeting]
        case .info: return [.why, .colophon, .acknowledgements]
        case .app: return [.contact, .review]
        }
    }
}

enum SettingsItem: CaseIterable, CustomStringConvertible {
    case greeting
    case why
    case colophon
    case acknowledgements
    case contact
    case review
    
    var description: String {
        switch self {
        case .greeting: return "Greeting"
        case .why: return "Why?"
        case .colophon: return "Colophone"
        case .acknowledgements: return "Acknowledgements"
        case .contact: return "Contact"
        case .review: return "Leave a Review"
        }
    }
    
    var text: String {
        switch self {
        case .greeting, .contact, .review: return ""
        case .why:
            return """
                Why did I build BeenThere? Great question. Originally, it was a tool for touring musicians to remember the great places they'd found while on the road. Since then, the vision has grown to become a tool that can be used by anyone.

                My hopes are that this tool would create enough convenience that users have more time with each other.
            """
        case .colophon:
            return """
                BeenThere was written entirely in Swift using Apple's Xcode IDE. The UI is entirely programmatic via UIKit (no storyboards were harmed in the making of this app).

                For those interested, it was built on a 13" 2019 Macbook Pro with 8GB of ram and 2.4 GHz Quad-Core Intel i5.
            """
        case .acknowledgements:
            return """
                BeenThere was developed independently by me, Peyton Shetler.

                Along the way, I've had so much support in the creation of this app. I thank God for the oppurtunity to create and for inspiring me in the times when I felt I had nothing left to give.  And, of course, I want to thank my beautiful wife, who gladly sacrificed time together for me to finish this labor of love. She had so much input into this project and pushed me to finish it when I felt like giving up.  And I'd like to thank my friend and iOS mentor, Jacob. He's a wealth of knowledge and wisdom who went out of his way to teach a total stranger all about the crazy world of mobile development. And a huge thank you to all my friends that encouraged me during the development process and put up with all my user/feature questions.

                This project has been a long time coming and it's only the beginning!
            """
        }
    }
}
