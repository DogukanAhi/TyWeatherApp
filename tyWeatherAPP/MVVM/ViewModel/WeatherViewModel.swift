import UIKit

class WeatherViewModel: UIViewController {
    private var models = [WeatherModelMVVM]()
    var updateUI: (() -> Void)?
    private let temperatureService: FetchTemperatureService
    
    init(temperatureService: FetchTemperatureService) {
        self.temperatureService = temperatureService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadFavorites() {
        updateUI?()
    }
    
    func saveFavorites() {
        Constants.favoriteCityNames = Constants.favoriteCityNames
        updateUI?()
    }
    
    func fetchWeather(for city: City, completion: @escaping () -> Void) {
        temperatureService.fetchTemperature(city: city) { result in
            switch result {
            case .success(let tempC):
                let weatherModel = WeatherModelMVVM(cityName: city.capetalizedRawValue, tempCelcius: tempC, conditionImage: #imageLiteral(resourceName: "clean"))
                if !self.models.contains(where: { $0.cityName == weatherModel.cityName }) {
                    self.models.append(weatherModel)
                }
                completion()
            case .failure(let error):
                self.presentAlert(title: "Error", message: error.localizedDescription)
                completion()
            }
        }
    }
    
    func favoriteTapped(for model: WeatherModelMVVM) {
        var favoriteCityNames = Constants.favoriteCityNames
        if let index = favoriteCityNames.firstIndex(of: model.cityName) {
            favoriteCityNames.remove(at: index)
        } else {
            favoriteCityNames.append(model.cityName)
        }
        Constants.favoriteCityNames = favoriteCityNames
        saveFavorites()
    }
    
    func isFavorite(cityName: String) -> Bool {
        return Constants.favoriteCityNames.contains(cityName)
    }
    
    func getFetchedWeathers(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        fetchWeather(for: .ankara) {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchWeather(for: .gaziantep) {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchWeather(for: .istanbul) {
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func filteredModels(for segmentIndex: Int) -> [WeatherModelMVVM] {
        switch segmentIndex {
        case 1:
            return models.filter { isFavorite(cityName: $0.cityName) }
        default:
            return models
        }
    }
}

extension WeatherViewModel: AlertPresentable {
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
