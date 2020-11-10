//
//  RowData.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 05/11/2020.
//

import Foundation

struct RowData {
    var type: RowType
    var value: String

    init(type: RowType, value: String) {
        self.type = type
        self.value = value
    }
    
}
