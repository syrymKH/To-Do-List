//
//  TableViewControllerForDetailsView.swift
//  tableViewToDoListProject
//
//  Created by Syrym Khamzin on 14.04.2023.
//

import UIKit

class TableViewControllerForDetailsView: UITableViewController {
    
    let copyTableViewController1 = TableViewController1()
    
    var titleFromTVC: String?
    var timeFromTVC: String?
    var dateFromTVC: String?
    var commentsFromTVC: String?
    var myArrayData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if myArrayData.isEmpty == false {}
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var cCell = cell.defaultContentConfiguration()
        
        switch indexPath.row {
        case 0:
            cCell.text = "Title \(titleFromTVC ?? "")"
        case 1:
            cCell.text = "Time \(timeFromTVC ?? "")"
        case 2:
            cCell.text = "Date \(dateFromTVC ?? "")"
        case 3:
            cCell.text = "Comments \(commentsFromTVC ?? "")"
        default:
            break
        }
        
        cell.contentConfiguration = cCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "TASK DETAILS"
        default:
            return "Default"
        }
    }
}
