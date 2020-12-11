
import UIKit
import SnapKit


class MovieDetailImageCell: UITableViewCell {
    
    //MARK: Properties
    
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
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "left_arrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let favouriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "star_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(UIImage(named: "star_filled")?.withRenderingMode(.alwaysOriginal), for: .selected)
        return button
    }()
    
    let watchedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "watched_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(UIImage(named: "watched_filled")?.withRenderingMode(.alwaysOriginal), for: .selected)
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

extension MovieDetailImageCell {
    
    //MARK: Private Functions
    private func setupViews() {
        
        contentView.backgroundColor = .black
        
        contentView.addSubview(imageViewMovie)
        imageViewMovie.addSubview(gradientOverlay)
        contentView.addSubviews([backButton, favouriteButton, watchedButton])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        watchedButton.addTarget(self, action: #selector(watchedButtonTapped), for: .touchUpInside)
        
        imageViewMovieConstraints()
        gradientOverlayConstraints()
        backButtonConstraints()
        favouriteButtonConstraints()
        watchedButtonConstraints()
    }
    
    //MARK: Constraints
    
    private func imageViewMovieConstraints() {
        
        imageViewMovie.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
            make.height.equalTo(300)
        }
    }
    
    private func gradientOverlayConstraints() {
        
        gradientOverlay.snp.makeConstraints { (make) in
            make.edges.equalTo(imageViewMovie)
        }
    }
    
    private func backButtonConstraints() {
        
        backButton.snp.makeConstraints { (make) in
            make.top.leading.equalTo(gradientOverlay).offset(10)
            make.width.height.equalTo(40)
        }
    }
    
    private func favouriteButtonConstraints() {
        
        favouriteButton.snp.makeConstraints { (make) in
            make.top.trailing.equalTo(gradientOverlay).inset(UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10))
            make.width.height.equalTo(40)
        }
    }
    
    private func watchedButtonConstraints() {
        
        watchedButton.snp.makeConstraints { (make) in
            make.top.equalTo(gradientOverlay).offset(10)
            make.trailing.equalTo(favouriteButton.snp.leading).offset(-10)
            make.width.height.equalTo(40)
        }
    }
}


extension MovieDetailImageCell {
    //MARK: Functions
    
    func configure(with info: MovieDetailInfo) {
        
        setButtonImage(on: .favourite, selected: info.favourite)
        
        setButtonImage(on: .watched, selected: info.watched)        
        
        imageViewMovie.setImage(with: info.imagePath)
    
    }
    
    private func setButtonImage(on type: ButtonType, selected: Bool) {
        
        switch type {
        case .favourite:
            favouriteButton.isSelected = selected
        case .watched:
            watchedButton.isSelected = selected
        }
    }
    
    //MARK: Delegate methods
    @objc func backButtonTapped() {
        #warning("ADD FUNCTIONALITY")
    }
    
    @objc func favouriteButtonTapped() {
        
        switch favouriteButton.isSelected {
        case true:
            favouriteButton.isSelected = false
        case false:
            favouriteButton.isSelected = true
        }
        #warning("update coreData")
    }
    
    @objc func watchedButtonTapped() {
        switch watchedButton.isSelected {
        case true:
            watchedButton.isSelected = false
        case false:
            watchedButton.isSelected = true
        }
        
        #warning("update coreData")
        
    }
    
}
