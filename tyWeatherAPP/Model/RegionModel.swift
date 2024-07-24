import Foundation

// Model for the API response
struct WeatherResponseforRegion: Codable {
    let current: CurrentWeather
    
    struct CurrentWeather: Codable {
        let temp_c: Double
    }
}

// Model for city weather
struct CityWeather {
    let cityName: String
    let temperature: Double
}

// Model for region weather
struct RegionWeather {
    let regionName: String
    let cities: [CityWeather]
}

// Example regions data
let regions = [
    "Marmara": ["Istanbul", "Bursa", "Sakarya"],
    "İç Anadolu": ["Ankara", "Konya", "Aksaray"],
    "Güneydoğu Anadolu": ["Gaziantep", "Batman", "Mardin"]
]

// Function to fetch temperature for a city
