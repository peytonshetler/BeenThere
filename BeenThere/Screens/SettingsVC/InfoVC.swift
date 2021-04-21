//
//  WhyVC.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 3/27/21.
//

import UIKit

class InfoVC: UITableViewController {

    // MARK: - Properties
    let estimatedRowHeight: CGFloat = 50.0
    var dataSource: UITableViewDiffableDataSource<InfoSection, InfoItem>!

    let persistence = PersistenceService.shared
    
    var text: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureDataSource()
        updateSnapshot()
        configureTableView()
    }
    
    init(text: String, title: String) {
        super.init(style: .insetGrouped)
        self.text = text
        self.title = title
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    // MARK: - Navigation Bar
    func configureNavBar() {
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<InfoSection, InfoItem>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BTTextTVCell.identifier, for: indexPath) as! BTTextTVCell
            
            cell.set(text: self.text)

            return cell
        }
    }


    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<InfoSection, InfoItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems([.main])
        
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }


    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.delegate = self
        tableView.register(BTTextTVCell.self, forCellReuseIdentifier: BTTextTVCell.identifier)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}


enum InfoSection: Int, CaseIterable {
    case main
}

enum InfoItem: CaseIterable {
    case main
}
