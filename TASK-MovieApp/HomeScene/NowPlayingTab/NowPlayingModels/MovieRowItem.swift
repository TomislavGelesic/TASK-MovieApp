//
//  MovieRowItem.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 12.12.2020..
//

import UIKit

class MovieRowItem {
    
    var id: Int64 = 0
    var favourite: Bool = false
    var watched: Bool = false
    var imagePath: String = ""
    var title: String = ""
    var year: String = ""
    var overview: String = ""
    
    init(id: Int64 = -1, favourite: Bool = false, watched: Bool = false, imagePath: String = "", title: String = "", year: String = "", overview: String = "") {
        
        self.id = id
        self.favourite = favourite
        self.watched = watched
        self.imagePath = imagePath
        self.title = title
        self.year = year
        self.overview = overview
    }
    
    init(_ movie: Movie) {
        
        self.id = Int64(movie.id)
        
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
    
    init(_ movie: MovieResponseItem) {
        
        self.id = Int64(movie.id)
        self.imagePath = movie.posterPath
        self.title = movie.title
        self.year = getReleaseYear(releaseDate: movie.releaseDate)
        self.overview = movie.overview
        self.favourite = false
        self.watched = false
    
    }
    
    private func getReleaseYear(releaseDate: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: releaseDate) else { return "-1" }
        
        dateFormatter.dateFormat = "yyyy"
        
        return dateFormatter.string(from: date)
    }
}


