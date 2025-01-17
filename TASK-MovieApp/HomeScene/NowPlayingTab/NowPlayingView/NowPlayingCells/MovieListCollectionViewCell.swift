
import UIKit
import SnapKit
import Kingfisher
import Combine

class MovieListCollectionViewCell: UICollectionViewCell {
    
    var preferenceChanged: ((PreferenceType, Bool) -> ())?
    
    let imageViewMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let gradientOverlay: ShadeGradientOverlayView = {
        let overlay = ShadeGradientOverlayView(direction: .topToBottom)
        return overlay
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        return label
    }()
    
    let favouriteButton: UIButton = {
        let favouriteButton = UIButton()
        favouriteButton.accessibilityLabel = "favourite"
        favouriteButton.layer.cornerRadius = 20
        favouriteButton.setImage(UIImage(named: "star_unfilled"), for: .normal)
        favouriteButton.setImage(UIImage(named: "star_filled"), for: .selected)
        return favouriteButton
    }()
    
    let watchedButton: UIButton = {
        let watchedButton = UIButton()
        watchedButton.accessibilityLabel = "watched"
        watchedButton.layer.cornerRadius = 20
        watchedButton.setImage(UIImage(named: "watched_unfilled"), for: .normal)
        watchedButton.setImage(UIImage(named: "watched_filled"), for: .selected)
        return watchedButton
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieListCollectionViewCell {
    
    private func setupViews() {
        
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 20
        contentView.addSubviews([titleLabel, descriptionLabel, imageViewMovie, watchedButton, favouriteButton])
        imageViewMovie.addSubview(gradientOverlay)
        gradientOverlay.addSubview(yearLabel)
        
        setupButtons()
        
        setupConstraints()
    }
    
    private func setupButtons() {
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        watchedButton.addTarget(self, action: #selector(watchedButtonTapped), for: .touchUpInside)
    }
    
    @objc func favouriteButtonTapped() {
        preferenceChanged?(.favourite, favouriteButton.isSelected)
    }
    
    @objc func watchedButtonTapped() {
        preferenceChanged?(.watched, watchedButton.isSelected)
    }
    
    func configure(with item: MovieRowItem) {
        imageViewMovie.setImage(with: Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE + item.imagePath)
        yearLabel.text = item.year
        titleLabel.text = item.title
        descriptionLabel.text = item.overview
        setButtonImage(on: .favourite, selected: item.favourite)
        setButtonImage(on: .watched, selected: item.watched)
    }
    
    private func setButtonImage(on type: PreferenceType, selected: Bool) {
        switch type {
        case .favourite: favouriteButton.isSelected = selected
        case .watched: watchedButton.isSelected = selected
        }
    }
    
    //MARK: Constraints
    private func setupConstraints() {        
        imageViewConstraints()
        overlayConstraints()
        titleLabelCOnstraints()
        descriptionLabelCOnstraints()
        favouriteButtonConstraints()
        yearLabelConstraints()
        watchedButtonConstraints()
    }
    
    private func imageViewConstraints() {
        
        imageViewMovie.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(contentView.frame.height * 3/5)
        }
    }
    
    private func overlayConstraints() {
        
        gradientOverlay.snp.makeConstraints { (make) in
            make.edges.equalTo(imageViewMovie)
        }
    }
    
    private func favouriteButtonConstraints() {
        
        favouriteButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(gradientOverlay)
            make.trailing.equalTo(gradientOverlay).offset(-5)
            make.width.height.equalTo(50)
        }
    }
    
    private func yearLabelConstraints() {
        
        yearLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(gradientOverlay)
            make.centerX.equalTo(gradientOverlay)
        }
    }
    
    private func watchedButtonConstraints() {
        
        watchedButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(gradientOverlay)
            make.leading.equalTo(gradientOverlay).offset(5)
            make.width.height.equalTo(50)
        }
    }
    
    private func titleLabelCOnstraints() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageViewMovie.snp.bottom).offset(10)
            make.leading.equalTo(contentView).offset(10)
            make.trailing.equalTo(contentView).offset(-10)
            
        }
    }
    
    private func descriptionLabelCOnstraints() {
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.leading.trailing.equalTo(contentView).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
    
}


