import UIKit

class WeatherCellMVVM: UICollectionViewCell {
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var onFavoriteButtonTapped: ((WeatherModelMVVM) -> Void)?
    var isFavorite: ((String) -> Bool)?
    var model: WeatherModelMVVM?
    
    func configure(with model: WeatherModelMVVM, isFavorite: @escaping (String) -> Bool, onFavoriteButtonTapped: @escaping (WeatherModelMVVM) -> Void) {
        self.model = model
        self.isFavorite = isFavorite
        self.onFavoriteButtonTapped = onFavoriteButtonTapped
        degreeLabel.text = String(model.tempCelcius) + "°C"
        cityLabel.text = model.cityName
        weatherImage.image = model.conditionImage
        let favoriteImageName = isFavorite(model.cityName) ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: favoriteImageName), for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    @objc func favoriteButtonTapped() {
        guard let model = model else { return }
        onFavoriteButtonTapped?(model)
    }
    
    func showFavoriteButton() {
        let favoriteButton = UIButton(frame: CGRect(x: contentView.frame.width - 100, y: 0,
                                                    width: 100, height: contentView.frame.height))
        favoriteButton.setTitle("Favorite", for: .normal)
        favoriteButton.backgroundColor = .systemBlue
        favoriteButton.setTitleColor(.white, for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        contentView.addSubview(favoriteButton)
        favoriteButton.transform = CGAffineTransform(translationX: 100, y: 0)
        UIView.animate(withDuration: 0.3, animations: {
            favoriteButton.transform = .identity
        })
    }
}
