//
//  MovieRowItem.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 12.12.2020..
//

import UIKit

class MovieRowItem {
    
    var id: Int64 = 0
    var genreIDs: String = ""
    var favourite: Bool = false
    var watched: Bool = false
    var imagePath: String = ""
    var title: String = ""
    var year: String = ""
    var overview: String = ""
    
    init(id: Int64 = -1, genreIDs: String = "", favourite: Bool = false, watched: Bool = false, imagePath: String = "", title: String = "", year: String = "", overview: String = "") {
        
        self.id = id
        self.genreIDs = genreIDs
        self.favourite = favourite
        self.watched = watched
        self.imagePath = imagePath
        self.title = title
        self.year = year
        self.overview = overview
    }
    
    init(_ movie: Movie) {
        
        self.id = Int64(movie.id)
        
        if let genreIDs = movie.genreIDs {
            self.genreIDs = genreIDs
        }
        self.favourite = movie.favourite
        self.watched = movie.watched
        if let path = movie.imagePath {
            self.imagePath = path
        }
        if let title = movie.title {
            self.title = title
        }
        if let year = movie.year {
            self.year = year
        }
        if let overview = movie.overview{
            self.overview = overview
        }
        
    }
}


