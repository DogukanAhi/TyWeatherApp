protocol FetchTemperatureService {
    func fetchTemperature(city: City, completion: @escaping (Result<Double, Error>) -> Void)
}
