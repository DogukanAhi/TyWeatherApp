
protocol WeatherService {
    func fetchTemperature(city: City, completion: @escaping (Result<Double, Error>) -> Void)
}

class WeatherServiceImpl: WeatherService {
    func fetchTemperature(city: City, completion: @escaping (Result<Double, Error>) -> Void) {

    }
}
