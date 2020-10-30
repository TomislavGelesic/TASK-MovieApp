//
//  RowData.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 28/10/2020.
//

import UIKit

enum RowType {
    case image
    case title
    case quote
    case description
    case genre
}

struct RowData {
    var type: RowType
    var value: String

    init(type: RowType, string: String) {
        self.type = type
        self.value = string
    }
    
}
