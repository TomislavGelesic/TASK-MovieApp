//
//  DetailScreenData.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 20.11.2020..
//

import Foundation

struct DetailScreenData {
    
    var rowData: [MovieDetailScreenRowData<MovieDetailScreenRowTypes, String>]
    var watched: Bool
    var favourite: Bool
    var id: Int64
}
