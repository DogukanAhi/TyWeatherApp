import UIKit

class WeatherViewModel {
    private(set) var models = [WeatherModelMVVM]()
    private var favoriteCityNames = [String]()
    
    var updateUI: (() -> Void)?
    
    func loadFavorites() {
        guard let savedFavorites = UserDefaults.standard.object(forKey: "favorites") as? [String] else { return }
        favoriteCityNames = savedFavorites
    }
    
    func saveFavorites() {
        UserDefaults.standard.set(favoriteCityNames, forKey: "favorites")
        NotificationCenter.default.post(name: NSNotification.Name("favorites"), object: nil, userInfo: ["favorites": favoriteCityNames])
    }
    
    func fetchWeather(for city: City, completion: @escaping () -> Void) {
        fetchTemperature(city: city) { result in
            switch result {
            case .success(let tempC):
                let weatherModel = WeatherModelMVVM(cityName: city.capetalizedRawValue, tempCelcius: tempC, conditionImage: #imageLiteral(resourceName: "clean"))
                if !self.models.contains(where: { $0.cityName == weatherModel.cityName }) {
                    self.models.append(weatherModel)
                }
                completion()
            case .failure(let error):
                print("Error fetching temperature: \(error)")
                completion()
            }
        }
    }
    
    func favoriteTapped(for model: WeatherModelMVVM) {
        if let index = favoriteCityNames.firstIndex(of: model.cityName) {
            favoriteCityNames.remove(at: index)
        } else {
            favoriteCityNames.append(model.cityName)
        }
        saveFavorites()
        updateUI?()
    }
    
    func isFavorite(cityName: String) -> Bool {
        return favoriteCityNames.contains(cityName)
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
}
