//
//  Constants.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 30/10/2020.
//

import Foundation

class Constants{
    
    struct MOVIE_API {
        static let MOVIE_BASE = "https://api.themoviedb.org/3"
        static let KEY = "?api_key=7641bf39b204ff74468bc996eaad0b04"
        static let GET_NOW_PLAYING = "/movie/now-playing"
        static let GET_DETAILS_ON = "/movie/"
        
        static let IMAGE_BASE = "https://image.tmdb.org/t/p"
        static let IMAGE_SIZE = "/w500"
    }
    
}
