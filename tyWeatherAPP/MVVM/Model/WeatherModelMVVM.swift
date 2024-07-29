import UIKit

struct WeatherResponseMVVM: Codable {
    let current: CurrentWeather
}

struct CurrentWeatherMVVM: Codable {
    let temp_c: Double
}

struct WeatherModelMVVM: Codable, Equatable {
    let cityName: String
    let tempCelcius: Double
    let conditionImageData: Data
    var conditionImage: UIImage? {
        return UIImage(data: conditionImageData)
    }
    init(cityName: String, tempCelcius: Double, conditionImage: UIImage) {
        self.cityName = cityName
        self.tempCelcius = tempCelcius
        self.conditionImageData = conditionImage.pngData()!
    }
}

protocol WeatherModelDelegateMVVM: AnyObject {
    func favoriteTapped(for model: WeatherModelMVVM)
    func isFavorite(cityName: String) -> Bool
}
