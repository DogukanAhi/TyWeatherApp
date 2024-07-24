import UIKit
import Foundation

enum City: String {
    case ankara
    case istanbul
    case gaziantep
    var capetalizedRawValue : String {
        return rawValue.capitalized
    }
}

func fetchTemperature(city: City, completion: @escaping (Result<Double, Error>) -> Void) {
    let urlString = "http://api.weatherapi.com/v1/current.json?key=4ee4681c88bb4740bea75659242207&q=\(city.capetalizedRawValue))&aqi=no"
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        if let data = data {
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                // keyDecodingStrategy = .convertFromSnakeCase
                let tempC = weatherResponse.current.temp_c
                completion(.success(tempC))
            } catch {
                completion(.failure(error))
            }
        }
    }
    task.resume()
}
  func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) { // MARK: Work in Progress
       let task = URLSession.shared.dataTask(with: url) { data, response, error in
           if let data = data, let image = UIImage(data: data) {
               completion(image)
           } else {
               completion(nil)
           }
       }
       task.resume()
}

func fetchTemperatureWithCityName(city: String, completion: @escaping (Result<Double, Error>) -> Void) {
    let urlString = "http://api.weatherapi.com/v1/current.json?key=4ee4681c88bb4740bea75659242207&q=\(city)&aqi=no"
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        if let data = data {
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                let tempC = weatherResponse.current.temp_c
                completion(.success(tempC))
            } catch {
                completion(.failure(error))
            }
        }
    }
    task.resume()
}
func fetchTemperatureForCity(_ city: String, completion: @escaping (Result<Double, Error>) -> Void) {
    let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let urlString = "http://api.weatherapi.com/v1/current.json?key=4ee4681c88bb4740bea75659242207&q=\(encodedCity)&aqi=no"
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
            return
        }
        do {
            let weatherResponse = try JSONDecoder().decode(WeatherResponseforRegion.self, from: data)
            let tempC = weatherResponse.current.temp_c
            completion(.success(tempC))
        } catch {
            completion(.failure(error))
        }
    }
    task.resume()
}

// Function to fetch weather data for all regions
func fetchWeatherDataForRegions(completion: @escaping ([RegionWeather]?, [Error]) -> Void) {
    var regionWeatherList = [RegionWeather]()
    var errors = [Error]()
    let dispatchGroup = DispatchGroup()
    
    for (regionName, cities) in regions {
        var cityWeatherList = [CityWeather]()
        
        for city in cities {
            dispatchGroup.enter()
            fetchTemperatureForCity(city) { result in
                switch result {
                case .success(let temperature):
                    cityWeatherList.append(CityWeather(cityName: city, temperature: temperature))
                case .failure(let error):
                    errors.append(error)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let regionWeather = RegionWeather(regionName: regionName, cities: cityWeatherList)
            regionWeatherList.append(regionWeather)
            
            if regionWeatherList.count == regions.count {
                completion(regionWeatherList, errors)
            }
        }
    }
}
