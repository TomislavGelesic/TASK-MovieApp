//
//  MovieDetailScreenRowData.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 05/11/2020.
//

import Foundation

struct MovieDetailScreenRowData<T, V> {
    var type: T
    var value: V

    init(type: T, value: V) {
        self.type = type
        self.value = value
    }
    
}
