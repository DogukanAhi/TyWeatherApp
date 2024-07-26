import UIKit

class WeatherCellMVVM: UICollectionViewCell {
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var onFavoriteButtonTapped: ((WeatherModelMVVM) -> Void)? // MARK: onFavoritButtonTapped ve isFavorite callback olarak tanımlandı.
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
  }
