
import UIKit
import SnapKit
import Combine

class ImageCellMovieDetail: UITableViewCell {
    
    var preferenceChanged: ((PreferenceType, Bool) -> ())?
    
    var backButtonTapped: (()->())?
    
    let imageViewMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let gradientOverlay: ShadeGradientOverlayView = {
        let overlay = ShadeGradientOverlayView(direction: .bottomToTop)
        return overlay
    }()
    
    let favouriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "star_unfilled"), for: .normal)
        button.setImage(UIImage(named: "star_filled"), for: .selected)
        return button
    }()
    
    let watchedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "watched_unfilled"), for: .normal)
        button.setImage(UIImage(named: "watched_filled"), for: .selected)
        return button
    }()
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    //MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension ImageCellMovieDetail {
    
    private func setupViews() {
        
        backgroundColor = .black
        
        contentView.addSubview(container)
        
        container.addSubviews([imageViewMovie, favouriteButton, watchedButton])
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        watchedButton.addTarget(self, action: #selector(watchedButtonTapped), for: .touchUpInside)
        
        imageViewMovie.addSubview(gradientOverlay)
        
        setContainerConstraints()
        setImageViewMovieConstraints()
        setGradientOverlayConstraints()
        setButtonsConstraints()
    }
    
    @objc func favouriteButtonTapped() {
        
        preferenceChanged?(.favourite, favouriteButton.isSelected)
    }
    
    @objc func watchedButtonTapped() {
        
        preferenceChanged?(.watched, watchedButton.isSelected)
    }
    
    
    func configure(with imagePath: String, isFavourite: Bool, isWatched: Bool) {
        
        imageViewMovie.setImage(with: imagePath)
        
        favouriteButton.isSelected = isFavourite
        
        watchedButton.isSelected = isWatched
    
    }
    
    private func setContainerConstraints() {
        
        container.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
            make.height.equalTo(400)
        }
    }
    
    private func setImageViewMovieConstraints() {
        
        imageViewMovie.snp.makeConstraints { (make) in
            make.edges.equalTo(container)
        }
    }
    
    private func setGradientOverlayConstraints() {
        
        gradientOverlay.snp.makeConstraints { (make) in
            make.edges.equalTo(imageViewMovie)
        }
    }
    
    private func setButtonsConstraints() {
        
        favouriteButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(container).offset(-15)
            make.top.equalTo(container).offset(10)
            make.width.height.equalTo(50)
        }
        
        watchedButton.snp.makeConstraints { (make) in
            make.top.equalTo(container).offset(10)
            make.trailing.equalTo(favouriteButton.snp.leading).offset(-15)
            make.width.height.equalTo(50)
        }
    }
}

