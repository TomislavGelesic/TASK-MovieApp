//
//  MovieFeedScreenData.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 05/11/2020.
//

import UIKit

struct MovieFeedScreenDatum {
    var id: Int
    var poster_path: String?
    var title: String
    var release_date: String
    var overview: String
    var genre_ids: [Int]
    var favourite: Bool
    var watched: Bool

}
