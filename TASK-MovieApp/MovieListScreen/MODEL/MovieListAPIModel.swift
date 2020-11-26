//
//  MovieList.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit

struct MovieListAPIModel: Codable {

    var results: [MovieAPIModel]
    var dates: Dates
    var total_pages: Int
    var total_results: Int
}
