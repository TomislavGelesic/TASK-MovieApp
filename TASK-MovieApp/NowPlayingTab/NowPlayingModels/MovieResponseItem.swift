//
//  MovieItem.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 30/10/2020.
//

import UIKit

struct MovieResponseItem: Codable {

    var id: Int = -1
    var posterPath: String = ""
    var title: String = ""
    var releaseDate: String = ""
    var overview: String = ""
}
