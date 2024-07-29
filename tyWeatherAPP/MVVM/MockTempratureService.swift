import Foundation
class MockTemperatureService: FetchTemperatureService {
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
                    let tempC = weatherResponse.current.temp_c
                    completion(.success(tempC))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
