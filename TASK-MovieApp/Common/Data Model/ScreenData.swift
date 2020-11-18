//
//  RowData.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 05/11/2020.
//

import Foundation

struct ScreenData<POSSIBLE_TYPE, VALUE_TYPE> {
    var type: POSSIBLE_TYPE
    var value: VALUE_TYPE

    init(type: POSSIBLE_TYPE, value: VALUE_TYPE) {
        self.type = type
        self.value = value
    }
    
}
