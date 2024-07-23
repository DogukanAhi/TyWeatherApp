import UIKit

struct WeatherResponse: Codable {
    let current: CurrentWeather
}
struct CurrentWeather: Codable {
    let temp_c: Double
}
struct WeatherModel: Codable, Equatable {
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
protocol WeatherModelDelegate: AnyObject { // MARK: delegate protocol
    func favoriteTapped(for model: WeatherModel)
    func isFavorite(cityName: String) -> Bool
}
