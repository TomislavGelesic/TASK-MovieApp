
import UIKit
import SnapKit
import Combine

class ImageCellMovieDetail: UITableViewCell {
    
    var preferenceChanged: ((PreferenceType, Bool) -> ())?
    
    var backButtonTapped: (()->())?
    
    let imageViewMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let gradientOverlay: ShadeGradientOverlayView = {
        let overlay = ShadeGradientOverlayView(direction: .bottomToTop)
        return overlay
    }()
    
    let favouriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "star_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(UIImage(named: "star_filled")?.withRenderingMode(.alwaysOriginal), for: .selected)
        button.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let watchedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "watched_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(UIImage(named: "watched_filled")?.withRenderingMode(.alwaysOriginal), for: .selected)
        button.addTarget(self, action: #selector(watchedButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let backButton: UIButton = {
        let buttonImage = UIImage(named: "arrow-left")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large))
        let button = UIButton()
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(returnToParent), for: .touchUpInside)
        return button
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
        
        contentView.backgroundColor = .black
        
        contentView.addSubviews([imageViewMovie, favouriteButton, watchedButton, backButton])
        
        imageViewMovie.addSubview(gradientOverlay)
        
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
    
    @objc func returnToParent() {
        self.removeFromSuperview()
    }
    
    private func setImageViewMovieConstraints() {
        
        imageViewMovie.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
            make.height.equalTo(300)
        }
    }
    
    private func setGradientOverlayConstraints() {
        
        gradientOverlay.snp.makeConstraints { (make) in
            make.edges.equalTo(imageViewMovie)
        }
    }
    
    private func setButtonsConstraints() {
        
        favouriteButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.bottom.equalTo(contentView).offset(-10)
            make.width.height.equalTo(50)
        }
        
        watchedButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(-10)
            make.trailing.equalTo(favouriteButton.snp.leading).offset(-15)
            make.width.height.equalTo(50)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.leading.top.equalTo(contentView).offset(15)
            make.width.height.equalTo(50)
        }
    }
}


extension ImageCellMovieDetail {
    
    func configure(with imagePath: String, isFavourite: Bool, isWatched: Bool) {
        
        imageViewMovie.setImage(with: imagePath)
        
        favouriteButton.isSelected = isFavourite
        
        watchedButton.isSelected = isWatched
    
    }
}
