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
    "Marmara": ["Istanbul", "Bursa", "Sakarya", "Kocaeli", "Yalova"],
    "İç Anadolu": ["Ankara", "Konya", "Aksaray", "Karaman", "Sivas"],
    "Güneydoğu Anadolu": ["Gaziantep", "Batman", "Mardin", "Kilis", "Siirt"],
    "Ege": ["Izmir", "Manisa", "Aydin", "Mugla", "Denizli"],
    "Akdeniz": ["Antalya", "Mersin", "Adana", "Hatay", "Isparta"],
    "Karadeniz": ["Trabzon", "Samsun", "Ordu", "Rize", "Zonguldak"],
    "Doğu Anadolu": ["Erzurum", "Van", "Malatya", "Elazig", "Kars"]
]

