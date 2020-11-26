//
//  RowItemDetailMovie.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 25.11.2020..
//

import Foundation

struct RowItemDetailMovie<RowItemDetailMovieTypes, V> {
    var type: RowItemDetailMovieTypes
    var value: V
    
    init(type: RowItemDetailMovieTypes, value: V) {
        self.type = type
        self.value = value
    }
    
}
