import UIKit

class CityWeatherCell: UICollectionViewCell {
    
    static let identifier = "CityWeatherCell"
    private var isActive = false
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(weatherImageView)
        contentView.addSubview(cityLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(favoriteButton)
        
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            weatherImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 40),
            weatherImageView.heightAnchor.constraint(equalToConstant: 40),
            
            cityLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 10),
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            temperatureLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 10),
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 5),
            
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        let interaction = UIContextMenuInteraction(delegate: self)
        contentView.addInteraction(interaction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cityWeather: CityWeather) {
        cityLabel.text = cityWeather.cityName
        temperatureLabel.text = "\(cityWeather.temperature)°C"
        weatherImageView.image = UIImage(named: "clean")
    }
    
    @objc private func favoriteButtonTapped() {
        toggleFavorite()
    }
    
    private func toggleFavorite() {
        isActive.toggle()
        let imageName = isActive ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        print("Favorite button tapped for \(cityLabel.text ?? "")")
    }
}

extension CityWeatherCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let actionProvider: UIContextMenuActionProvider = { _ in
            let favoriteActionTitle = self.isActive ? "Remove from Favorites" : "Add to Favorites"
            let favoriteAction = UIAction(title: favoriteActionTitle, image: UIImage(systemName: "star")) { _ in
                self.toggleFavorite()
            }
            return UIMenu(title: "More..", children: [favoriteAction])
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
    }
}
