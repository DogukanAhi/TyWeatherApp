import Foundation

struct WeatherResponseforRegion: Codable {
    let current: CurrentWeather
    
    struct CurrentWeather: Codable {
        let temp_c: Double
    }
}

struct CityWeather {
    let cityName: String
    let temperature: Double
}

struct RegionWeather {
    let regionName: String
    let cities: [CityWeather]
}

let regions = [
    "Marmara": ["Istanbul", "Bursa", "Sakarya"],
    "İç Anadolu": ["Ankara", "Konya", "Aksaray"],
    "Güneydoğu Anadolu": ["Gaziantep", "Batman", "Mardin"]
]
