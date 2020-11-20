//
//  MovieItem.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 30/10/2020.
//

import UIKit

struct MovieItem: Codable {

    var id: Int
    var poster_path: String?
    var title: String
    var release_date: String
    var overview: String
}
