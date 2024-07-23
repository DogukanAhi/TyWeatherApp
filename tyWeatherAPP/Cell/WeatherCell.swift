import UIKit

class WeatherCell: UICollectionViewCell {
    @IBOutlet private weak var degreeLabel: UILabel! //
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!
    var onFavoriteButtonTapped: ((WeatherModel) -> Void)? // MARK: onFavoritButtonTapped ve isFavorite callback olarak tanımlandı.
      var isFavorite: ((String) -> Bool)?
      var model: WeatherModel?
      
      func configure(with model: WeatherModel, isFavorite: @escaping (String) -> Bool, onFavoriteButtonTapped: @escaping (WeatherModel) -> Void) {
          self.model = model
          self.isFavorite = isFavorite
          self.onFavoriteButtonTapped = onFavoriteButtonTapped
          degreeLabel.text = String(model.tempCelcius)
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
