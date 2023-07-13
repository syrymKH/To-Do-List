//
//  ViewControllerForDetailsView.swift
//  tableViewToDoListProject
//
//  Created by Syrym Khamzin on 13.04.2023.
//

import UIKit

class ViewControllerForDetailsView: UIViewController {
    
    var titleFromTVC: String?
    var timeFromTVC: String?
    var dateFromTVC: String?
    var commentsFromTVC: String?
    
    var titleLabel = UILabel()
    var timeLabel = UILabel()
    var dateLabel = UILabel()
    var commentsLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabelSetup()
        timeLabelSetup()
        dateLabelSetup()
        commentsLabelSetup()
    }
    
    func titleLabelSetup() {
        titleLabel = UILabel(frame: CGRect(x: 20, y: 100, width: view.frame.width - 20, height: 40))
        view.addSubview(titleLabel)
        
        guard let title = titleFromTVC else {
            return
        }
        
        titleLabel.text = title
    }
    
    func timeLabelSetup() {
        timeLabel = UILabel(frame: CGRect(x: 20, y: 160, width: view.frame.width - 20, height: 40))
        view.addSubview(timeLabel)
        
        guard let time = timeFromTVC else {
            return
        }
        
        timeLabel.text = time
    }
    
    func dateLabelSetup() {
        dateLabel = UILabel(frame: CGRect(x: 20, y: 220, width: view.frame.width - 20, height: 40))
        view.addSubview(dateLabel)
        
        guard let date = dateFromTVC else {
            return
        }
        
        dateLabel.text = date
    }
    
    func commentsLabelSetup() {
        commentsLabel = UILabel(frame: CGRect(x: 20, y: 280, width: view.frame.width - 20, height: 40))
        view.addSubview(commentsLabel)
        
        guard let comments = commentsFromTVC else {
            return
        }
        
        commentsLabel.text = comments
    }
}
