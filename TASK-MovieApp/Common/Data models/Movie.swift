//
//  Movie.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit


struct Movie: Codable {
    //MARK: Properties
    var id: Int
    var poster_path: String?
    var title: String
    var release_date: String
    
}
