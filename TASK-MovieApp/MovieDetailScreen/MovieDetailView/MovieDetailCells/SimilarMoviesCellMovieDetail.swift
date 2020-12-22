//
//  SimilarMoviesCellMovieDetail.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 16.12.2020..
//


import UIKit
import SnapKit

class SimilarMoviesCellMovieDetail: UITableViewCell {
    
    var similarMovies = [MovieRowItem]()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }()
    
    private let similarMoviesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .black
        collectionView.register(SimilarMoviesCollectionViewCell.self, forCellWithReuseIdentifier: SimilarMoviesCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MovieDetailTitleCell required init failed...")
    }
}

extension SimilarMoviesCellMovieDetail {
    
    func configure(with newSimilarMovies: [MovieRowItem]) {
        
        similarMovies = newSimilarMovies
        similarMoviesCollectionView.reloadData()
    }
    
    private func setupCollectionView() {
        
        similarMoviesCollectionView.collectionViewLayout = flowLayout
        
        similarMoviesCollectionView.dataSource = self
        
        similarMoviesCollectionView.delegate = self
        
        contentView.addSubview(similarMoviesCollectionView)
        
        movieCollectionViewConstraints()
    }
    
    private func movieCollectionViewConstraints () {
        
        similarMoviesCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
            make.height.equalTo(contentView.frame.width)
        }
    }
}

extension SimilarMoviesCellMovieDetail: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return similarMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SimilarMoviesCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
       
        cell.configure(with: similarMovies[indexPath.row])

        return cell
    }
    
}

extension SimilarMoviesCellMovieDetail: UICollectionViewDelegate {

}

extension SimilarMoviesCellMovieDetail: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (similarMoviesCollectionView.frame.width - 30) / 2
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

