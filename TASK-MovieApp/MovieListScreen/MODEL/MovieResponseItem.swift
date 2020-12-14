//
//  MovieItem.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 30/10/2020.
//

import UIKit

struct MovieResponseItem: Codable {

    var id: Int = -1
    var poster_path: String = ""
    var title: String = ""
    var release_date: String = ""
    var overview: String = ""
}
