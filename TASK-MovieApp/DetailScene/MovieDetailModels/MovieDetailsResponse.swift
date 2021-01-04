//
//  MovieDetailsJSON.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 05/11/2020.
//

import Foundation

struct MovieDetailsResponse: Codable {
    
    var id: Int = -1
    var posterPath: String?
    var title: String = ""
    var overview: String = ""
    var genres = [Genre]()
    var tagline: String = ""
    
}
