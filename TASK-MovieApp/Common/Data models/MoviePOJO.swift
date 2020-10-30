//
//  MoviePOJO.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit

struct MoviePOJO: Codable {

    var page: Int
    var results: [Movie]
    var dates: Dates
    var total_pages: Int
    var total_results: Int
    
}
