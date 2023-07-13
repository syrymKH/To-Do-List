//
//  DataStructures.swift
//  tableViewToDoListProject
//
//  Created by Syrym Khamzin on 10.04.2023.
//

import Foundation

struct DataStructures: Codable {
    var id: Int
    var title: String
    var selected: Bool = false
    var date: String
    var time: String
    var comments: String
}

