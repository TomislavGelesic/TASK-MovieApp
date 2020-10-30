//
//  Extensions+MoviesFeedCell.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 28/10/2020.
//

import UIKit

extension MovieFeedTableViewCell {
    
    func fillCell(with movie: Movie) {
        if let imagePath = movie.poster_path {
            self.imageViewMovie.image = UIImage(url: URL(string: Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE + imagePath))
        }
        else {
            self.imageViewMovie.backgroundColor = .white
        }
        self.yearLabel.text = getReleaseYear(releaseDate: movie.release_date)
        self.titleLabel.text = movie.title
    }
    
    private func getReleaseYear(releaseDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: releaseDate) else { return "-1" }
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date)
        return year
    }
    
}
