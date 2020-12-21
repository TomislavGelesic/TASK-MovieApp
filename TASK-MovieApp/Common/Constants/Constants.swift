//
//  Constants.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 30/10/2020.
//

import Foundation

struct Constants{
    
    struct MOVIE_API {
        
        static let BASE = "https://api.themoviedb.org/3"
        
        static let KEY = "?api_key=" + "4617a9109b768c9ce1ad78db16003afa" // another key "7641bf39b204ff74468bc996eaad0b04"
        
        static let GET_NOW_PLAYING = "/movie/now_playing"
        
        static let GET_SIMILAR = "/similar"
        
        static let GET_MOVIE_BY = "/movie/"
        
        static let IMAGE_BASE = "https://image.tmdb.org/t/p"
        
        static let IMAGE_SIZE = "/w500"
    }
}
