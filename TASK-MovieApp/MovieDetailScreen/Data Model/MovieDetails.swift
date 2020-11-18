//
//  MovieDetails.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 30/10/2020.
//

import Foundation

struct MovieDetails: Codable {
    
    var id: Int
    var poster_path: String?
    var title: String
    var overview: String
    var genres: [Genre]
    var tagline: String
    
    init() {
        id = -1
        poster_path = "-1"
        title = "-1"
        overview = "-1"
        genres = [Genre]()
        tagline = "-1"
    }
}
